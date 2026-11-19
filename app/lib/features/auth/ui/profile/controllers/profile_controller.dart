import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studio_os/features/auth/data/models/profile.dart';
import 'package:studio_os/features/auth/data/repository/auth_repository.dart';

part 'profile_controller.g.dart';

@Riverpod(keepAlive: true, name: "profileProvider")
class ProfileController extends _$ProfileController {
  @override
  FutureOr<ProfileData> build() async {
    final result = await ref.read(authRepositoryProvider).getMe();
    return result.fold(
      ifLeft: (failure) => throw failure,
      ifRight: (profile) => profile,
    );
  }

  Future<void> updateProfile(ProfileUpdateRequest request) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();

    final result = await ref.read(authRepositoryProvider).updateMe(request);

    state = result.fold(
      ifLeft: (failure) => AsyncValue.error(failure, StackTrace.current),
      ifRight: (profile) => AsyncValue.data(profile),
    );
  }
}
