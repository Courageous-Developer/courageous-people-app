import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/log_in/cubit/log_in_repository.dart';
import 'package:courageous_people/log_out/cubit/log_out_cubit.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_cubit.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_repository.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_repository.dart';
import 'package:courageous_people/utils/user_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'common/hive/token_hive.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'log_in/cubit/log_in_cubit.dart';
import 'log_out/cubit/log_out_repository.dart';
import 'review/cubit/review_cubit.dart';
import 'review/cubit/review_repository.dart';
import 'utils/user_verification.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await initHiveForFlutter(boxes: [
    HiveStore.defaultBoxName,
    TokenHive.tokenStore,
    UserHive.userStore,
  ]);

  final bool userVerificationResult = await isUserVerified();

  runApp(MyApp(isUserVerified: userVerificationResult));
}

class MyApp extends StatelessWidget {
  final bool isUserVerified;
  const MyApp({Key? key, required this.isUserVerified}) : super(key: key);

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
        home: Home(isUserVerified: isUserVerified),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
//stash test