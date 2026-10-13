import 'package:flutter/material.dart';

void main() => runApp(const StudentListApp());

class StudentListApp extends StatelessWidget {
  const StudentListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafio 2 — Lista de estudantes',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const StudentListPage(),
    );
  }
}

class Student {
  final int id;
  final String name;
  final String course;

  const Student({required this.id, required this.name, required this.course});
}

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  static const students = <Student>[
    Student(id: 1, name: 'Rita Silva', course: 'Multimédia'),
    Student(id: 2, name: 'João Costa', course: 'Programação'),
    Student(id: 3, name: 'Inês Lopes', course: 'Redes e Sistemas'),
    Student(id: 4, name: 'Miguel Santos', course: 'Programação'),
    Student(id: 5, name: 'Carolina Alves', course: 'Cibersegurança'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudantes'),
        actions: [
          IconButton(
            tooltip: 'Informação',
            icon: const Icon(Icons.info_outline),
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Lista de estudantes',
              applicationVersion: '1.0.0',
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: ListTile(
              key: ValueKey(student.id),
              leading: CircleAvatar(child: Text(student.name[0])),
              title: Text(student.name),
              subtitle: Text(student.course),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Selecionaste ${student.name}.')),
                  );
              },
            ),
          );
        },
      ),
    );
  }
}
