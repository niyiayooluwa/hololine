import 'package:flutter/material.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/module/workspace/ui/dashboard/controller/dashboard_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the controller state directly
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Hololine'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: dashboardState.when(
        data: (workspaces) =>
            _buildContent(context: context, ref: ref, workspaces: workspaces),
        error: (error, stack) => _buildError(error: error.toString()),
        loading: () => _buildLoading(),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required WidgetRef ref,
    required List<Workspace> workspaces,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        
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
