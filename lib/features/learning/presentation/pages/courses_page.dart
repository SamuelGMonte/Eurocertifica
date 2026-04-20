import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/course.dart';
import '../controllers/app_controller.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/course_widgets.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String _filter = 'Todos';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final categories = ['Todos', ...controller.courses.map((course) => course.category).toSet()];
    final courses = _filter == 'Todos'
        ? controller.courses
        : controller.courses.where((course) => course.category == _filter).toList();

    return AppScaffold(
      title: 'Cursos / Módulos',
      subtitle: 'Escolha um curso para começar sua jornada de aprendizado',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories
                  .map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _filter == category,
                        onSelected: (_) => setState(() => _filter = category),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final columns = width > 1040 ? 3 : width > 680 ? 2 : 1;
                return GridView.builder(
                  itemCount: courses.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    mainAxisExtent: 336,
                  ),
                  itemBuilder: (context, index) {
                    return _CourseCard(course: courses[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: Colors.white, size: 32),
                    const Spacer(),
                    Chip(
                      label: Text(course.category),
                      backgroundColor: const Color(0x33FFFFFF),
                      labelStyle: const TextStyle(color: Colors.white),
                      side: BorderSide.none,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  course.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFFDBEAFE)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Progresso', style: TextStyle(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text(
                        '${course.progress}%',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ProgressLine(value: course.progress),
                  const Spacer(),
                  if (!course.isEnrolled)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.enroll(course.id),
                        child: const Text('Inscrever-se'),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => controller.openCourse(course.id),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Continuar'),
                          ),
                        ),
                        if (course.progress == 100) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => controller.openQuiz(course.id),
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                              child: const Text('Refazer Prova'),
                            ),
                          ),
                        ],
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
