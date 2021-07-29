class TaskModel {
  final int id ;
  final String task ;
  final DateTime dateTime ;

  TaskModel({ required this.id, required this.task, required this.dateTime});


  Map <String  , dynamic> toMap(){
    return{
      'id' :id,
      'task' :task,
      'createdTime' :dateTime,

    };
  }
}