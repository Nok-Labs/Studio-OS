import 'package:dart_either/dart_either.dart';
import 'package:studio_os/core/errors/error_mapper.dart';
import 'package:studio_os/core/storage/secure_storage.dart';
import 'package:studio_os/features/auth/data/models/forgot_password.dart';
import 'package:studio_os/features/auth/data/models/login.dart';
import 'package:studio_os/features/auth/data/models/profile.dart';
import 'package:studio_os/features/auth/data/models/register.dart';
import 'package:studio_os/features/auth/data/models/verify.dart';
import 'package:studio_os/features/auth/data/remote/auth_remote.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final AuthRemote _remote;
  final SecureStorage _storage;

  AuthRepository(this._remote, this._storage);

  Future<Either<Failure, RegisterResponse>> register(
    RegisterRequest request,
  ) async {
    // No tokens to save on signup (requires OTP verification first)
    return await _remote.signup(request);
  }

  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    final result = await _remote.login(request);

    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (response) async {
        await _storage.saveTokens(
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken,
        );
        return Right(response);
      },
    );
  }

  Future<Either<Failure, VerifyResponse>> verifyOtp(
    VerifyRequest request,
  ) async {
    final result = await _remote.verifyOtp(request);

    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (response) async {
        await _storage.saveTokens(
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken,
        );
        return Right(response);
      },
    );
  }

  Future<Either<Failure, void>> resendOtp(ResendOtpRequest request) async {
    return await _remote.resendOtp(request);
  }

  Future<Either<Failure, void>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    return await _remote.forgotPassword(request);
  }

  Future<Either<Failure, void>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    return await _remote.resetPassword(request);
  }

  /// Fetches the caller's identity from the server. The onboarding gate and
  /// the account screen both read this; it never touches tokens.
  Future<Either<Failure, ProfileResponse>> getMe() async {
    return await _remote.getProfile();
  }

  /// Partial profile update. Returns the server's fresh copy of the profile —
  /// prefer it over merging locally, so the app satisfies what's stored.
  Future<Either<Failure, ProfileResponse>> updateMe(
    ProfileUpdateRequest request,
  ) async {
    return await _remote.updateMe(request);
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(authRemoteProvider),
    ref.watch(secureStorageProvider),
    //ref.watch(secureStorageProvider),
  );
}
