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
        debugShowCheckedModeBanner: false,
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
  int currentIndex = 0;

  TextEditingController inputController = TextEditingController();
  String newTasksTxt = '';
  String newTaskst = '';

  getTasks() async {
    final tasks = await DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  deleteTasks(int id) async {
    return await DBProvider.dataBase.delete(id);
  }

  updateTasks(int id, task) async {
    return await DBProvider.dataBase.update(task, id);
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
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.done:
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: taskData.data.length,
                            itemBuilder: (context, index) {
                              String tasks =
                                  taskData.data[index]['task'].toString();
                              String day = DateTime.parse(
                                      taskData.data[index]['createdTime'])
                                  .day
                                  .toString();
                              return Dismissible(
                                key: Key(taskData.data[index]['task']),
                                onDismissed: (direction) {
                                  deleteTasks(taskData.data[index]['id']);
                                  setState(() {
                                    taskData.data.removeAt(index);
                                  });
                                },
                                child: InkWell(
                                  onTap: () {
                                    currentIndex = index;
                                    inputController.text =
                                        taskData.data[index]['task'];
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: CircleAvatar(child: Text(day)),
                                      title: Text(tasks),
                                      trailing: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                            ),
                                            onPressed: () {
                                              currentIndex = index;
                                              taskData.data
                                                  .update(currentIndex);
                                              newTaskst = inputController.text;
                                              setState(() {});
                                            },
                                          )),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );

                    case ConnectionState.none:
                      break;
                    case ConnectionState.active:
                      break;
                  
                  }
                  return Container();
                })),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: editColor),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                  hintText: 'Que veux tu faire ?',
                  filled: true,
                  fillColor: Colors.white,
                ),
              )),
              TextButton.icon(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
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
