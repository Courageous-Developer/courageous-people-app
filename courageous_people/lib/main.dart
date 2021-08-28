import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


void main () => runApp(MyApp());

// Future<void> main() async {
//   // todo: 가게 목록 받아오기
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
//stash test