import '../entities/course.dart';
import '../../../login/domain/entities/user.dart';
import '../entities/user_progress.dart';
import '../repositories/learning_repository.dart';

class UpdateLessonProgress {
  const UpdateLessonProgress(this._repository);

  final LearningRepository _repository;

  Future<({List<Course> courses, Map<String, UserProgress> progress})> call({
    required String courseId,
    required String lessonId,
    required List<Course> courses,
    required Map<String, UserProgress> progressByCourse,
    required User? user,
  }) async {
    final course = courses.where((item) => item.id == courseId).firstOrNull;
    if (course == null) {
      return (courses: courses, progress: progressByCourse);
    }

    final current = progressByCourse[courseId] ??
        UserProgress(
          userId: user?.id ?? '',
          courseId: courseId,
          currentLessonId: lessonId,
          completedLessons: const [],
          quizAttempts: const [],
        );

    final completed = {...current.completedLessons, lessonId}.toList();
    final updatedCourseProgress =
        ((completed.length / course.lessons.length) * 100).round();
    final updatedProgress = Map<String, UserProgress>.from(progressByCourse)
      ..[courseId] = current.copyWith(
        currentLessonId: lessonId,
        completedLessons: completed,
      );
    final updatedCourses = courses
        .map((item) => item.id == courseId
            ? item.copyWith(progress: updatedCourseProgress)
            : item)
        .toList();

    await _repository.saveProgress(updatedProgress);
    await _repository.saveCourses(updatedCourses);
    return (courses: updatedCourses, progress: updatedProgress);
  }
}
