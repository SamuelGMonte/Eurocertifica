import 'quiz.dart';

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.progress,
    required this.isEnrolled,
    required this.lessons,
    required this.quiz,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final int progress;
  final bool isEnrolled;
  final List<Lesson> lessons;
  final Quiz quiz;

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? progress,
    bool? isEnrolled,
    List<Lesson>? lessons,
    Quiz? quiz,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      progress: progress ?? this.progress,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      lessons: lessons ?? this.lessons,
      quiz: quiz ?? this.quiz,
    );
  }
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
  });

  final String id;
  final String title;
  final String content;
  final int order;
}
