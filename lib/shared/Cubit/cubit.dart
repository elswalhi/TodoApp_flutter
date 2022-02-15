import 'package:todo/model/archived_tasks/archived_tasks.dart';
import 'package:todo/model/done_tasks/done_tasks.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/new_tasks/new_tasks.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
class AppCubit extends Cubit<Appstates>{
  AppCubit() :super(Appinitialstate());
  static AppCubit get(context)=>BlocProvider.of(context);
  List<String> titles=[
    "New Tasks", "Done Tasks","Archived Tasks"
  ];
  bool isBottomSheetShown = false;
  IconData fabIcon= Icons.edit;
  List<Map>? newTasks = [];
  List<Map>? doneTasks = [];
  List<Map>? archiveTasks = [];
  int currentIndex = 0;
  List<Widget> screens =[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTaksScreen(),
  ];
  Database? database;
  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version){
        print('Database Created');
        database.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
        ).then((value) {
          print('Table Created');
        }).catchError((error){
          print('error ${error.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDataBase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBase());
    });
  }
  void insertDatabase({
    required String title,
    required String date,
    required String time,
  })async {
    await database?.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date", "$time", "new")'
      ).then((value){
        print('$value inserted successfully');
        emit(AppInsertDataBase());
        getDataFromDataBase(database);
      }).catchError((error){
        print('error insert $error');
      });
      return null;
    });
  }
void DeleteData({
  @required int? id
}){
    database?.rawDelete('delete from tasks where id=?',[id]).then((value){
      emit(AppDeleteDataBase());
      getDataFromDataBase(database);
    });
}
 void getDataFromDataBase(database){
    newTasks=[];
    archiveTasks=[];
    doneTasks=[];
    emit(getDataBaseLodingState());
  database.rawQuery('SELECT * FROM tasks').then((value){
    value?.forEach((element){
      if(element['status']=='new'){
        newTasks?.add(element);
      }
      else if(element['status']=='done'){
        doneTasks?.add(element);
      }
      else{
        archiveTasks?.add(element);
      }
    });
    emit(AppGetDataBase());
  });
  }
 void updateData({
    @required String? status,
    @required int? id,

}) async{
     database!.rawUpdate('update tasks set status = ? where id = ?',
    ['$status',id]
    ).then((value){
      emit(AppUpdatetDataBase());
      getDataFromDataBase(database);
      print(value);
     });
  }
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }
  void changeBottomSheetState({@required bool? isShow, @required IconData? icon,  }){
    isBottomSheetShown = isShow! ;
    fabIcon=icon!;
    emit(ChangeBottomSheetState());
  }
}

