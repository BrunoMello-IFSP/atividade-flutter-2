import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}

// Controle do tema (modo claro/escuro)
class ThemeController {
  ThemeController._privateConstructor();
  static final ThemeController instance = ThemeController._privateConstructor();

  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
}

// Página principal
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeController.instance.themeMode,
          builder: (context, themeMode, _) {
            final isDark = themeMode == ThemeMode.dark;
            return IconButton(
              icon: Icon(isDark ? Icons.nights_stay : Icons.wb_sunny),
              onPressed: () => ThemeController.instance.toggleTheme(),
            );
          },
        ),
        title: const Text('Demo App'),
      ),
      body: const HomeContent(),
    );
  }
}

// Corpo da página com vários componentes
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              CounterWidget(),
              SizedBox(height: 20),
              LikeButton(),
              SizedBox(height: 20),
              TaskList(),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget do contador +/-
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _increment() {
    setState(() => _counter++);
  }

  void _decrement() {
    setState(() => _counter--);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Contador: $_counter',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decrement,
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _increment),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de Curtir com contador
class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  int _likes = 0;

  void _like() {
    setState(() => _likes++);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Curtidas: $_likes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              color: Colors.pink,
              onPressed: _like,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de Lista de Tarefas
class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<String> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _tasks.add(_controller.text.trim());
      _controller.clear();
    });
  }

  void _removeTask(int index) {
    setState(() => _tasks.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Lista de Tarefas',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma tarefa',
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addTask),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeTask(index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
