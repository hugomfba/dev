import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const StudentManagementApp());
}

/// Aplicação Principal
class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const StudentListPage(),
    );
  }
}

/// Modelo de Dados: Estudante
class Student {
  final int? id;
  final String name;
  final String course;
  final String email;

  Student({
    this.id,
    required this.name,
    required this.course,
    required this.email,
  });

  // Converter de Student para Map (para inserir na BD)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'email': email,
    };
  }

  // Converter de Map para Student (para ler da BD)
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      course: map['course'],
      email: map['email'],
    );
  }
}

/// Gestor da Base de Dados SQLite (Singleton)
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        course TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  // Inserir Estudante
  Future<int> insertStudent(Student student) async {
    final db = await instance.database;
    return await db.insert('students', student.toMap());
  }

  // Obter Lista de Estudantes
  Future<List<Student>> getStudents() async {
    final db = await instance.database;
    final result = await db.query('students', orderBy: 'name ASC');
    return result.map((json) => Student.fromMap(json)).toList();
  }

  // Apagar Estudante por ID
  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

/// Ecrã Principal com Listagem Dinâmica
class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late Future<List<Student>> _studentList;

  @override
  void initState() {
    super.initState();
    _refreshStudentList();
  }

  // Atualizar o estado para recarregar a lista da base de dados
  void _refreshStudentList() {
    setState(() {
      _studentList = DatabaseHelper.instance.getStudents();
    });
  }

  // Função para simular a adição rápida de um estudante de teste
  Future<void> _addNewStudentDialog() async {
    final newStudent = Student(
      name: 'Estudante CTeSP ${DateTime.now().second}',
      course: 'Tecnologias e Sistemas Web',
      email: 'aluno@ipca.pt',
    );
    await DatabaseHelper.instance.insertStudent(newStudent);
    _refreshStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Estudantes (CTeSP)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Student>>(
        future: _studentList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Sem estudantes registados.\nPrima o botão + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final students = snapshot.data!;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    child: Text(student.name.substring(0, 1)),
                  ),
                  title: Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${student.course}\n${student.email}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      if (student.id != null) {
                        await DatabaseHelper.instance.deleteStudent(student.id!);
                        _refreshStudentList();
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewStudentDialog,
        tooltip: 'Adicionar Estudante',
        child: const Icon(Icons.add),
      ),
    );
  }
}