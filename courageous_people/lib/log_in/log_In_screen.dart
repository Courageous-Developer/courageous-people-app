import 'package:courageous_people/common/constants.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 55, vertical: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logoSection(),
            _LogInForm(),
            SizedBox(height: 50),
            _socialLogInSection(),
          ],
        ),
      ),
    );
  }

  Widget _logoSection() => Padding(
    padding: EdgeInsets.only(left: 30, right: 30, top: 30),
    child: Image.asset('assets/images/logo_color.png'),
  );

  Widget _socialLogInSection() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  endIndent: 10,
                  color: Colors.grey.shade700,
                ),
              ),
              Text("소셜 로그인"),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  indent: 10,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/images/kakao_circular.png'),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/images/naver_circular.png'),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    'assets/images/google_circular.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogInForm extends StatelessWidget {
  const _LogInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _logInCubit = context.read<LogInCubit>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          decoration: InputDecoration(hintText: 'Email'),
          controller: emailController,
        ),
        TextField(
          obscureText: true,
          decoration: InputDecoration(hintText: 'Password'),
          controller: passwordController,
        ),
        SizedBox(height: 15),
        BlocListener(
          bloc: _logInCubit,
          listener: (context, state) async {
            if (state is LogInSuccessState) {
              _logInSuccessCallBack(context);
            }
            if (state is LogInFailedState) print("로그인 실패");
          },
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: THEME_COLOR,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '로그인',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () async {
              await _logInCubit.logIn(
                context,
                emailController.text,
                passwordController.text,
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '처음이신가요?',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(width: 4),
            InkWell(
              onTap: () {
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
                  fontSize: 13,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _logInSuccessCallBack(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => Home(succeedLogIn: true),
      ),
          (route) => false,
    );
  }
}
