                       //1

// import 'package:flutter/material.dart';

// void main() {
//   runApp(ToDoApp());
// }

// class ToDoApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('To-Do-Liste'),
//         ),
//         body: ToDoEntryWidget(),
//       ),
//     );
//   }
// }

// class ToDoEntryWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Checkbox(
//         value: false,
//         onChanged: (bool? value) {
//           // Handle checkbox changes
//         },
//       ),
//       title: Text('To-Do-Eintrag'),
//     );
//   }
// }



               // 2

// import 'package:flutter/material.dart';

// void main() {
//   runApp(ToDoApp());
// }

// class ToDoApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ToDoList(),
//     );
//   }
// }

// class ToDoList extends StatefulWidget {
//   @override
//   _ToDoListState createState() => _ToDoListState();
// }

// class _ToDoListState extends State<ToDoList> {
//   List<String> todos = ['To-Do 1', 'To-Do 2', 'To-Do 3']; // Beispiel-To-Dos

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('To-Do-Liste'),
//       ),
//       body: ListView.builder(
//         itemCount: todos.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(todos[index]),
//           );
//         },
//       ),
//     );
//   }
// }


                       // 3

// import 'package:flutter/material.dart';

// void main() {
//   runApp(ToDoApp());
// }

// class ToDoApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ToDoList(),
//     );
//   }
// }

// class ToDoList extends StatefulWidget {
//   @override
//   _ToDoListState createState() => _ToDoListState();
// }

// class _ToDoListState extends State<ToDoList> {
//   List<ToDoItem> todos = [
//     ToDoItem(title: 'To-Do 1', isDone: false),
//     ToDoItem(title: 'To-Do 2', isDone: true),
//     ToDoItem(title: 'To-Do 3', isDone: false),
//   ]; // Beispiel-To-Dos

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('To-Do-Liste'),
//       ),
//       body: ListView.builder(
//         itemCount: todos.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: Checkbox(
//               value: todos[index].isDone,
//               onChanged: (bool? value) {
//                 setState(() {
//                   todos[index].isDone = value!;
//                 });
//               },
//             ),
//             title: Text(
//               todos[index].title,
//               style: TextStyle(
//                 decoration: todos[index].isDone
//                     ? TextDecoration.lineThrough
//                     : TextDecoration.none,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ToDoItem {
//   final String title;
//   bool isDone;

//   ToDoItem({required this.title, required this.isDone});
// }




                       // Zusatzaufgabe

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  late List<ToDoItem> todos = [];

  @override
  void initState() {
    super.initState();
    loadToDoList();
  }

  Future<void> loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedList = prefs.getString('todo_list');
    if (storedList != null) {
      Iterable decoded = jsonDecode(storedList);
      todos = decoded.map((item) => ToDoItem.fromJson(item)).toList().cast<ToDoItem>();
    } else {
      todos = [
        ToDoItem(title: 'To-Do 1', isDone: false),
        ToDoItem(title: 'To-Do 2', isDone: true),
        ToDoItem(title: 'To-Do 3', isDone: false),
      ];
    }
    setState(() {});
  }

  Future<void> saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('todo_list', jsonEncode(todos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do-Liste'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Checkbox(
              value: todos[index].isDone,
              onChanged: (bool? value) {
                setState(() {
                  todos[index].isDone = value!;
                  saveToDoList();
                });
              },
            ),
            title: Text(
              todos[index].title,
              style: TextStyle(
                decoration: todos[index].isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ToDoItem {
  final String title;
  bool isDone;

  ToDoItem({required this.title, required this.isDone});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }

  factory ToDoItem.fromJson(Map<String, dynamic> json) {
    return ToDoItem(
      title: json['title'],
      isDone: json['isDone'],
    );
  }
}
