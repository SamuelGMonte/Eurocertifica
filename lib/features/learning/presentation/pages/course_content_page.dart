import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/app_controller.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/course_widgets.dart';

class CourseContentPage extends StatefulWidget {
  const CourseContentPage({super.key});

  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  int _lessonIndex = 0;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final course = controller.selectedCourse;

    if (course == null) {
      return AppScaffold(
        title: 'Curso não encontrado',
        subtitle: 'Volte para a lista e escolha outro curso',
        child: Center(
          child: ElevatedButton(
            onPressed: () => controller.openPage(AppPage.courses),
            child: const Text('Voltar aos Cursos'),
          ),
        ),
      );
    }

    final lesson = course.lessons[_lessonIndex];
    final isLastLesson = _lessonIndex == course.lessons.length - 1;
    final visibleProgress = ((_lessonIndex / course.lessons.length) * 100).round();

    return AppScaffold(
      title: course.title,
      subtitle: 'Lição ${_lessonIndex + 1} de ${course.lessons.length}',
      maxWidth: 920,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => controller.openPage(AppPage.courses),
              icon: const Icon(Icons.chevron_left_rounded),
              label: const Text('Voltar aos Cursos'),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('Progresso do Curso'),
              const Spacer(),
              Text(
                '$visibleProgress%',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ProgressLine(value: visibleProgress, color: AppTheme.primary),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.description_rounded, color: AppTheme.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Lição ${_lessonIndex + 1}',
                              style: const TextStyle(color: AppTheme.muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    lesson.content,
                    style: const TextStyle(fontSize: 17, height: 1.55),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                    style: TextStyle(color: AppTheme.muted, height: 1.55),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.',
                    style: TextStyle(color: AppTheme.muted, height: 1.55),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _lessonIndex == 0
                    ? null
                    : () => setState(() => _lessonIndex -= 1),
                icon: const Icon(Icons.chevron_left_rounded),
                label: const Text('Anterior'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await controller.completeLesson(course.id, lesson.id);
                    if (isLastLesson) {
                      controller.openQuiz(course.id);
                    } else {
                      setState(() => _lessonIndex += 1);
                    }
                  },
                  label: Text(isLastLesson ? 'Fazer a Prova' : 'Próxima'),
                  icon: Icon(
                    isLastLesson
                        ? Icons.assignment_turned_in_rounded
                        : Icons.chevron_right_rounded,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lições do Curso',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (var index = 0; index < course.lessons.length; index++)
                        SizedBox(
                          width: 260,
                          child: OutlinedButton(
                            onPressed: () => setState(() => _lessonIndex = index),
                            style: OutlinedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              backgroundColor: index == _lessonIndex
                                  ? const Color(0xFFEFF6FF)
                                  : Colors.white,
                              side: BorderSide(
                                color: index == _lessonIndex
                                    ? AppTheme.primary
                                    : const Color(0xFFE5E7EB),
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.all(14),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: index == _lessonIndex
                                      ? AppTheme.primary
                                      : const Color(0xFFE5E7EB),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: index == _lessonIndex
                                          ? Colors.white
                                          : AppTheme.text,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    course.lessons[index].title,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
