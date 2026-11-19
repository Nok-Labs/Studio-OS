import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studio_os/core/constants/constants.dart';
import 'package:studio_os/features/auth/ui/profile/controllers/profile_controller.dart';

class ProjectsScreen extends HookConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profileProvider);
    final shad = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: shad.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: UIConstants.md,
            bottom: UIConstants.lg,
          ),
          child: Column(
            mainAxisSize: .max,
            children: [
              _top(context, ref),
              Divider(color: shad.colorScheme.border),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _top(BuildContext context, WidgetRef ref) {
    final shad = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: UIConstants.xl,
        right: UIConstants.xl,
        bottom: UIConstants.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/logo/black_full.svg',
            height: UIConstants.lg,
            colorFilter: ColorFilter.mode(
              shad.colorScheme.foreground,
              BlendMode.srcIn,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Icon(
                  LucideIcons.settings,
                  color: shad.colorScheme.foreground,
                  size: UIConstants.lg,
                ),
              ),
              SizedBox(width: UIConstants.md),

              InkWell(
                onTap: () {},
                child: Icon(
                  LucideIcons.helpCircle,
                  color: shad.colorScheme.foreground,
                  size: UIConstants.lg,
                ),
              ),
              SizedBox(width: UIConstants.md),

              InkWell(
                onTap: () async {
                  if (context.mounted) {
                    context.goNamed('accounts');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: shad.colorScheme.card,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Text(
                    "TA",
                  ), // user first name and last name initials fetched from user provider
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
