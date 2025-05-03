import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: TodoApp(),
    ),
  );
}

// -------------------- Task Model --------------------
class Task {
  String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}

// -------------------- Provider --------------------
class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String title) {
    _tasks.add(Task(title));
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].isDone = !_tasks[index].isDone;
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}

// -------------------- Main App --------------------
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beautiful Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: TodoHomePage(),
    );
  }
}

// -------------------- Home Page --------------------
class TodoHomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  void _addTask(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Provider.of<TaskProvider>(context, listen: false).addTask(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add Task Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter a new task',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addTask(context),
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Task List
            Expanded(
              child:
                  taskProvider.tasks.isEmpty
                      ? Center(child: Text("No tasks yet! Add one."))
                      : ListView.builder(
                        itemCount: taskProvider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.tasks[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.isDone,
                                onChanged:
                                    (_) => taskProvider.toggleTask(index),
                                activeColor: Colors.teal,
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration:
                                      task.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                  color:
                                      task.isDone
                                          ? Colors.grey
                                          : Colors.black87,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => taskProvider.deleteTask(index),
                              ),
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
