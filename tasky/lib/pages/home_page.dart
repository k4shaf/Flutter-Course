import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:tasky/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double deviceWidth, deviceHeight;

  String? _newTaskContent;
  Box? _box;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        toolbarHeight: deviceHeight * 0.15, // height of bar
        title: Text(
          "Tasky!",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: _tasksView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      // future: Future.delayed(Duration(seconds: 3)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // snapshot contains the status of future and data returned
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _tasksList();
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }

  Widget _tasksList() {
    // ! tells dart that we know this value can't be null. (if condition applied above in code)
    List tasks = _box!.values.toList();

    // ADD NEW TASK MANUALLY - TO REMOVE
    // Task newTask = Task(title: "Do Everything :)", timestamp: DateTime.now(), done: false);
    // _box?.add(newTask.toMap());

    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = Task.fromMap(tasks[index]);
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                  decoration: task.done ? TextDecoration.lineThrough : null),
            ),
            subtitle: Text(task.timestamp.toString()),
            trailing: Icon(
              task.done
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              color: Colors.lightBlueAccent,
            ),
            onTap: () {
              task.done = !task.done;
              _box!.putAt(index, task.toMap());
              setState(() {});
            },
            onLongPress: (){
              _box!.deleteAt(index);
              setState(() {

              });
            },
          );
        });
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      backgroundColor: Colors.lightBlueAccent,
      child: Icon(Icons.add),
    );
  }

  void _displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Add a new task:",
            textAlign: TextAlign.center,
          ),
          content: TextField(
            onSubmitted: (value) {
              if (_newTaskContent != null) {
                var task = Task(
                    title: _newTaskContent!,
                    timestamp: DateTime.now(),
                    done: false);
                _box!.add(task.toMap());
                setState(() {
                  _newTaskContent = null;
                  // Removes the dialog from the stack
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (value) {
              _newTaskContent = value;
            },
          ),
        );
      },
    );
  }
}
