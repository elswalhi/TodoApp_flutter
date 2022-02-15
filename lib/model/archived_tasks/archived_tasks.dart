import 'package:flutter/material.dart';
import 'package:todo/shared/Cubit/cubit.dart';
import 'package:todo/shared/Cubit/states.dart';
import '../../shared/components/Components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ArchivedTaksScreen extends StatelessWidget {
  const ArchivedTaksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, Appstates>(
        listener:(context,state){},
        builder:(context,Appstates state){
          List<Map>? tasks = AppCubit.get(context).archiveTasks;
          return AppCubit.get(context).archiveTasks!.isNotEmpty ? ListView.separated(itemBuilder:(context,index)=>buildTaskItem(tasks![index],context),
              separatorBuilder: (context,index)=>Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
              itemCount: tasks!.length) :EmptyScreen();
        }
    );
  }
}
