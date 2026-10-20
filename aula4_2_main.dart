import 'package:flutter/material.dart';

void main() => runApp(const StateChallengeApp());

class StateChallengeApp extends StatelessWidget {
  const StateChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafio 2 — Estado',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F9D8A),
        ),
      ),
      home: const StateChallengePage(),
    );
  }
}

class StateChallengePage extends StatefulWidget {
  const StateChallengePage({super.key});

  @override
  State<StateChallengePage> createState() => _StateChallengePageState();
}

class _StateChallengePageState extends State<StateChallengePage> {
  final List<String> _tasks = <String>[
    'Preparar apresentação',
    'Rever exercício Flutter',
    'Enviar apontamentos',
  ];
  final List<bool> _completed = <bool>[true, false, false];

  void _toggle(int index, bool? value) {
    setState(() {
      _completed[index] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _completed.where((completed) => completed).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Desafio 2 · Estado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Concluídas: $doneCount / ${_tasks.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: CheckboxListTile(
                      value: _completed[index],
                      onChanged: (value) => _toggle(index, value),
                      title: Text(
                        _tasks[index],
                        style: TextStyle(
                          decoration: _completed[index]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
