import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/app_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D4ED8), Color(0xFF0F2F6E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Color(0x33000000), blurRadius: 20),
                      ],
                    ),
                    child: const Text(
                      'E',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Eurocertifica',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Bem-vindo, à área do colaborador!',
                    style: TextStyle(color: Color(0xFFDBEAFE)),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email/Usuário',
                                hintText: 'seu@email.com',
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Informe seu email ou usuário'
                                      : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Senha',
                                hintText: '••••••••',
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Informe sua senha'
                                      : null,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;
                                await context.read<AppController>().login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                              },
                              child: const Text('Entrar'),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Esqueceu a senha?'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
