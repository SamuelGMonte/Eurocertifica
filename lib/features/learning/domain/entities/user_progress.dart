import 'quiz.dart';

class UserProgress {
  const UserProgress({
    required this.userId,
    required this.courseId,
    required this.currentLessonId,
    required this.completedLessons,
    required this.quizAttempts,
  });

  final int userId;
  final String courseId;
  final String currentLessonId;
  final List<String> completedLessons;
  final List<QuizAttempt> quizAttempts;

  UserProgress copyWith({
    int? userId,
    String? courseId,
    String? currentLessonId,
    List<String>? completedLessons,
    List<QuizAttempt>? quizAttempts,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      currentLessonId: currentLessonId ?? this.currentLessonId,
      completedLessons: completedLessons ?? this.completedLessons,
      quizAttempts: quizAttempts ?? this.quizAttempts,
    );
  }
}
