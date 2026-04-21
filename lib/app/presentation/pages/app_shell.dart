import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/learning/presentation/controllers/app_controller.dart';
import '../../../features/learning/presentation/pages/course_content_page.dart';
import '../../../features/learning/presentation/pages/courses_page.dart';
import '../../../features/learning/presentation/pages/dashboard_page.dart';
import '../../../features/learning/presentation/pages/login_page.dart';
import '../../../features/learning/presentation/pages/profile_page.dart';
import '../../../features/learning/presentation/pages/quiz_page.dart';
import '../../../features/learning/presentation/pages/ranking_page.dart';

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
