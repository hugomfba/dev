import 'package:flutter/material.dart';

void main() => runApp(const TaskManagerApp());

// MODELO ---------------------------------------------------------------------

@immutable
class Task {
  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// ESTADO DA APLICAÇÃO ---------------------------------------------------------

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  final List<Task> _tasks = <Task>[
    const Task(
      id: 'task-1',
      title: 'Preparar apresentação',
      description: 'Organizar os slides e rever os exemplos para a aula.',
      isCompleted: true,
    ),
    const Task(
      id: 'task-2',
      title: 'Rever exercício Flutter',
      description: 'Testar o formulário e verificar a navegação.',
    ),
    const Task(
      id: 'task-3',
      title: 'Enviar apontamentos',
      description: 'Partilhar os materiais com a turma.',
    ),
  ];

  void _addTask(Task task) {
    setState(() => _tasks.insert(0, task));
  }

  void _updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index < 0) return;
    setState(() => _tasks[index] = updatedTask);
  }

  void _deleteTask(String id) {
    setState(() => _tasks.removeWhere((task) => task.id == id));
  }

  void _toggleTask(Task task) {
    _updateTask(task.copyWith(isCompleted: !task.isCompleted));
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0F9D8A);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: HomePage(
        tasks: List<Task>.unmodifiable(_tasks),
        onAdd: _addTask,
        onUpdate: _updateTask,
        onDelete: _deleteTask,
        onToggle: _toggleTask,
      ),
    );
  }
}

// HOME -----------------------------------------------------------------------

class HomePage extends StatelessWidget {
  const HomePage({
    required this.tasks,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
    required this.onToggle,
    super.key,
  });

  final List<Task> tasks;
  final ValueChanged<Task> onAdd;
  final ValueChanged<Task> onUpdate;
  final ValueChanged<String> onDelete;
  final ValueChanged<Task> onToggle;

  Future<void> _createTask(BuildContext context) async {
    final createdTask = await Navigator.of(context).push<Task>(
      MaterialPageRoute<Task>(builder: (_) => const TaskFormPage()),
    );

    if (createdTask != null) onAdd(createdTask);
  }

  Future<void> _editTask(BuildContext context, Task task) async {
    final updatedTask = await Navigator.of(context).push<Task>(
      MaterialPageRoute<Task>(builder: (_) => TaskFormPage(task: task)),
    );

    if (updatedTask != null) onUpdate(updatedTask);
  }

  void _openDetail(BuildContext context, Task task) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => TaskDetailPage(
          task: task,
          onUpdate: onUpdate,
          onDelete: onDelete,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar tarefa?'),
        content: Text('A tarefa “${task.title}” será removida.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) onDelete(task.id);
  }

  Widget _buildTaskList(BuildContext context, BoxConstraints constraints) {
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.task_alt,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Ainda não existem tarefas',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Cria a primeira tarefa para começar a organizar o teu trabalho.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => _createTask(context),
                icon: const Icon(Icons.add),
                label: const Text('Criar tarefa'),
              ),
            ],
          ),
        ),
      );
    }

    final wideLayout = constraints.maxWidth >= 760;
    if (wideLayout) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 4,
          mainAxisExtent: 104,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskTile(
            task: task,
            onOpen: () => _openDetail(context, task),
            onToggle: () => onToggle(task),
            onEdit: () => _editTask(context, task),
            onDelete: () => _confirmDelete(context, task),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          task: task,
          onOpen: () => _openDetail(context, task),
          onToggle: () => onToggle(task),
          onEdit: () => _editTask(context, task),
          onDelete: () => _confirmDelete(context, task),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((task) => task.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('$completedCount/${tasks.length} concluídas'),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  'As minhas tarefas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(child: _buildTaskList(context, constraints)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createTask(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.onOpen,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Task task;
  final VoidCallback onOpen;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onOpen,
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted ? muted : null,
          ),
        ),
        subtitle: Text(
          task.description.isEmpty ? 'Sem descrição' : task.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          tooltip: 'Ações da tarefa',
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem<String>(value: 'edit', child: Text('Editar')),
            PopupMenuItem<String>(value: 'delete', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }
}

// DETALHE --------------------------------------------------------------------

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({
    required this.task,
    required this.onUpdate,
    required this.onDelete,
    super.key,
  });

  final Task task;
  final ValueChanged<Task> onUpdate;
  final ValueChanged<String> onDelete;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _editTask() async {
    final updatedTask = await Navigator.of(context).push<Task>(
      MaterialPageRoute<Task>(builder: (_) => TaskFormPage(task: _task)),
    );

    if (updatedTask == null || !mounted) return;
    widget.onUpdate(updatedTask);
    setState(() => _task = updatedTask);
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar tarefa?'),
        content: Text('A tarefa “${_task.title}” será removida.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    widget.onDelete(_task.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe da tarefa'),
        actions: [
          IconButton(
            tooltip: 'Editar tarefa',
            onPressed: _editTask,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(
            _task.isCompleted ? Icons.task_alt : Icons.pending_actions,
            size: 56,
            color: scheme.primary,
          ),
          const SizedBox(height: 20),
          Text(
            _task.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Center(
            child: Chip(
              avatar: Icon(
                _task.isCompleted ? Icons.check_circle : Icons.schedule,
                size: 18,
              ),
              label: Text(_task.isCompleted ? 'Concluída' : 'Por concluir'),
            ),
          ),
          const SizedBox(height: 24),
          Text('Descrição', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            _task.description.isEmpty
                ? 'Esta tarefa não tem descrição.'
                : _task.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _editTask,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar tarefa'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _deleteTask,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Eliminar tarefa'),
          ),
        ],
      ),
    );
  }
}

// FORMULÁRIO DE CRIAÇÃO / EDIÇÃO --------------------------------------------

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({this.task, super.key});

  final Task? task;

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final existingTask = widget.task;

    final result = existingTask == null
        ? Task(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: title,
            description: description,
          )
        : existingTask.copyWith(
            title: title,
            description: description,
          );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar tarefa' : 'Nova tarefa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditing ? 'Atualizar detalhes' : 'Criar uma tarefa',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Preenche o título. Podes acrescentar uma descrição para dar contexto.',
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  maxLength: 60,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Título *',
                    hintText: 'Ex.: Rever o exercício Flutter',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Indica um título.';
                    }
                    if (value.trim().length > 60) {
                      return 'Usa até 60 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (opcional)',
                    hintText: 'Acrescenta detalhes úteis…',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saveTask,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_isEditing ? 'Guardar alterações' : 'Criar tarefa'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
