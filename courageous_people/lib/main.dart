import 'package:courageous_people/log_in/cubit/log_in_repository.dart';
import 'package:courageous_people/log_out/cubit/log_out_cubit.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'home.dart';
import 'package:provider/provider.dart';

import 'log_in/cubit/log_in_cubit.dart';
import 'log_out/cubit/log_out_repository.dart';
import 'review/cubit/review_cubit.dart';
import 'review/cubit/review_repository.dart';


void main () => runApp(MyApp());

// Future<void> main() async {
//   // todo: 가게 목록 받아오기
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<StoreCubit>(
          create: (_) => StoreCubit(StoreRepository()),
        ),
        BlocProvider<ReviewCubit>(
            create: (_) => ReviewCubit(ReviewRepository()),
        ),
        // BlocProvider<UserCubit>(
        //     create: (_) => UserCubit(UserRepository()),
        // ),
        BlocProvider<LogInCubit>(
          create: (_) => LogInCubit(LogInRepository()),
        ),
        BlocProvider<LogOutCubit>(
            create: (_) => LogOutCubit(LogOutRepository()),
        ),
      ],
      child: MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
//stash test