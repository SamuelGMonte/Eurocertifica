import 'dart:convert';
import 'dart:math';

import 'package:eurocertifica_web/features/auth/data/models/user_model.dart';
import 'package:eurocertifica_web/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/learning_state.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/course_seed.dart';
import '../models/learning_models.dart';

class SharedPreferencesLearningRepository implements LearningRepository {
  SharedPreferencesLearningRepository({
    required SharedPreferences preferences,
    required CourseSeed courseSeed,
  })  : _preferences = preferences,
        _courseSeed = courseSeed;

  final SharedPreferences _preferences;
  final CourseSeed _courseSeed;

  static const _userKey = 'user';
  static const _coursesKey = 'courses';
  static const _progressKey = 'userProgress';

  @override
  Future<LearningState> loadState() async {
    final userPayload = _preferences.getString(_userKey);
    final coursesPayload = _preferences.getString(_coursesKey);
    final progressPayload = _preferences.getString(_progressKey);

    final courses = coursesPayload == null
        ? _courseSeed.initialCourses()
        : (jsonDecode(coursesPayload) as List<dynamic>)
            .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
            .toList();

    if (coursesPayload == null) {
      await saveCourses(courses);
    }

    return LearningState(
      user: userPayload == null ? null : UserModel.fromJson(userPayload),
      courses: courses,
      progressByCourse: progressPayload == null
          ? {}
          : (jsonDecode(progressPayload) as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                UserProgressModel.fromJson(value as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  QuizAttempt gradeQuiz({
    required Course course,
    required User user,
    required Map<String, String> answers,
  }) {
    final correctCount = course.quiz.questions.where((question) {
      return answers[question.id] == question.correctAnswer;
    }).length;
    final score = ((correctCount / course.quiz.questions.length) * 100).round();

    return QuizAttempt(
      id: _randomId(),
      courseId: course.id,
      userId: user.id,
      answers: answers,
      score: score,
      passed: score >= course.quiz.passingScore,
      date: DateTime.now(),
    );
  }

  @override
  Future<void> saveCourses(List<Course> courses) async {
    await _preferences.setString(
      _coursesKey,
      jsonEncode(
        courses
            .map((course) => CourseModel.fromEntity(course).toJson())
            .toList(),
      ),
    );
  }

  @override
  Future<void> saveProgress(Map<String, UserProgress> progressByCourse) async {
    await _preferences.setString(
      _progressKey,
      jsonEncode(
        progressByCourse.map(
          (key, value) => MapEntry(
            key,
            UserProgressModel.fromEntity(value).toJson(),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> clearUser() async {
    await _preferences.remove(_userKey);
  }

  String _randomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(9, (_) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Future<void> saveUser(User? user) async {
    if (user == null) {
      await _preferences.remove(_userKey);
      return;
    }
    await _preferences.setString(
      _userKey,
      jsonEncode(UserModel.fromEntity(user).toJson()),
    );
  }
}
