import 'package:flutter/material.dart';
import 'package:noteapp/database/database.dart';

import 'model/taskmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyTodoApp());
  }
}

class MyTodoApp extends StatefulWidget {
  @override
  _MyTodoAppState createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  Color mainColor = Color(0xFF0d0952);
  Color secondColor = Color(0xFF21061);
  Color btnColor = Color(0xFFff955b);
  Color editColor = Color(0xFF4044cc);

  TextEditingController inputController = TextEditingController();
  String newTasksTxt = '';
  getTasks() async {
    final tasks = await DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: mainColor,
          title: Text("All My Notes")),
      body: Column(children: [
        Expanded(
            child: FutureBuilder(
                future: getTasks(),
                builder: (context, AsyncSnapshot<dynamic> taskData) {
                  switch (taskData.connectionState) {
                    case ConnectionState.waiting:
                      {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    case ConnectionState.done:
                      {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListView.builder(
                              itemCount: taskData.data.length,
                              itemBuilder: (context, index) {
                                String task = taskData.data[index].toString();
                                String day = DateTime.parse(
                                        taskData.data[index]['createdTime'])
                                    .day
                                    .toString();
                                return Card(child: Text(task));
                              }),
                        );
                      }
                    case ConnectionState.none:
                      break;
                    case ConnectionState.active:
                      break;
                  }
                  return Container();
                })),
        Container(
          decoration: BoxDecoration(color: editColor),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              )),
              TextButton.icon(
                  onPressed: () {
                    setState(() {
                      newTasksTxt = inputController.text.toString();
                      inputController.text = '';
                    });
                    TaskModel newTask = TaskModel(
                      task: newTasksTxt,
                      dateTime: DateTime.now(),
                    );
                    DBProvider.dataBase.addNewTask(newTask);
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                  label: Text('ajouter')),
            ],
          ),
        )
      ]),
    );
  }
}
