import 'package:dio/dio.dart';
import 'package:dart_either/dart_either.dart';
import 'package:studio_os/core/errors/error_mapper.dart';
import 'package:studio_os/core/network/dio_client.dart';
import 'package:studio_os/features/auth/data/models/forgot_password.dart';
import 'package:studio_os/features/auth/data/models/login.dart';
import 'package:studio_os/features/auth/data/models/profile.dart';
import 'package:studio_os/features/auth/data/models/register.dart';
import 'package:studio_os/features/auth/data/models/verify.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote.g.dart';

class AuthRemote {
  final Dio _dio;

  AuthRemote(this._dio);

  Future<Either<Failure, RegisterResponse>> signup(
    RegisterRequest request,
  ) async {
    try {
      final response = await _dio.post('/auth/signup', data: request.toJson());
      return Right(RegisterResponse.fromJson((response.data)));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/auth/login', data: request.toJson());
      return Right(LoginResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, VerifyResponse>> verifyOtp(
    VerifyRequest request,
  ) async {
    try {
      final response = await _dio.post('/auth/verify', data: request.toJson());
      return Right(VerifyResponse.fromJson((response.data)));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, void>> resendOtp(ResendOtpRequest request) async {
    try {
      await _dio.post('/auth/resend-otp', data: request.toJson());
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, void>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    try {
      await _dio.post('/auth/forgot-password', data: request.toJson());
      return Right(null);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, void>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      await _dio.post('/auth/reset-password', data: request.toJson());
      return Right(null);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, ProfileResponse>> getProfile() async {
    try {
      final response = await _dio.get('/v1/users/me');
      return Right(ProfileResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// Partial profile update: fields left unset (null) in [request] are kept
  /// out of the JSON and therefore unchanged on the server. The reply is the
  /// fresh profile, ready to hand to whatever state agreed on it.
  Future<Either<Failure, ProfileResponse>> updateMe(
    ProfileUpdateRequest request,
  ) async {
    try {
      final response = await _dio.patch('/v1/users/me', data: request.toJson());
      return Right(ProfileResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }
}

@riverpod
AuthRemote authRemote(Ref ref) {
  return AuthRemote(ref.watch(dioProvider));
}
