import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/module/workspace/data/repository/workspace_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_dashboard_provider.g.dart';

@riverpod
Future<WorkspaceDashboardData> workspaceDashboard(
  Ref ref,
  String publicId,
) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  final result = await repository.getDashboardData(publicId);

  return result.fold(
    ifLeft: (failure) => throw failure,
    ifRight: (data) => data,
  );
}
