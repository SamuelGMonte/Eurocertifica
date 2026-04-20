class Quiz {
  const Quiz({
    required this.id,
    required this.courseId,
    required this.questions,
    required this.passingScore,
  });

  final String id;
  final String courseId;
  final List<Question> questions;
  final int passingScore;
}

class Question {
  const Question({
    required this.id,
    required this.text,
    required this.alternatives,
    required this.correctAnswer,
  });

  final String id;
  final String text;
  final List<Alternative> alternatives;
  final String correctAnswer;
}

class Alternative {
  const Alternative({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  final String id;
  final String text;
  final bool isCorrect;
}

class QuizAttempt {
  const QuizAttempt({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.answers,
    required this.score,
    required this.passed,
    required this.date,
  });

  final String id;
  final String courseId;
  final String userId;
  final Map<String, String> answers;
  final int score;
  final bool passed;
  final DateTime date;
}
