import 'package:hololine_flutter/module/auth/domain/usecase/signup_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_controller.g.dart';

@riverpod
class SignupController extends _$SignupController {
  @override
  FutureOr<bool> build() => false;

  RegisterUsecase get registerUseCase => ref.read(registerUsecaseProvider);

  Future<bool?> signup(String userName, String email, String password) async {
    // Set state to loading
    state = const AsyncLoading();

    // execute the usecase
    final result = await registerUseCase.call(userName, email, password);

    // Handle response
    return result.fold(
      ifLeft: (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      ifRight: (response) {
        state = AsyncData(response);
        return response;
      },
    );
  }
}
