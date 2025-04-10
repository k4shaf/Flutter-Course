class Task {
  String title;
  DateTime timestamp;
  bool done;

  Task({required this.title, required this.timestamp, required this.done});

  // returns this class's object from map
  // if you print(myTask) it will print -> Instance of 'Task'
  factory Task.fromMap(Map task) {
    return Task(
      title: task["title"],
      timestamp: task["timestamp"],
      done: task["done"],
    );
  }

  // returns a map of the Task obj
  Map toMap() {
    return {
      "title": title,
      "timestamp": timestamp,
      "done": done,
    };
  }
}
