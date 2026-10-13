import 'package:flutter/material.dart';

void main() => runApp(const ResponsiveStudentApp());

class ResponsiveStudentApp extends StatefulWidget {
  const ResponsiveStudentApp({super.key});

  @override
  State<ResponsiveStudentApp> createState() => _ResponsiveStudentAppState();
}

class _ResponsiveStudentAppState extends State<ResponsiveStudentApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafio 3 — Tema responsivo',
      theme: ThemeData(useMaterial3: true, colorScheme: colorScheme),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      home: ResponsiveHomePage(onToggleTheme: _toggleTheme),
    );
  }
}

class ResponsiveHomePage extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const ResponsiveHomePage({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
        actions: [
          IconButton(
            tooltip: 'Alternar tema claro/escuro',
            onPressed: onToggleTheme,
            icon: const Icon(Icons.brightness_6_outlined),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 680;
          final summary = _summaryCard(context, screenWidth);
          final actions = _actionsCard(context);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: summary),
                          const SizedBox(width: 16),
                          Expanded(child: actions),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [summary, const SizedBox(height: 16), actions],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(BuildContext context, double screenWidth) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.school, size: 42, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text('Bem-vindo!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
              'Gere estudantes, consulta informação académica e mantém os dados organizados.',
            ),
            const SizedBox(height: 16),
            Chip(label: Text('Largura do ecrã: ${screenWidth.round()} px')),
          ],
        ),
      ),
    );
  }

  Widget _actionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Ações rápidas', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _showMessage(context, 'Adicionar estudante'),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Adicionar estudante'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _showMessage(context, 'Ver lista de estudantes'),
              icon: const Icon(Icons.groups_outlined),
              label: const Text('Ver estudantes'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _showMessage(context, 'Definições'),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Definições'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selecionaste: $message')),
    );
  }
}
