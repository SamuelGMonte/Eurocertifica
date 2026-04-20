import '../entities/course.dart';
import '../entities/user.dart';
import '../entities/user_progress.dart';
import '../repositories/learning_repository.dart';

class EnrollCourse {
  const EnrollCourse(this._repository);

  final LearningRepository _repository;

  Future<({List<Course> courses, Map<String, UserProgress> progress})> call({
    required String courseId,
    required List<Course> courses,
    required Map<String, UserProgress> progressByCourse,
    required User? user,
  }) async {
    final updatedCourses = courses
        .map((course) => course.id == courseId
            ? course.copyWith(isEnrolled: true)
            : course)
        .toList();

    final updatedProgress = Map<String, UserProgress>.from(progressByCourse);
    updatedProgress.putIfAbsent(
      courseId,
      () => UserProgress(
        userId: user?.id ?? '',
        courseId: courseId,
        currentLessonId: '',
        completedLessons: const [],
        quizAttempts: const [],
      ),
    );

    await _repository.saveCourses(updatedCourses);
    await _repository.saveProgress(updatedProgress);
    return (courses: updatedCourses, progress: updatedProgress);
  }
}
