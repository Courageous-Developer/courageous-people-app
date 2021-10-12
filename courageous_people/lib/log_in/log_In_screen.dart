import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/widget/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:courageous_people/sign_in/sign_in_select_screen.dart';
import 'package:provider/provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home.dart';
import 'cubit/log_in_cubit.dart';
import 'cubit/log_in_state.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LogInScreen> {
  bool? _autoLogIn = false;

  @override
  Widget build(BuildContext context) {
    final _logInCubit = context.read<LogInCubit>();
    final emailInputController = TextEditingController();
    final passwordInputController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              child: Column(
                children: [
                  Image.asset('assets/images/logo_color.png'),
                  // SizedBox(height: 30,),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(),
                      ),
                      hintText: 'email',
                    ),
                    controller: emailInputController,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Password',
                    ),
                    controller: passwordInputController,
                  ),
                  SizedBox(
                    child: BlocListener(
                      bloc: _logInCubit,
                      listener: (context, state) async {
                        if (state is LogInSuccessState) {
                          _logInSuccessCallBack(context);
                        }
                        if (state is LogInFailedState) print("로그인 실패");
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)
                        ),
                        onPressed: () async {
                          await _logInCubit.logIn(
                            context,
                            emailInputController.text,
                            passwordInputController.text,
                          );
                        },
                        child: Text('로그인'),
                      ),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    height: 45,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
                          child: Checkbox(
                            value: _autoLogIn,
                            onChanged: (value) {
                              setState(() {
                                _autoLogIn = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Text(
                        '자동 로그인', style: TextStyle(color: Colors.grey[700]),),
                      Spacer(),
                      TextButton(onPressed: () {},
                        child: Text(
                          '아이디찾기',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Text(
                        ' | ',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      TextButton(onPressed: () {},
                        child: Text(
                          '비밀번호찾기',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            child: Divider(
                              color: Colors.grey[350],
                            )),
                      ),
                      Text(
                        "소셜 로그인",
                        style: TextStyle(
                            color: Colors.grey[350]
                        ),
                      ),
                      Expanded(
                        child: new Container(
                          margin: const EdgeInsets.only(left: 10,),
                          child: Divider(
                            color: Colors.grey[350],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () {},
                        child: SizedBox(
                            height: 48,
                            child: Image.asset(
                                'assets/images/kakao_circular.png')
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: CircleBorder(),
                        ),
                      ),
                      ElevatedButton(onPressed: () {},
                        child: SizedBox(
                            height: 48,
                            child: Image.asset(
                                'assets/images/naver_circular.png')
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: CircleBorder(),
                        ),
                      ),
                      ElevatedButton(onPressed: () {},
                        child: SizedBox(
                            height: 48,
                            child: Image.asset(
                                'assets/images/google_circular.png')
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('처음 사용하신다면?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInSelectScreen(),
                            ),
                          );
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            color: Color.fromRGBO(6, 69, 173, 1.0),
                            //decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _logInSuccessCallBack(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => Home(isUserVerified: true),
      ),
          (route) => false,
    );
  }
}