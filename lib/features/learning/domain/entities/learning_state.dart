import 'course.dart';
import '../../../login/domain/entities/user.dart';
import 'user_progress.dart';

class LearningState {
  const LearningState({
    required this.user,
    required this.courses,
    required this.progressByCourse,
  });

  final User? user;
  final List<Course> courses;
  final Map<String, UserProgress> progressByCourse;

  LearningState copyWith({
    User? user,
    bool clearUser = false,
    List<Course>? courses,
    Map<String, UserProgress>? progressByCourse,
  }) {
    return LearningState(
      user: clearUser ? null : user ?? this.user,
      courses: courses ?? this.courses,
      progressByCourse: progressByCourse ?? this.progressByCourse,
    );
  }
}
