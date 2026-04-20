import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/app_controller.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
    this.maxWidth = 1180,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final content = SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PageHeader(title: title, subtitle: subtitle),
                const SizedBox(height: 24),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            const SizedBox(width: 264, child: AppSidebar()),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eurocertifica'),
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Menu',
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const Drawer(width: 288, child: AppSidebar()),
      body: content,
    );
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final user = controller.user;
    final items = [
      _NavItem('Início', Icons.home_rounded, AppPage.dashboard),
      _NavItem('Cursos', Icons.menu_book_rounded, AppPage.courses),
      _NavItem('Rank', Icons.bar_chart_rounded, AppPage.ranking),
      _NavItem('Perfil & Certificados', Icons.workspace_premium_rounded, AppPage.profile),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  _LogoMark(size: 42),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eurocertifica',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Plataforma de Cursos',
                        style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (user != null)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: Color(0x333B82F6)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFDE047), size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '${user.points} pontos',
                          style: const TextStyle(
                            color: Color(0xFFFDE047),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(14),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final selected = controller.page == item.page;
                  return ListTile(
                    selected: selected,
                    selectedTileColor: const Color(0x263B82F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    leading: Icon(item.icon, color: Colors.white),
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () {
                      Navigator.maybePop(context);
                      controller.openPage(item.page);
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemCount: items.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: TextButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                label: const Text(
                  'Sair',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: const Color(0x1AFFFFFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.text,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(color: AppTheme.muted)),
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'E',
        style: TextStyle(
          color: AppTheme.primary,
          fontWeight: FontWeight.w900,
          fontSize: 22,
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon, this.page);

  final String label;
  final IconData icon;
  final AppPage page;
}
