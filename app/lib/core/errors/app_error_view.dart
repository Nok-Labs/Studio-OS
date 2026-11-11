import 'package:studio_os/core/errors/error_mapper.dart';

/// Clean model representing user-facing copy for an error toast or error dialog.
class AppErrorView {
  const AppErrorView({required this.title, this.description});

  final String title;
  final String? description;

  /// Maps any error or [Failure] into conversational, human-friendly UX copy.
  factory AppErrorView.from(Object error) {
    if (error is! Failure) {
      return const AppErrorView(
        title: 'Something went wrong',
        description:
            'We couldn’t complete your request. Check your connection and try again.',
      );
    }

    switch (error.code) {
      //========================================================================
      //Auth & Credentials
      //========================================================================
      case 'email_already_registered':
        return const AppErrorView(
          title: 'Email already registered',
          description:
              'An account with this email address already exists. Try signing in instead.',
        );
      case 'email_not_verified':
        return const AppErrorView(
          title: 'Email not verified',
          description:
              'Please verify your email address to access your account.',
        );
      case 'invalid_credentials':
        return const AppErrorView(
          title: 'Invalid credentials',
          description:
              'The email or password you entered is incorrect. Please check and try again.',
        );
      case 'username_taken':
        return const AppErrorView(
          title: 'Username is taken',
          description:
              'This organization handle or username is already in use. Please choose another.',
        );

      //========================================================================
      // OTP & Verification
      //========================================================================
      case 'otp_incorrect':
        return const AppErrorView(
          title: 'Incorrect verification code',
          description:
              'The code you entered does not match. Please verify and try again.',
        );
      case 'otp_expired':
        return const AppErrorView(
          title: 'Verification code expired',
          description:
              'This code has expired. Please request a new code to continue.',
        );
      case 'otp_max_attempts':
        return const AppErrorView(
          title: 'Too many failed attempts',
          description:
              'You have exceeded the maximum number of attempts. Please request a new code.',
        );
      case 'otp_cooldown':
        return const AppErrorView(
          title: 'Please wait a moment',
          description:
              'You requested a code recently. Please wait a short while before requesting another.',
        );

      //========================================================================
      // Projects, Members & Tasks
      //========================================================================
      case 'project_not_found':
        return const AppErrorView(
          title: 'Project not found',
          description:
              'This project doesn’t exist or you no longer have access to it.',
        );
      case 'task_not_found':
        return const AppErrorView(
          title: 'Task not found',
          description: 'This task may have been deleted by a teammate.',
        );
      case 'member_not_found':
        return const AppErrorView(
          title: 'Not a member',
          description: 'This person is not on the project.',
        );
      case 'user_not_found':
        return const AppErrorView(
          title: 'No Studio account yet',
          description:
              'There’s no account with that email. Have them sign up first, then add them here.',
        );
      case 'project_owner_required':
        return const AppErrorView(
          title: 'Only the owner can do that',
          description:
              'Not every project action is available to teammates — this one is the owner’s.',
        );
      case 'already_member':
        return const AppErrorView(
          title: 'Already on the project',
          description:
              'This person is already a member and doesn’t need to be added again.',
        );
      case 'assignee_not_member':
        return const AppErrorView(
          title: 'Can’t assign that person',
          description: 'Tasks can only be assigned to people on the project.',
        );
      case 'invalid_project_name':
        return const AppErrorView(
          title: 'Invalid project name',
          description:
              'Give the project a name of at least one character (and under 255).',
        );
      case 'invalid_project_status':
        return const AppErrorView(
          title: 'Unsupported status',
          description: 'Projects can be draft, active or completed.',
        );
      case 'invalid_task_title':
        return const AppErrorView(
          title: 'Invalid task title',
          description: 'Give the task a title of at least one character.',
        );
      case 'invalid_task_area':
        return const AppErrorView(
          title: 'Unsupported area',
          description: 'Choose one of: backend, frontend, design, doc.',
        );
      case 'invalid_task_status':
        return const AppErrorView(
          title: 'Unsupported status',
          description: 'Tasks move along: todo, in progress, done.',
        );
      case 'too_many_tags':
        return const AppErrorView(
          title: 'Too many tags',
          description: 'A task can hold at most 20 tags.',
        );

      //========================================================================
      // Account Status
      //========================================================================
      case 'account_suspended':
        return const AppErrorView(
          title: 'Account suspended',
          description:
              'Your account has been suspended. Please contact your organization administrator.',
        );
      case 'account_deactivated':
        return const AppErrorView(
          title: 'Account deactivated',
          description: 'This account has been deactivated.',
        );

      //========================================================================
      // Network & Rate Limits
      //========================================================================
      case 'rate_limited':
        return const AppErrorView(
          title: 'Too many requests',
          description:
              'You are making requests too quickly. Please pause a moment and try again.',
        );
      case 'network':
        return const AppErrorView(
          title: 'Connection issue',
          description:
              'Unable to connect to the server. Please check your internet connection.',
        );
      case 'timeout':
        return const AppErrorView(
          title: 'Request timed out',
          description:
              'The server is taking too long to respond. Please check your connection and retry.',
        );
      case 'cancelled':
        return const AppErrorView(
          title: 'Cancelled',
          description: 'The request was cancelled.',
        );

      //========================================================================
      // Validation & Server
      //========================================================================
      case 'invalid_profile_name':
        return const AppErrorView(
          title: 'Name too long',
          description: 'Names have a limit — try shortening it a little.',
        );
      case 'invalid_avatar_url':
        return const AppErrorView(
          title: 'Avatar link not accepted',
          description: 'The avatar must be a normal web link (http or https).',
        );
      case 'validation_failed':
        final detailMsg = error.details != null && error.details!.isNotEmpty
            ? error.details!.map((d) => '${d.field}: ${d.code}').join(', ')
            : null;
        return AppErrorView(
          title: 'Check your details',
          description: detailMsg ?? error.message,
        );
      case 'internal_error':
        return const AppErrorView(
          title: 'Server error',
          description:
              'Our service encountered an unexpected problem. We are looking into it.',
        );

      default:
        return AppErrorView(
          title: 'Something went wrong',
          description: error.message.isNotEmpty
              ? error.message
              : 'Please try again.',
        );
    }
  }
}
