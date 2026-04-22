import '../../domain/entities/course.dart';
import '../../domain/entities/learning_state.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/user_progress.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.progress,
    required super.isEnrolled,
    required super.lessons,
    required super.quiz,
  });

  factory CourseModel.fromEntity(Course course) => CourseModel(
        id: course.id,
        title: course.title,
        description: course.description,
        category: course.category,
        progress: course.progress,
        isEnrolled: course.isEnrolled,
        lessons: course.lessons,
        quiz: course.quiz,
      );

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        progress: json['progress'] as int,
        isEnrolled: json['isEnrolled'] as bool,
        lessons: (json['lessons'] as List<dynamic>)
            .map((item) => LessonModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        quiz: QuizModel.fromJson(json['quiz'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'progress': progress,
        'isEnrolled': isEnrolled,
        'lessons': lessons
            .map((lesson) => LessonModel.fromEntity(lesson).toJson())
            .toList(),
        'quiz': QuizModel.fromEntity(quiz).toJson(),
      };
}

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.content,
    required super.order,
  });

  factory LessonModel.fromEntity(Lesson lesson) => LessonModel(
        id: lesson.id,
        title: lesson.title,
        content: lesson.content,
        order: lesson.order,
      );

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        order: json['order'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'order': order,
      };
}

class QuizModel extends Quiz {
  const QuizModel({
    required super.id,
    required super.courseId,
    required super.questions,
    required super.passingScore,
  });

  factory QuizModel.fromEntity(Quiz quiz) => QuizModel(
        id: quiz.id,
        courseId: quiz.courseId,
        questions: quiz.questions,
        passingScore: quiz.passingScore,
      );

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        id: json['id'] as String,
        courseId: json['courseId'] as String,
        passingScore: json['passingScore'] as int,
        questions: (json['questions'] as List<dynamic>)
            .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'passingScore': passingScore,
        'questions': questions
            .map((question) => QuestionModel.fromEntity(question).toJson())
            .toList(),
      };
}

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.text,
    required super.alternatives,
    required super.correctAnswer,
  });

  factory QuestionModel.fromEntity(Question question) => QuestionModel(
        id: question.id,
        text: question.text,
        alternatives: question.alternatives,
        correctAnswer: question.correctAnswer,
      );

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['id'] as String,
        text: json['text'] as String,
        correctAnswer: json['correctAnswer'] as String,
        alternatives: (json['alternatives'] as List<dynamic>)
            .map((item) =>
                AlternativeModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'correctAnswer': correctAnswer,
        'alternatives': alternatives
            .map((alt) => AlternativeModel.fromEntity(alt).toJson())
            .toList(),
      };
}

class AlternativeModel extends Alternative {
  const AlternativeModel({
    required super.id,
    required super.text,
    required super.isCorrect,
  });

  factory AlternativeModel.fromEntity(Alternative alternative) =>
      AlternativeModel(
        id: alternative.id,
        text: alternative.text,
        isCorrect: alternative.isCorrect,
      );

  factory AlternativeModel.fromJson(Map<String, dynamic> json) =>
      AlternativeModel(
        id: json['id'] as String,
        text: json['text'] as String,
        isCorrect: json['isCorrect'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isCorrect': isCorrect,
      };
}

class UserProgressModel extends UserProgress {
  const UserProgressModel({
    required super.userId,
    required super.courseId,
    required super.currentLessonId,
    required super.completedLessons,
    required super.quizAttempts,
  });

  factory UserProgressModel.fromEntity(UserProgress progress) =>
      UserProgressModel(
        userId: progress.userId,
        courseId: progress.courseId,
        currentLessonId: progress.currentLessonId,
        completedLessons: progress.completedLessons,
        quizAttempts: progress.quizAttempts,
      );

  factory UserProgressModel.fromJson(Map<String, dynamic> json) =>
      UserProgressModel(
        userId: json['userId'] as int,
        courseId: json['courseId'] as String,
        currentLessonId: json['currentLessonId'] as String,
        completedLessons:
            List<String>.from(json['completedLessons'] as List<dynamic>),
        quizAttempts: (json['quizAttempts'] as List<dynamic>)
            .map((item) =>
                QuizAttemptModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'courseId': courseId,
        'currentLessonId': currentLessonId,
        'completedLessons': completedLessons,
        'quizAttempts': quizAttempts
            .map((attempt) => QuizAttemptModel.fromEntity(attempt).toJson())
            .toList(),
      };
}

class QuizAttemptModel extends QuizAttempt {
  const QuizAttemptModel({
    required super.id,
    required super.courseId,
    required super.userId,
    required super.answers,
    required super.score,
    required super.passed,
    required super.date,
  });

  factory QuizAttemptModel.fromEntity(QuizAttempt attempt) => QuizAttemptModel(
        id: attempt.id,
        courseId: attempt.courseId,
        userId: attempt.userId,
        answers: attempt.answers,
        score: attempt.score,
        passed: attempt.passed,
        date: attempt.date,
      );

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) =>
      QuizAttemptModel(
        id: json['id'] as String,
        courseId: json['courseId'] as String,
        userId: json['userId'] as int,
        answers:
            Map<String, String>.from(json['answers'] as Map<dynamic, dynamic>),
        score: json['score'] as int,
        passed: json['passed'] as bool,
        date: DateTime.parse(json['date'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'userId': userId,
        'answers': answers,
        'score': score,
        'passed': passed,
        'date': date.toIso8601String(),
      };
}

class LearningStateModel extends LearningState {
  const LearningStateModel({
    required super.user,
    required super.courses,
    required super.progressByCourse,
  });
}
