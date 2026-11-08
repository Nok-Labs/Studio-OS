// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_remote.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(projectRemote)
const projectRemoteProvider = ProjectRemoteProvider._();

final class ProjectRemoteProvider
    extends $FunctionalProvider<ProjectRemote, ProjectRemote, ProjectRemote>
    with $Provider<ProjectRemote> {
  const ProjectRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectRemoteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectRemoteHash();

  @$internal
  @override
  $ProviderElement<ProjectRemote> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProjectRemote create(Ref ref) {
    return projectRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectRemote value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectRemote>(value),
    );
  }
}

String _$projectRemoteHash() => r'53820db8df962ddf031fa2d6920ac7d1a077ec4a';
