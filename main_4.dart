import 'package:flutter/material.dart';

void main() => runApp(const StudentModelApp());

class StudentModelApp extends StatelessWidget {
  const StudentModelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafio 4 — Modelo e coleções',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const StudentCollectionsPage(),
    );
  }
}

class Student {
  final int id;
  final String name;
  final String course;

  const Student({required this.id, required this.name, required this.course});
}

class StudentCollectionsPage extends StatelessWidget {
  const StudentCollectionsPage({super.key});

  static const students = <Student>[
    Student(id: 1, name: 'Rita Silva', course: 'Programação'),
    Student(id: 2, name: 'João Costa', course: 'Redes'),
    Student(id: 3, name: 'Inês Lopes', course: 'Programação'),
    Student(id: 4, name: 'Miguel Santos', course: 'Cibersegurança'),
  ];

  @override
  Widget build(BuildContext context) {
    // where filtra os estudantes do curso pretendido.
    final programmingStudents = students
        .where((student) => student.course == 'Programação')
        .toList();

    // map transforma os objetos Student numa lista de nomes.
    final programmingNames = programmingStudents
        .map((student) => student.name)
        .toList();

    // fold percorre a coleção e acumula uma contagem.
    final programmingCount = students.fold<int>(
      0,
      (count, student) =>
          count + (student.course == 'Programação' ? 1 : 0),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Modelo e coleções em Dart')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Todos os estudantes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...students.map(
            (student) => Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(student.name[0])),
                title: Text(student.name),
                subtitle: Text(student.course),
                trailing: Text('#${student.id}'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Estudantes de Programação ($programmingCount)',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(programmingNames.join('\n')),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No código: where filtra, map transforma os elementos e fold acumula a contagem.',
          ),
        ],
      ),
    );
  }
}
