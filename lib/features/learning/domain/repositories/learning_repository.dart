import 'package:eurocertifica_web/features/auth/domain/entities/user.dart';

import '../entities/course.dart';
import '../entities/learning_state.dart';
import '../entities/quiz.dart';
import '../entities/user_progress.dart';

abstract class LearningRepository {
  Future<LearningState> loadState();
  Future<void> saveUser(User? user);
  Future<void> saveCourses(List<Course> courses);
  Future<void> saveProgress(Map<String, UserProgress> progressByCourse);
  Future<void> clearUser();
  QuizAttempt gradeQuiz({
    required Course course,
    required User user,
    required Map<String, String> answers,
  });
}
