import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/core/utils/logging.dart';
import 'package:hololine_flutter/core/utils/validators.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_controller.g.dart';

@riverpod
class SignupController extends _$SignupController {
  @override
  FutureOr<bool> build() => false;

  AuthRepository get auth => ref.read(authRepositoryProvider);

  Future<bool?> signup(String userName, String email, String password) async {
    // Set state to loading
    state = const AsyncLoading();

    final emailError = validateEmail(email);
    if (emailError != null) {
      AsyncError(AuthFailure.invalidEmail(), StackTrace.current);
      return null;
    }

    if (password.isEmpty) {
      AsyncError(AuthFailure.invalidPassword(), StackTrace.current);
      return null;
    }

    // execute the usecase
    final result = await auth.register(userName, email, password);

    // Handle response
    return result.fold(
      ifLeft: (failure) {
        state = AsyncError(failure, StackTrace.current);
        logger(failure.message);
        return null;
      },
      ifRight: (response) {
        state = AsyncData(response);
        logger(response.toString());
        return response;
      },
    );
  }
}
