
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import "package:intl/intl.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/Cubit/cubit.dart';
import '../shared/Cubit/states.dart';
import '../shared/components/constance.dart';
Database? DB;
class HomeLayout extends StatelessWidget {

  var scaffoldkey=GlobalKey<ScaffoldState>();
  var formkey=GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();
  // ignore: non_constant_identifier_names
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , Appstates>(
        listener: (BuildContext context , Appstates state){
          if(state is AppInsertDataBase){
            Navigator.pop(context);
            titleController.text='';
            dateController.text='';
            timeController.text='';
          }
        },
        builder: (BuildContext context , Appstates state){
          AppCubit cubit = AppCubit.get(context);
          return  Scaffold(
              key: scaffoldkey,
              appBar: AppBar(
                title:  Text(cubit.titles[cubit.currentIndex]),
              ),
              floatingActionButton:FloatingActionButton(onPressed: ()  {
                if(cubit.isBottomSheetShown)
                {
                  if(formkey.currentState!.validate()){
                    cubit.insertDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                }else{
                  scaffoldkey.currentState?.showBottomSheet((context) => Container(
                    color:Colors.white,

                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              onTap: (){},
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.title),
                                labelText: "Title ",
                                border: OutlineInputBorder(),
                              ),
                              controller:titleController,
                              keyboardType: TextInputType.text,
                              validator:(value){
                                if(value==null || value.isEmpty){
                                  return 'title must be not empty';
                                }
                                return null;
                              } ,

                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              onTap: (){
                                showTimePicker(context: context, initialTime: TimeOfDay.now()).then(((value){
                                  timeController.text=value!.format(context).toString();
                                }))
                                ;

                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.timer),
                                labelText: "time ",
                                border: OutlineInputBorder(),
                              ),
                              controller:timeController,
                              keyboardType: TextInputType.datetime,
                              validator:(value){
                                if(value==null || value.isEmpty){
                                  return 'time must be not empty';
                                }
                                return null;
                              } ,

                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              onTap: (){

                                showDatePicker(context: context,
                                    initialDate:DateTime.now() ,
                                    firstDate: DateTime.now(), lastDate: DateTime.parse('2023-05-03'))
                                    .then((value){
                                  dateController.text=DateFormat.yMMMd().format(value!);
                                });
                              },
                              decoration: const InputDecoration(
                                prefixIcon: const Icon(Icons.date_range),
                                labelText: "Date ",
                                border: OutlineInputBorder(),
                              ),
                              controller:dateController,
                              keyboardType: TextInputType.datetime,
                              validator:(value){
                                if(value==null || value.isEmpty){
                                  return 'date must be not empty';
                                }
                                return null;
                              } ,

                            ),

                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                    ),
                  ),
                      elevation: 20).closed.then((value){
                        cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);


                }

              } ,child:
              Icon(cubit.fabIcon),),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index){
                  // setState(() {
                  cubit.changeIndex(index);
                  //   currentIndex=index;
                  // });
                },
                items:const  [
                  BottomNavigationBarItem(icon: Icon(Icons.menu),
                      label: "Tasks"),
                  BottomNavigationBarItem(icon: Icon(Icons.check_circle),
                      label: "Done"),
                  BottomNavigationBarItem(icon: Icon(Icons.archive_sharp),
                      label: "archived")
                ],),
              body:
            state is ! getDataBaseLodingState? cubit.screens[cubit.currentIndex] : const Center(child:const CircularProgressIndicator(
                semanticsLabel: 'Linear progress indicator',
              ),)
          );
        },
      ),
    );
  }

}
//1- create db
//2- open db
//3- crud
