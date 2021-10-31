import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/log_in/repository/log_in_repository.dart';
import 'package:courageous_people/log_out/cubit/log_out_cubit.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_cubit.dart';
import 'package:courageous_people/sign_in/repository/sign_in_repository.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/repository/store_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'common/hive/token_hive.dart';
import 'home/screen/home.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'log_in/cubit/log_in_cubit.dart';
import 'log_out/repository/log_out_repository.dart';
import 'review/cubit/review_cubit.dart';
import 'review/cubit/review_repository.dart';

Future<void> main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  // ));

  await initHiveForFlutter(boxes: [
    HiveStore.defaultBoxName,
    TokenHive.tokenStore,
    UserHive.userStore,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => TokenService(),
        ),
        BlocProvider<StoreCubit>(
          create: (_) => StoreCubit(StoreRepository()),
        ),
        BlocProvider<ReviewCubit>(
          create: (_) => ReviewCubit(ReviewRepository()),
        ),
        BlocProvider<SignInCubit>(
          create: (_) => SignInCubit(SignInRepository()),
        ),
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