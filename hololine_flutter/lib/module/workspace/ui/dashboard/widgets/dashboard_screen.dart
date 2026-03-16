// ignore_for_file: unused_element, unused_import

import 'package:flutter/material.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/module/workspace/ui/dashboard/controller/dashboard_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the controller state directly
    final dashboardState = ref.watch(dashboardControllerProvider);

    final List<Workspace> workspaces = [
      Workspace(
        name: "Name",
        description: "Description",
        createdAt: DateTime.now(),
      )
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Colors.amber,
        title: const Text('Hololine'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: _buildContent(
        context: context,
        ref: ref,
        workspaces: workspaces,
      ),

      /**
       * dashboardState.when(
        data: (workspaces) => _buildContent(
          context: context,
          ref: ref,
          workspaces: workspaces,
        ),
        error: (error, stack) => _buildError(
          error: error.toString(),
        ),
        loading: () => _buildLoading(),
      ),
       */
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required WidgetRef ref,
    required List<Workspace> workspaces,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Navigation Rail
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          width: 256,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blueGrey
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text('THis is a ext'),
            ],
          ),
        ),

        // Main content area
        Column(),
      ],
    );
  }

  Widget _buildError({
    required String error,
  }) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
