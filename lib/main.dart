import 'package:flutter/material.dart';
import 'package:todo/shared/components/block_pbserver.dart';
import 'layout/home_layout.dart';
void main() {
  blocObserver: MyBlocObserver();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
    debugShowCheckedModeBanner: false,
      home:HomeLayout(),
    );
  }
}
