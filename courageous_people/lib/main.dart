import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


void main () => runApp(MyApp());

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