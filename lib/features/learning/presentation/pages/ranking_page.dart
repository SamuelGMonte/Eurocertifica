import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/app_controller.dart';
import '../widgets/app_scaffold.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppController>().user;
    final entries = _buildRanking(user);
    final userEntry = entries.where((entry) => entry.isUser).firstOrNull;

    return AppScaffold(
      title: 'Ranking Global',
      subtitle: 'Veja sua posição e compita com outros colaboradores',
      maxWidth: 920,
      child: ListView(
        children: [
          if (userEntry != null)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _HeroMetric(
                      label: 'Sua Posição',
                      value: '#${userEntry.rank}',
                    ),
                  ),
                  Expanded(
                    child: _HeroMetric(
                      label: 'Seus Pontos',
                      value: '${userEntry.points}',
                    ),
                  ),
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFDE047),
                    size: 56,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 22),
          Card(
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(const Color(0xFFF3F4F6)),
                columns: const [
                  DataColumn(label: Text('Posição')),
                  DataColumn(label: Text('Colaborador')),
                  DataColumn(label: Text('Pontos'), numeric: true),
                  DataColumn(label: Text('Badge')),
                ],
                rows: entries.map((entry) {
                  return DataRow(
                    color: entry.isUser
                        ? MaterialStateProperty.all(const Color(0xFFEFF6FF))
                        : null,
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: _rankColor(entry.rank),
                              child: Text(
                                '${entry.rank}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${entry.rank}º',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.name,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            if (entry.isUser)
                              const Text(
                                'Você',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      DataCell(Text('${entry.points}')),
                      DataCell(
                        Text(
                          entry.badge,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.military_tech_rounded, color: AppTheme.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Como ganhar pontos?\nComplete um curso: 100 pontos\nSeja aprovado na prova: 100 pontos\nMantenha uma sequência de estudos: bônus diário',
                    style: TextStyle(height: 1.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_RankingEntry> _buildRanking(dynamic user) {
    final entries = <_RankingEntry>[
      const _RankingEntry(name: 'João Silva', points: 450, badge: '🥇'),
      const _RankingEntry(name: 'Maria Santos', points: 420, badge: '🥈'),
      const _RankingEntry(name: 'Pedro Costa', points: 380, badge: '🥉'),
      const _RankingEntry(name: 'Ana Oliveira', points: 250, badge: ''),
      const _RankingEntry(name: 'Carlos Mendes', points: 200, badge: ''),
      const _RankingEntry(name: 'Lucia Ferreira', points: 180, badge: ''),
      const _RankingEntry(name: 'Roberto Alves', points: 150, badge: ''),
    ];

    if (user != null) {
      entries.add(
        _RankingEntry(
          name: user.name as String,
          points: _readPoints(user),
          badge: '★',
          isUser: true,
        ),
      );
    }

    entries.sort((a, b) => b.points.compareTo(a.points));

    return [
      for (var index = 0; index < entries.length; index++)
        entries[index].copyWith(rank: index + 1),
    ];
  }

  int _readPoints(dynamic user) {
    final rawPoints = user?.extraData?['points'];
    if (rawPoints is int) return rawPoints;
    if (rawPoints is num) return rawPoints.toInt();
    return 0;
  }

  Color _rankColor(int rank) {
    return switch (rank) {
      1 => const Color(0xFFEAB308),
      2 => const Color(0xFF9CA3AF),
      3 => const Color(0xFFEA580C),
      _ => AppTheme.primary,
    };
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFBFDBFE))),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _RankingEntry {
  const _RankingEntry({
    required this.name,
    required this.points,
    required this.badge,
    this.rank = 0,
    this.isUser = false,
  });

  final int rank;
  final String name;
  final int points;
  final String badge;
  final bool isUser;

  _RankingEntry copyWith({
    int? rank,
    String? name,
    int? points,
    String? badge,
    bool? isUser,
  }) {
    return _RankingEntry(
      rank: rank ?? this.rank,
      name: name ?? this.name,
      points: points ?? this.points,
      badge: badge ?? this.badge,
      isUser: isUser ?? this.isUser,
    );
  }
}
