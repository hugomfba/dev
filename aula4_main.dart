import 'package:flutter/material.dart';

void main() => runApp(const StaticTaskManagerApp());

class StaticTaskManagerApp extends StatelessWidget {
  const StaticTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F9D8A),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager — Interface',
      theme: ThemeData(useMaterial3: true, colorScheme: colorScheme),
      home: const StaticHomePage(),
    );
  }
}

class StaticTask {
  const StaticTask({
    required this.title,
    required this.subtitle,
    this.completed = false,
  });

  final String title;
  final String subtitle;
  final bool completed;
}

class StaticHomePage extends StatelessWidget {
  const StaticHomePage({super.key});

  static const tasks = <StaticTask>[
    StaticTask(
      title: 'Preparar apresentação',
      subtitle: 'Hoje · 16:00',
      completed: true,
    ),
    StaticTask(
      title: 'Rever exercício Flutter',
      subtitle: 'Hoje · 18:00',
    ),
    StaticTask(
      title: 'Enviar apontamentos',
      subtitle: 'Amanhã',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.check_circle_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('As minhas tarefas', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '3 tarefas · 1 concluída',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(
                        task.completed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.completed
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.completed
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : null,
                        ),
                      ),
                      subtitle: Text(task.subtitle),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('A criação será implementada no desafio 3.')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}
