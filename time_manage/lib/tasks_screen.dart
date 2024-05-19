import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TasksScreen(),
    );
  }
}

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _dateEditingController = TextEditingController();
  TextEditingController _timeEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    final storedTasks = LocalStorage().getItem('tasks');
    if (storedTasks != null) {
      setState(() {
        tasks = List<Task>.from(storedTasks.map((task) => Task.fromJson(task)));
      });
    }
  }

  void _saveTasks() {
    List<Map<String, dynamic>> taskJson = tasks.map((task) => task.toJson()).toList();
    LocalStorage().setItem('tasks', taskJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Завдання'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Введіть завдання...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _showDatePicker(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () {
                    _showTimePicker(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addTask();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      tasks[index].name,
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      'Deadline: ${tasks[index].deadline}',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _startEditingTask(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteTask(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _saveTasks();
    });
  }

  void addTask() {
    String newTaskName = _textEditingController.text.trim();
    String deadlineDate = _dateEditingController.text.trim();
    String deadlineTime = _timeEditingController.text.trim();
    if (newTaskName.isNotEmpty && deadlineDate.isNotEmpty && deadlineTime.isNotEmpty) {
      setState(() {
        tasks.add(Task(name: newTaskName, deadline: '$deadlineDate $deadlineTime'));
        _saveTasks();
        _textEditingController.clear();
        _dateEditingController.clear();
        _timeEditingController.clear();
      });
    }
  }

  void _startEditingTask(int index) {
    setState(() {
      _textEditingController.text = tasks[index].name;
      _dateEditingController.text = tasks[index].deadline.split(' ')[0];
      _timeEditingController.text = tasks[index].deadline.split(' ')[1];
    });
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      _dateEditingController.text = pickedDate.toString().split(' ')[0];
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      _timeEditingController.text = pickedTime.format(context);
    }
  }
}

class Task {
  String name;
  final String deadline;

  Task({required this.name, required this.deadline});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      deadline: json['deadline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'deadline': deadline,
    };
  }
}

class LocalStorage {
  static Map<String, dynamic> _storage = {};

  dynamic getItem(String key) {
    return _storage[key];
  }

  void setItem(String key, dynamic value) {
    _storage[key] = value;
  }

  void removeItem(String key) {
    _storage.remove(key);
  }
}
