import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studio_os/features/projects/data/models/project.dart';
import 'package:studio_os/features/projects/data/repository/project_repository.dart';

part 'projects_controller.g.dart';

/// The signed-in user's project list. AutoDispose on purpose: it is
/// screen-scoped, so it refetches on mount and is refreshed with
/// `ref.invalidate(projectsProvider)`.
@Riverpod(name: 'projectsProvider')
class ProjectsController extends _$ProjectsController {
  @override
  Future<List<ProjectData>> build() async {
    final result = await ref.read(projectRepositoryProvider).listProjects();

    return result.fold(
      ifLeft: (failure) => throw failure,
      ifRight: (projects) => projects,
    );
  }

}

/// One project for the detail screen, cached per id. Watching
/// `projectProvider(id)` gives the screen loading and error states for free —
/// a single-project fetch gets its own controller, never a method hanging off
/// the list controller.
@Riverpod(name: 'projectProvider')
class ProjectController extends _$ProjectController {
  @override
  Future<ProjectData> build(String projectId) async {
    final result = await ref
        .read(projectRepositoryProvider)
        .getProject(projectId);

    return result.fold(
      ifLeft: (failure) => throw failure,
      ifRight: (project) => project,
    );
  }
}
