import '../models/learning_models.dart';

class CourseSeed {
  List<CourseModel> initialCourses() {
    return List.generate(5, (index) {
      final number = index + 1;
      final titles = [
        'Lorem Ipsum Dolor',
        'Consectetur Adipiscing',
        'Sed Do Eiusmod',
        'Tempor Incididunt',
        'Labore Et Dolore',
      ];
      final categories = [
        'Desenvolvimento',
        'Design',
        'Marketing',
        'Desenvolvimento',
        'Design',
      ];
      final descriptions = [
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        'Consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'Tempor incididunt ut labore et dolore magna aliqua ut enim.',
        'Labore et dolore magna aliqua ut enim ad minim veniam.',
      ];

      return CourseModel(
        id: '$number',
        title: titles[index],
        description: descriptions[index],
        category: categories[index],
        progress: 0,
        isEnrolled: false,
        lessons: [
          LessonModel(
            id: '$number-1',
            title: index == 0 ? 'Introdução' : 'Aula 1',
            content:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            order: 1,
          ),
          LessonModel(
            id: '$number-2',
            title: index == 0 ? 'Conceitos Básicos' : 'Aula 2',
            content:
                'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            order: 2,
          ),
        ],
        quiz: QuizModel(
          id: 'q$number',
          courseId: '$number',
          passingScore: 70,
          questions: _questions(number),
        ),
      );
    });
  }

  List<QuestionModel> _questions(int courseId) {
    return List.generate(10, (index) {
      final number = index + 1;
      return QuestionModel(
        id: 'q$courseId-$number',
        text:
            'Pergunta $number: Lorem ipsum dolor sit amet, consectetur adipiscing elit?',
        correctAnswer: 'a$number-1',
        alternatives: [
          AlternativeModel(
            id: 'a$number-1',
            text: 'Alternativa A - Lorem ipsum (certo)',
            isCorrect: true,
          ),
          AlternativeModel(
            id: 'a$number-2',
            text: 'Alternativa B - Consectetur adipiscing (errado)',
            isCorrect: false,
          ),
          AlternativeModel(
            id: 'a$number-3',
            text: 'Alternativa C - Sed do eiusmod (errado)',
            isCorrect: false,
          ),
          AlternativeModel(
            id: 'a$number-4',
            text: 'Alternativa D - Tempor incididunt (errado)',
            isCorrect: false,
          ),
        ],
      );
    });
  }
}
