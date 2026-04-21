import '../entities/course.dart';
import '../entities/quiz.dart';
import '../../../login/domain/entities/user.dart';
import '../entities/user_progress.dart';
import '../repositories/learning_repository.dart';

class SubmitQuiz {
  const SubmitQuiz(this._repository);

  final LearningRepository _repository;

  Future<
      ({
        QuizAttempt attempt,
        User? user,
        Map<String, UserProgress> progress,
      })> call({
    required String courseId,
    required Map<String, String> answers,
    required List<Course> courses,
    required Map<String, UserProgress> progressByCourse,
    required User? user,
  }) async {
    final course = courses.where((item) => item.id == courseId).firstOrNull;
    if (course == null) {
      throw StateError('Curso não encontrado');
    }

    final attempt = _repository.gradeQuiz(
      course: course,
      user: user,
      answers: answers,
    );

    final current = progressByCourse[courseId] ??
        UserProgress(
          userId: user?.id ?? '',
          courseId: courseId,
          currentLessonId: '',
          completedLessons: const [],
          quizAttempts: const [],
        );

    final updatedProgress = Map<String, UserProgress>.from(progressByCourse)
      ..[courseId] = current.copyWith(
        quizAttempts: [...current.quizAttempts, attempt],
      );

    final updatedUser = attempt.passed && user != null
        ? user.copyWith(points: user.points + 100)
        : user;

    await _repository.saveProgress(updatedProgress);
    await _repository.saveUser(updatedUser);
    return (attempt: attempt, user: updatedUser, progress: updatedProgress);
  }
}
