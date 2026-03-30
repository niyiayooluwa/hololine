import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/module/workspace/domain/usecase/get_workspace_details_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_detail_provider.g.dart';

@riverpod
Future<Workspace> workspaceDetail(Ref ref, String publicId) async {
  final useCase = ref.watch(getWorkspaceDetailsUseCaseProvider);
  final result = await useCase(publicId);
  
  return result.fold(
    ifLeft: (failure) => throw Exception(failure.message),
    ifRight: (workspace) => workspace,
  );
}
