import 'package:flutter/material.dart';

void main() => runApp(const StudentCardApp());

class StudentCardApp extends StatelessWidget {
  const StudentCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafio 1 — Cartão de estudante',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const StudentCardPage(),
    );
  }
}

class StudentCardPage extends StatelessWidget {
  const StudentCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const student = Student(
      name: 'Rita Silva',
      number: '20260042',
      course: 'CTeSP em Sistemas de Informação e Tecnologias de Programação',
      email: 'rita.silva@example.pt',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Cartão de estudante')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          StudentProfileCard(student: student),
        ],
      ),
    );
  }
}

class Student {
  final String name;
  final String number;
  final String course;
  final String email;

  const Student({
    required this.name,
    required this.number,
    required this.course,
    required this.email,
  });
}

class StudentProfileCard extends StatelessWidget {
  final Student student;

  const StudentProfileCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 44,
                child: Icon(Icons.person, size: 48),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                student.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 6),
            Center(child: Chip(label: Text('N.º ${student.number}'))),
            const Divider(height: 28),
            const Text('Curso', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(student.course),
            const SizedBox(height: 16),
            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(student.email),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.account_circle_outlined),
                label: const Text('Ver perfil'),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text(student.name),
                      content: Text(
                        'Número: ${student.number}\n'
                        'Curso: ${student.course}\n'
                        'Email: ${student.email}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Fechar'),
                        ),
                      ],
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
