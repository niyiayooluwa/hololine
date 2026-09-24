import 'package:flutter/foundation.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/constants/api_constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Provider for the Serverpod client.
/// It initializes the connection to your server and sets up session management.
final clientProvider = Provider<Client>((ref) {
  // The server URL is different depending on the platform and build mode.
  const productionUrl = ApiConstants.baseUrl;
  late final String serverUrl;

  if (kReleaseMode) {
    // In release mode, we always use the production server.
    serverUrl = productionUrl;
  } else {
    // In debug mode, we use different URLs for different platforms.
    if (defaultTargetPlatform == TargetPlatform.android) {
      serverUrl = 'http://10.0.2.2:8080/'; // Android emulator
    } else {
      serverUrl = 'http://localhost:8080/'; // iOS, web, desktop
    }
  }
  // Sets up a singleton client object that can be used to talk to the server from
  // anywhere in our app.
  final client = Client(
    serverUrl,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  return client;
});

final sessionProvider = Provider<SessionManager>((ref) {
  final client = ref.watch(clientProvider);

  final sessionManager = SessionManager(caller: client.modules.auth);
  return sessionManager;
});

/// A Notifier to manage the active workspace summary selection state.
class ActiveWorkspaceNotifier extends Notifier<WorkspaceSummary?> {
  @override
  WorkspaceSummary? build() => null;

  void select(WorkspaceSummary? workspace) {
    state = workspace;
  }
}

/// Provider to track the active workspace summary selected by the user.
final activeWorkspaceProvider =
    NotifierProvider<ActiveWorkspaceNotifier, WorkspaceSummary?>(
      ActiveWorkspaceNotifier.new,
    );

/// Provider to get the current role of the logged-in user in the active workspace.
final currentWorkspaceRoleProvider = Provider<WorkspaceRole?>((ref) {
  final activeWorkspace = ref.watch(activeWorkspaceProvider);
  return activeWorkspace?.role;
});

/// FutureProvider to fetch all workspaces the authenticated user belongs to.
final myWorkspacesProvider = FutureProvider<List<WorkspaceSummary>>((
  ref,
) async {
  final client = ref.watch(clientProvider);
  return await client.workspaceMember.getMyWorkspaces();
});
