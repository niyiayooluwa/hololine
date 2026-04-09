# Hololine

A full-stack inventory and ledger management platform. Hololine lets you create collaborative **workspaces**, manage a **product catalog**, track **stock levels**, and record **financial transactions** — all through a Flutter frontend powered by a Serverpod backend.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [1. Start Infrastructure](#1-start-infrastructure)
  - [2. Run the Server](#2-run-the-server)
  - [3. Run the Flutter App](#3-run-the-flutter-app)
- [Core Modules](#core-modules)
  - [Workspace](#workspace)
  - [Catalog](#catalog)
  - [Inventory](#inventory)
  - [Ledger](#ledger)
- [API Endpoints](#api-endpoints)
- [Frontend Routes](#frontend-routes)
- [Code Generation](#code-generation)
- [Testing](#testing)
- [Deployment](#deployment)
- [Development Conventions](#development-conventions)

---

## Overview

Hololine is built around the concept of **Workspaces** — isolated environments where teams collaborate. Within each workspace, members can:

- Maintain a **product catalog** with SKUs, pricing (kobo-based integers for accuracy), categories, and units
- Track **inventory** levels per catalog item including quantities, valuations, and low-stock thresholds
- Record **ledger transactions** (sales, purchases, adjustments) with atomically linked line items that snapshot product details at the time of the transaction

Access control is role-based (`owner`, `admin`, `member`) and enforced at the service layer.

---

## Architecture

```
hololine/
├── hololine_server/   # Serverpod (Dart) backend
├── hololine_client/   # Auto-generated Dart client library
└── hololine_flutter/  # Flutter frontend
```

The server exposes typed RPC endpoints that the Flutter app calls via the generated client. Every module on the server follows the **Repository → Service → Endpoint** layering:

- **Repository** — all raw database access
- **Service (Usecase)** — business logic, permission checks, validation
- **Endpoint** — authentication gate + thin dispatch to the service

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend framework | [Serverpod](https://serverpod.dev) (Dart) |
| Database | PostgreSQL |
| Cache | Redis |
| Authentication | Serverpod Auth (Email / Password) |
| Email | Mailer (SMTP) |
| Frontend framework | Flutter (Web + Mobile) |
| State management | Hooks Riverpod (`hooks_riverpod`, `riverpod_annotation`) |
| Navigation | GoRouter |
| UI components | Shadcn UI (`shadcn_ui`) |
| Hooks | `flutter_hooks` |

---

## Project Structure

```
hololine/
├── hololine_server/
│   └── lib/src/
│       ├── endpoints/          # Serverpod RPC endpoints
│       │   ├── workspace_endpoint.dart
│       │   ├── catalog_endpoint.dart
│       │   ├── inventory_endpoint.dart
│       │   └── ledger_endpoint.dart
│       ├── models/             # YAML model definitions (Serverpod codegen source)
│       ├── modules/
│       │   ├── workspace/      # Workspace, members, invitations
│       │   ├── catalog/        # Products & inventory
│       │   └── ledger/         # Financial transactions
│       ├── services/           # Cross-cutting services (email, etc.)
│       └── utils/              # Shared helpers & exceptions
│
├── hololine_client/            # Generated — do not edit manually
│
└── hololine_flutter/
    └── lib/
        ├── core/               # Layout shell, shared widgets, themes
        ├── domain/             # Shared domain types & abstractions
        ├── module/
        │   ├── auth/           # Login, signup, verification, password reset
        │   └── workspace/      # Workspace list & dashboard screens
        ├── routing/            # GoRouter configuration
        ├── shared_ui/          # Reusable UI components
        └── utils/              # Flutter-side helpers
```

---

## Getting Started

### Prerequisites

| Tool | Install |
|---|---|
| Dart SDK | https://dart.dev/get-dart |
| Flutter SDK | https://docs.flutter.dev/get-started/install |
| Docker | https://www.docker.com/get-started |
| Serverpod CLI | `dart pub global activate serverpod_cli` |

---

### 1. Start Infrastructure

Spin up Postgres and Redis via Docker Compose from the server directory:

```bash
cd hololine_server
docker compose up --build --detach
```

---

### 2. Run the Server

```bash
cd hololine_server
dart bin/main.dart
```

| Port | Purpose |
|---|---|
| `8080` | REST / RPC API |
| `8081` | Serverpod Insights |
| `8082` | Web server |

To apply pending database migrations on startup:

```bash
dart bin/main.dart --apply-migrations
```

---

### 3. Run the Flutter App

Make sure the server is running, then:

```bash
cd hololine_flutter
flutter run
```

---

## Core Modules

### Workspace

A **Workspace** is the top-level organisational unit. Workspaces can be nested (a workspace may have a `parentId`). Key operations:

- Create standalone or child workspaces
- Invite members via email (token-based)
- Role management: promote / demote members
- Archive, restore, and grace-period–based deletion
- Transfer ownership

**Member roles:** `owner` → `admin` → `member`

---

### Catalog

Products registered in a workspace. Each catalog item carries:

| Field | Notes |
|---|---|
| `name`, `type`, `unit` | Required descriptors |
| `sku` | Optional, unique per workspace |
| `price` | Stored as an **integer (kobo/lowest denomination)** |
| `currency` | Defaults to `NGN` |
| `category`, `weight`, `minOrderQty` | Optional metadata |
| `status` | `active` / `archived` |

Operations: create, list, update (catalog fields + inventory fields in a single call), archive.

---

### Inventory

One inventory record per catalog item, tracking:

| Field | Notes |
|---|---|
| `currentQty` / `availableQty` | Double precision quantities |
| `totalValue` | Integer (kobo) — recomputed on every transaction |
| `location` | Optional storage location |
| `lowStockThreshold` | Triggers low-stock detection |
| Restock / deduct audit fields | `lastRestockedAt`, `lastRestockedByName`, etc. |

Inventory is automatically created alongside the catalog item and updated atomically on every ledger transaction.

---

### Ledger

Financial transactions recorded against a workspace. A `Ledger` entry has:

| Field | Notes |
|---|---|
| `transactionType` | `sale`, `purchase`, `adjustment`, … |
| `paymentStatus` | `paid`, `pending`, `cancelled`, … |
| `totalAmount` | Integer (kobo) — sum of line items |
| `currency` | Defaults to `NGN` |
| `referenceNumber` | Optional external reference |
| `counterpartyName` | Optional customer / supplier name |
| `transactionAt` | Business timestamp (not server time) |

Each ledger entry has **line items** (`LedgerLineItem`) that snapshot the product name, price, and quantity at the moment of the transaction. Inventory is adjusted atomically within the same database transaction using row-level locking (`FOR UPDATE`).

---

## API Endpoints

All endpoints require authentication (`requireLogin = true`).

### `WorkspaceEndpoint`

| Method | Description |
|---|---|
| `createStandalone` | Create a root workspace |
| `createChild` | Create a nested workspace |
| `getWorkspaceDetails` | Fetch a single workspace by public ID |
| `getDashboardData` | Fetch workspace + member list + catalog snapshot |
| `getMyWorkspaces` | List all workspaces the caller belongs to |
| `getChildWorkspaces` | List children of a workspace |
| `updateWorkspaceDetails` | Rename / re-describe a workspace |
| `archiveWorkspace` / `restoreWorkspace` | Soft archive lifecycle |
| `initiateDeleteWorkspace` | Start grace-period deletion |
| `transferOwnership` | Hand ownership to another member |
| `inviteMember` | Send an email invitation |
| `acceptInvitation` | Accept via token |
| `updateMemberRole` | Promote / demote a member |
| `removeMember` / `leaveWorkspace` | Remove membership |

### `CatalogEndpoint`

| Method | Description |
|---|---|
| `createProduct` | Add a new catalog item + initialise inventory |
| `listProducts` | List all active products in a workspace |
| `updateProduct` | Update catalog and/or inventory fields |
| `archiveProduct` | Soft-delete a product |

### `LedgerEndpoint`

| Method | Description |
|---|---|
| `createTransaction` | Record a new transaction with line items (atomic) |
| `listTransactions` | Filtered list (by type, date range) |
| `getTransaction` | Fetch a single ledger entry with its line items |

### `InventoryEndpoint`

> Operations are exposed via the catalog endpoint / ledger for atomic updates.

---

## Frontend Routes

| Path | Screen |
|---|---|
| `/auth/login` | Login |
| `/auth/signup` | Registration |
| `/auth/verification` | Email verification |
| `/auth/forgot-password` | Password reset request |
| `/auth/reset-password/verify` | Password reset (with token) |
| `/workspacelist` | Workspace picker |
| `/workspace/:publicId/dashboard` | Workspace dashboard (bento grid) |
| `/workspace/:publicId/catalog` | Catalog *(in progress)* |
| `/workspace/:publicId/ledger` | Ledger *(in progress)* |
| `/workspace/:publicId/reports` | Reports *(in progress)* |
| `/workspace/:publicId/members` | Members *(in progress)* |
| `/workspace/:publicId/settings` | Settings *(in progress)* |

---

## Code Generation

Whenever you modify models or endpoints on the server:

```bash
cd hololine_server
serverpod generate
```

After model changes, create and apply a database migration:

```bash
cd hololine_server
serverpod create-migration
dart bin/main.dart --apply-migrations
```

For Riverpod providers and other Flutter codegen:

```bash
cd hololine_flutter
dart run build_runner build --delete-conflicting-outputs
```

---

## Testing

```bash
# Server tests
cd hololine_server
dart test

# Flutter tests
cd hololine_flutter
flutter test
```

Server tests live in `hololine_server/test/`. Flutter tests live in `hololine_flutter/test/`.

---

## Deployment

GitHub Actions workflows are provided under `.github/workflows/`:

| Workflow | Target |
|---|---|
| `deployment-aws.yml` | AWS |
| `deployment-gcp.yml` | Google Cloud Platform |

The root `Dockerfile` performs a multi-stage build — compiling the Serverpod server and the Flutter Web frontend into a single container image.

---

## Development Conventions

### Backend

- **Models** are YAML files in `hololine_server/lib/src/models/` — never edit generated code in `lib/src/generated/` directly.
- **Endpoints** contain no business logic — authentication gate + delegation only.
- **Services** own all business logic and permission enforcement.
- **Repositories** own all database access — services never call the DB directly.
- Monetary values are always stored as **integers in the lowest currency denomination** (e.g. kobo for NGN).

### Frontend

- Prefer `AsyncNotifier` with `@riverpod` annotations for remote data.
- Use `flutter_hooks` for local widget state.
- Follow `shadcn_ui` component patterns for new UI.
- Add new routes to `hololine_flutter/lib/routing/router_config.dart`.
