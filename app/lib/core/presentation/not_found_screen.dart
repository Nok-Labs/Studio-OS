import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studio_os/core/constants/constants.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, this.uri});

  final Uri? uri;

  @override
  Widget build(BuildContext context) {
    final shad = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: shad.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: UIConstants.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '404',
                    style: shad.textTheme.h1.copyWith(
                      fontSize: 72,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                      color: shad.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: UIConstants.sm),
                  Text(
                    'Page not found',
                    textAlign: TextAlign.center,
                    style: shad.textTheme.h3.copyWith(
                      fontWeight: FontWeight.w600,
                      color: shad.colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: UIConstants.sm),
                  Text(
                    "The page you're looking for doesn't exist or has been moved.",
                    textAlign: TextAlign.center,
                    style: shad.textTheme.muted.copyWith(
                      fontSize: 14,
                      color: shad.colorScheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: UIConstants.xl),
                  ShadButton(
                    onPressed: () => context.goNamed('login'),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
