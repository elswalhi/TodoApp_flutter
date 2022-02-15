import 'package:flutter/material.dart';
import 'package:todo/shared/Cubit/cubit.dart';
Widget buildTaskItem(Map model, context)=>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).DeleteData(id: model['id']);
  },
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Container(
  
      padding: EdgeInsets.all(15),
  
      width: 300,
  
  
  
      child: Row(
  
        children: [
  
          CircleAvatar(
  
            radius: 40,
  
            backgroundColor:Colors.blue ,
  
            child: Text(model['time']),
  
          ),
  
          SizedBox(width: 20,),
  
          Expanded(
  
            child: Column(
  
              mainAxisAlignment: MainAxisAlignment.start,
  
              crossAxisAlignment: CrossAxisAlignment.start,
  
              mainAxisSize: MainAxisSize.min,
  
              children: [
  
                Text(model['title'],
  
                  style: TextStyle(
  
                    fontSize: 20,
  
                    fontWeight: FontWeight.bold,
  
                  ),),
  
                Text(model['date'],
  
                  style: TextStyle(
  
                    color:Colors.grey,
  
                  ),),
  
              ],
  
            ),
  
          ),
  
          SizedBox(width: 20,),
  
          IconButton(icon: Icon(Icons.check_box,color: Colors.green,), onPressed: () {
  
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
  
          },),
  
          IconButton(icon: Icon(Icons.archive_sharp ,color: Colors.black45,), onPressed: () {
  
            AppCubit.get(context).updateData(status: 'archived', id: model['id']);
  
          },),
  
  
  
  
  
        ],
  
      ),
  
    ),
  
  ),
);

Widget EmptyScreen()=>Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Icon(Icons.menu,size: 100,color: Colors.grey,),
      Text("No Tasks yet please Add some",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey),),
    ],
  ),
);