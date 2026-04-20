import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/quiz.dart';
import '../controllers/app_controller.dart';
import '../widgets/app_scaffold.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _questionIndex = 0;
  final Map<String, String> _answers = {};
  QuizAttempt? _result;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final course = controller.selectedCourse;

    if (course == null) {
      return AppScaffold(
        title: 'Curso não encontrado',
        subtitle: 'A prova não pode ser carregada',
        child: const Center(child: Text('Curso não encontrado')),
      );
    }

    final questions = course.quiz.questions;
    if (_result != null) {
      return _QuizResult(
        courseTitle: course.title,
        passingScore: course.quiz.passingScore,
        questions: questions,
        answers: _answers,
        result: _result!,
        onRetake: () => setState(() {
          _questionIndex = 0;
          _answers.clear();
          _result = null;
        }),
      );
    }

    final currentQuestion = questions[_questionIndex];
    return AppScaffold(
      title: course.title,
      subtitle: 'Prova - Questão ${_questionIndex + 1} de ${questions.length}',
      maxWidth: 920,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => controller.openCourse(course.id),
              icon: const Icon(Icons.chevron_left_rounded),
              label: const Text('Voltar ao Curso'),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var index = 0; index < questions.length; index++)
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: FilledButton(
                        onPressed: () => setState(() => _questionIndex = index),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: _answers.containsKey(questions[index].id)
                              ? AppTheme.primary
                              : index == _questionIndex
                                  ? const Color(0xFFEFF6FF)
                                  : const Color(0xFFF3F4F6),
                          foregroundColor: _answers.containsKey(questions[index].id)
                              ? Colors.white
                              : AppTheme.text,
                        ),
                        child: Text('${index + 1}'),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentQuestion.text,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 24),
                  for (final alternative in currentQuestion.alternatives) ...[
                    _AlternativeTile(
                      label: alternative.text,
                      selected: _answers[currentQuestion.id] == alternative.id,
                      onTap: () => setState(() {
                        _answers[currentQuestion.id] = alternative.id;
                      }),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              OutlinedButton(
                onPressed: _questionIndex == 0
                    ? null
                    : () => setState(() => _questionIndex -= 1),
                child: const Text('Anterior'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _questionIndex == questions.length - 1
                    ? null
                    : () => setState(() => _questionIndex += 1),
                child: const Text('Próxima'),
              ),
              if (_questionIndex == questions.length - 1) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final attempt = await controller.submitQuiz(course.id, _answers);
                      if (!mounted) return;
                      setState(() => _result = attempt);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                    child: const Text('Enviar Prova'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AlternativeTile extends StatelessWidget {
  const _AlternativeTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppTheme.primary : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          color: selected ? const Color(0xFFEFF6FF) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppTheme.primary : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }
}

class _QuizResult extends StatelessWidget {
  const _QuizResult({
    required this.courseTitle,
    required this.passingScore,
    required this.questions,
    required this.answers,
    required this.result,
    required this.onRetake,
  });

  final String courseTitle;
  final int passingScore;
  final List<Question> questions;
  final Map<String, String> answers;
  final QuizAttempt result;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final correct = questions
        .where((question) => answers[question.id] == question.correctAnswer)
        .length;

    return AppScaffold(
      title: result.passed ? 'Aprovado!' : 'Reprovado',
      subtitle: 'Você acertou $correct de ${questions.length} questões',
      maxWidth: 820,
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    result.passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: 72,
                    color: result.passed ? AppTheme.success : const Color(0xFFDC2626),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ResultMetric('Pontuação', '${result.score}%', AppTheme.primary),
                      _ResultMetric('Acertos', '$correct', AppTheme.success),
                      _ResultMetric('Erros', '${questions.length - correct}', const Color(0xFFDC2626)),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: result.passed ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: result.passed ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                      ),
                    ),
                    child: Text(
                      result.passed
                          ? 'Parabéns! Você ganhou 100 pontos para seu ranking.'
                          : 'Você precisa de $passingScore% para ser aprovado. Tente novamente!',
                      style: TextStyle(
                        color: result.passed ? const Color(0xFF047857) : const Color(0xFF92400E),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Revisão das Respostas',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  for (final question in questions) _ReviewTile(question: question, answers: answers),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.openPage(AppPage.courses),
                  child: const Text('Voltar aos Cursos'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: result.passed
                      ? () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Certificado de $courseTitle será baixado em breve!'),
                            ),
                          )
                      : onRetake,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: result.passed ? AppTheme.success : AppTheme.primary,
                  ),
                  child: Text(result.passed ? 'Baixar Certificado' : 'Refazer Prova'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppTheme.muted)),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.question, required this.answers});

  final Question question;
  final Map<String, String> answers;

  @override
  Widget build(BuildContext context) {
    final userAnswer = answers[question.id];
    final selected = question.alternatives.where((alt) => alt.id == userAnswer).firstOrNull;
    final correct = question.alternatives.where((alt) => alt.id == question.correctAnswer).first;
    final isCorrect = userAnswer == question.correctAnswer;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? AppTheme.success : const Color(0xFFDC2626),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(question.text, style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Sua resposta: ${selected?.text ?? 'Sem resposta'}'),
          if (!isCorrect)
            Text(
              'Resposta correta: ${correct.text}',
              style: const TextStyle(color: AppTheme.success, fontWeight: FontWeight.w700),
            ),
        ],
      ),
    );
  }
}
