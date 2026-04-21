import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/learning/data/datasources/course_seed.dart';
import 'features/learning/data/repositories/shared_preferences_learning_repository.dart';
import 'features/learning/domain/usecases/enroll_course.dart';
import 'features/learning/domain/usecases/load_learning_state.dart';
import 'features/learning/domain/usecases/login_user.dart';
import 'features/learning/domain/usecases/logout_user.dart';
import 'features/learning/domain/usecases/submit_quiz.dart';
import 'features/learning/domain/usecases/update_lesson_progress.dart';
import 'features/learning/presentation/controllers/app_controller.dart';
import 'app/presentation/pages/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final repository = SharedPreferencesLearningRepository(
    preferences: preferences,
    courseSeed: CourseSeed(),
  );

  runApp(EurocertificaApp(repository: repository));
}

class EurocertificaApp extends StatelessWidget {
  const EurocertificaApp({
    required SharedPreferencesLearningRepository repository,
    super.key,
  }) : _repository = repository;

  final SharedPreferencesLearningRepository _repository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppController(
        loadLearningState: LoadLearningState(_repository),
        loginUser: LoginUser(_repository),
        logoutUser: LogoutUser(_repository),
        enrollCourse: EnrollCourse(_repository),
        updateLessonProgress: UpdateLessonProgress(_repository),
        submitQuiz: SubmitQuiz(_repository),
      )..initialize(),
      child: MaterialApp(
        title: 'Eurocertifica',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AppShell(),
      ),
    );
  }
}
