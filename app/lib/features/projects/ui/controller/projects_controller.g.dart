// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in user's project list. AutoDispose on purpose: it is
/// screen-scoped, so it refetches on mount and is refreshed with
/// `ref.invalidate(projectsProvider)`.

@ProviderFor(ProjectsController)
const projectsProvider = ProjectsControllerProvider._();

/// The signed-in user's project list. AutoDispose on purpose: it is
/// screen-scoped, so it refetches on mount and is refreshed with
/// `ref.invalidate(projectsProvider)`.
final class ProjectsControllerProvider
    extends $AsyncNotifierProvider<ProjectsController, List<ProjectData>> {
  /// The signed-in user's project list. AutoDispose on purpose: it is
  /// screen-scoped, so it refetches on mount and is refreshed with
  /// `ref.invalidate(projectsProvider)`.
  const ProjectsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsControllerHash();

  @$internal
  @override
  ProjectsController create() => ProjectsController();
}

String _$projectsControllerHash() =>
    r'60b9e8771f52507a14f89b641e60b0296a738dcd';

/// The signed-in user's project list. AutoDispose on purpose: it is
/// screen-scoped, so it refetches on mount and is refreshed with
/// `ref.invalidate(projectsProvider)`.

abstract class _$ProjectsController extends $AsyncNotifier<List<ProjectData>> {
  FutureOr<List<ProjectData>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<ProjectData>>, List<ProjectData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ProjectData>>, List<ProjectData>>,
              AsyncValue<List<ProjectData>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// One project for the detail screen, cached per id. Watching
/// `projectProvider(id)` gives the screen loading and error states for free —
/// a single-project fetch gets its own controller, never a method hanging off
/// the list controller.

@ProviderFor(ProjectController)
const projectProvider = ProjectControllerFamily._();

/// One project for the detail screen, cached per id. Watching
/// `projectProvider(id)` gives the screen loading and error states for free —
/// a single-project fetch gets its own controller, never a method hanging off
/// the list controller.
final class ProjectControllerProvider
    extends $AsyncNotifierProvider<ProjectController, ProjectData> {
  /// One project for the detail screen, cached per id. Watching
  /// `projectProvider(id)` gives the screen loading and error states for free —
  /// a single-project fetch gets its own controller, never a method hanging off
  /// the list controller.
  const ProjectControllerProvider._({
    required ProjectControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'projectProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectControllerHash();

  @override
  String toString() {
    return r'projectProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProjectController create() => ProjectController();

  @override
  bool operator ==(Object other) {
    return other is ProjectControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectControllerHash() => r'6fc495454178720bbc8757ce85fe5e1d2920dfd2';

/// One project for the detail screen, cached per id. Watching
/// `projectProvider(id)` gives the screen loading and error states for free —
/// a single-project fetch gets its own controller, never a method hanging off
/// the list controller.

final class ProjectControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProjectController,
          AsyncValue<ProjectData>,
          ProjectData,
          FutureOr<ProjectData>,
          String
        > {
  const ProjectControllerFamily._()
    : super(
        retry: null,
        name: r'projectProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One project for the detail screen, cached per id. Watching
  /// `projectProvider(id)` gives the screen loading and error states for free —
  /// a single-project fetch gets its own controller, never a method hanging off
  /// the list controller.

  ProjectControllerProvider call(String projectId) =>
      ProjectControllerProvider._(argument: projectId, from: this);

  @override
  String toString() => r'projectProvider';
}

/// One project for the detail screen, cached per id. Watching
/// `projectProvider(id)` gives the screen loading and error states for free —
/// a single-project fetch gets its own controller, never a method hanging off
/// the list controller.

abstract class _$ProjectController extends $AsyncNotifier<ProjectData> {
  late final _$args = ref.$arg as String;
  String get projectId => _$args;

  FutureOr<ProjectData> build(String projectId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<ProjectData>, ProjectData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProjectData>, ProjectData>,
              AsyncValue<ProjectData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
