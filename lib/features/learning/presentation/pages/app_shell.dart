import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import 'course_content_page.dart';
import 'courses_page.dart';
import 'dashboard_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'profile_page.dart';
import 'quiz_page.dart';
import 'ranking_page.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!controller.isAuthenticated) {
      return const LoginPage();
    }

    return switch (controller.page) {
      AppPage.dashboard => const DashboardPage(),
      AppPage.courses => const CoursesPage(),
      AppPage.courseContent => const CourseContentPage(),
      AppPage.quiz => const QuizPage(),
      AppPage.ranking => const RankingPage(),
      AppPage.profile => const ProfilePage(),
      AppPage.login => const LoginPage(),
    };
  }
}
