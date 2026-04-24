import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/app_controller.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/course_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final user = controller.user!;
    final enrolled = controller.enrolledCourses;

    return AppScaffold(
      title: 'Bem-vindo, ${user.name}!',
      subtitle: 'Acompanhe seu progresso e continue aprendendo',
      child: ListView(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 560
                      ? 2
                      : 1;
              return GridView.count(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: columns == 1 ? 3.2 : 1.55,
                children: [
                  StatCard(
                    label: 'Pontos',
                    value: '${user.extraData!['points']}',
                    icon: Icons.trending_up_rounded,
                    color: AppTheme.primary,
                  ),
                  StatCard(
                    label: 'Inscritos',
                    value: '${controller.enrolledCourses.length}',
                    icon: Icons.menu_book_rounded,
                    color: const Color(0xFF7C3AED),
                  ),
                  StatCard(
                    label: 'Concluídos',
                    value: '${controller.completedCourses.length}',
                    icon: Icons.workspace_premium_rounded,
                    color: AppTheme.success,
                  ),
                  StatCard(
                    label: 'Progresso Médio',
                    value: '${controller.averageProgress}%',
                    icon: Icons.show_chart_rounded,
                    color: AppTheme.warning,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seus Cursos',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 18),
                  if (enrolled.isEmpty)
                    EmptyState(
                      icon: Icons.menu_book_rounded,
                      message: 'Você ainda não se inscreveu em nenhum curso',
                      action: ElevatedButton(
                        onPressed: () => controller.openPage(AppPage.courses),
                        child: const Text('Explorar Cursos'),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: enrolled
                          .map(
                            (course) => SizedBox(
                              width: 360,
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color(0xFFE5E7EB), width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              course.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                          Chip(
                                            label: Text(course.category),
                                            backgroundColor:
                                                const Color(0xFFEFF6FF),
                                            labelStyle: const TextStyle(
                                                color: AppTheme.primary),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        course.description,
                                        style: const TextStyle(
                                            color: AppTheme.muted),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          const Text('Progresso'),
                                          const Spacer(),
                                          Text(
                                            '${course.progress}%',
                                            style: const TextStyle(
                                              color: AppTheme.primary,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      ProgressLine(value: course.progress),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              controller.openCourse(course.id),
                                          child: const Text('Continuar'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
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
