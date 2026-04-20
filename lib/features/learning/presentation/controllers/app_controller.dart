import 'package:flutter/foundation.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/usecases/enroll_course.dart';
import '../../domain/usecases/load_learning_state.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/submit_quiz.dart';
import '../../domain/usecases/update_lesson_progress.dart';

enum AppPage { login, dashboard, courses, courseContent, quiz, ranking, profile }

class AppController extends ChangeNotifier {
  AppController({
    required LoadLearningState loadLearningState,
    required LoginUser loginUser,
    required LogoutUser logoutUser,
    required EnrollCourse enrollCourse,
    required UpdateLessonProgress updateLessonProgress,
    required SubmitQuiz submitQuiz,
  })  : _loadLearningState = loadLearningState,
        _loginUser = loginUser,
        _logoutUser = logoutUser,
        _enrollCourse = enrollCourse,
        _updateLessonProgress = updateLessonProgress,
        _submitQuiz = submitQuiz;

  final LoadLearningState _loadLearningState;
  final LoginUser _loginUser;
  final LogoutUser _logoutUser;
  final EnrollCourse _enrollCourse;
  final UpdateLessonProgress _updateLessonProgress;
  final SubmitQuiz _submitQuiz;

  User? _user;
  List<Course> _courses = const [];
  Map<String, UserProgress> _progressByCourse = const {};
  AppPage _page = AppPage.login;
  String? _selectedCourseId;
  bool _isLoading = true;

  User? get user => _user;
  List<Course> get courses => _courses;
  Map<String, UserProgress> get progressByCourse => _progressByCourse;
  AppPage get page => _page;
  String? get selectedCourseId => _selectedCourseId;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  List<Course> get enrolledCourses =>
      _courses.where((course) => course.isEnrolled).toList();

  List<Course> get completedCourses =>
      _courses.where((course) => course.progress == 100).toList();

  int get averageProgress {
    if (enrolledCourses.isEmpty) return 0;
    final total = enrolledCourses.fold<int>(0, (sum, course) => sum + course.progress);
    return (total / enrolledCourses.length).round();
  }

  Course? get selectedCourse =>
      _courses.where((course) => course.id == _selectedCourseId).firstOrNull;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    final state = await _loadLearningState();
    _user = state.user;
    _courses = state.courses;
    _progressByCourse = state.progressByCourse;
    _page = _user == null ? AppPage.login : AppPage.courses;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) return false;
    _user = await _loginUser(email: email, password: password);
    _page = AppPage.courses;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _logoutUser();
    _user = null;
    _selectedCourseId = null;
    _page = AppPage.login;
    notifyListeners();
  }

  void openPage(AppPage page) {
    if (!isAuthenticated && page != AppPage.login) {
      _page = AppPage.login;
    } else {
      _page = page;
    }
    notifyListeners();
  }

  void openCourse(String courseId) {
    _selectedCourseId = courseId;
    _page = AppPage.courseContent;
    notifyListeners();
  }

  void openQuiz(String courseId) {
    _selectedCourseId = courseId;
    _page = AppPage.quiz;
    notifyListeners();
  }

  Future<void> enroll(String courseId) async {
    final result = await _enrollCourse(
      courseId: courseId,
      courses: _courses,
      progressByCourse: _progressByCourse,
      user: _user,
    );
    _courses = result.courses;
    _progressByCourse = result.progress;
    notifyListeners();
  }

  Future<void> completeLesson(String courseId, String lessonId) async {
    final result = await _updateLessonProgress(
      courseId: courseId,
      lessonId: lessonId,
      courses: _courses,
      progressByCourse: _progressByCourse,
      user: _user,
    );
    _courses = result.courses;
    _progressByCourse = result.progress;
    notifyListeners();
  }

  Future<QuizAttempt> submitQuiz(
    String courseId,
    Map<String, String> answers,
  ) async {
    final result = await _submitQuiz(
      courseId: courseId,
      answers: answers,
      courses: _courses,
      progressByCourse: _progressByCourse,
      user: _user,
    );
    _user = result.user;
    _progressByCourse = result.progress;
    notifyListeners();
    return result.attempt;
  }
}
