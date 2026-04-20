import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/quiz.dart';
import '../controllers/app_controller.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/course_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final user = controller.user!;
    final enrolled = controller.enrolledCourses;
    final certificates = enrolled
        .map((course) {
          final attempt = controller.progressByCourse[course.id]?.quizAttempts
              .where((item) => item.passed)
              .firstOrNull;
          return attempt == null ? null : _Certificate(course, attempt);
        })
        .whereType<_Certificate>()
        .toList();
    final completionRate = enrolled.isEmpty
        ? 0
        : ((certificates.length / enrolled.length) * 100).round();

    return AppScaffold(
      title: 'Perfil & Certificados',
      subtitle: 'Visualize seus certificados de conclusão',
      maxWidth: 920,
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(user.email, style: const TextStyle(color: AppTheme.muted)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Text('Pontos Totais', style: TextStyle(color: AppTheme.muted)),
                          Text(
                            '${user.points}',
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 34),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth > 560;
                      final children = [
                        _ProfileMetric('Cursos Inscritos', '${enrolled.length}', AppTheme.primary),
                        _ProfileMetric('Certificados', '${certificates.length}', AppTheme.success),
                        _ProfileMetric('Taxa de Conclusão', '$completionRate%', const Color(0xFF7C3AED)),
                      ];
                      return wide
                          ? Row(children: children.map((child) => Expanded(child: child)).toList())
                          : Column(children: children);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium_rounded, color: Color(0xFFEAB308)),
                      const SizedBox(width: 10),
                      Text(
                        'Certificados de Conclusão',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (certificates.isEmpty)
                    const EmptyState(
                      icon: Icons.workspace_premium_rounded,
                      message: 'Você ainda não tem certificados. Complete um curso e passe na prova!',
                    )
                  else
                    Column(
                      children: certificates
                          .map(
                            (certificate) => _CertificateTile(certificate: certificate),
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

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.muted)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _CertificateTile extends StatelessWidget {
  const _CertificateTile({required this.certificate});

  final _Certificate certificate;

  @override
  Widget build(BuildContext context) {
    final date = MaterialLocalizations.of(context).formatShortDate(certificate.attempt.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certificate.course.title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  '$date  •  Pontuação: ${certificate.attempt.score}%',
                  style: const TextStyle(color: AppTheme.muted),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Certificado de ${certificate.course.title} será baixado em breve!',
                ),
              ),
            ),
            icon: const Icon(Icons.download_rounded),
            label: const Text('Baixar'),
          ),
        ],
      ),
    );
  }
}

class _Certificate {
  const _Certificate(this.course, this.attempt);

  final Course course;
  final QuizAttempt attempt;
}
