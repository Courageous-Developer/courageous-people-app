import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_cubit.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_state.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignInScreen extends StatefulWidget {
  final int manageType;

  SignInScreen({Key? key, required this.manageType}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final _signInCubit = context.read<SignInCubit>();

    final _nicknameEditingController = TextEditingController();
    final _nicknameErrorNotifier = useState<String?>(null);

    final _emailEditingController = TextEditingController();
    final _emailErrorNotifier = useState<String?>(null);

    final _passwordEditingController = TextEditingController();
    final _passwordErrorNotifier = useState<String?>(null);

    final _password2EditingController = TextEditingController();
    final _password2ErrorNotifier = useState<String?>(null);

    final _emailNotifier = useState<bool>(false);
    final _nicknameNotifier = useState<bool>(false);
    final _passwordNotifier = useState<bool>(false);

    final _password2HelperNotifier = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap:() => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyInputForm(
                    title: Text('닉네임'),
                    controller: _nicknameEditingController,
                    textInputType: TextInputType.emailAddress,
                    errorText: _nicknameErrorNotifier.value,
                    onChanged: (innerText) {
                      if(innerText == '') {
                        _nicknameErrorNotifier.value = '올바른 값을 입력해주세요';
                        _nicknameNotifier.value = false;
                      }
                      else {
                        _nicknameErrorNotifier.value = null;
                      }
                    },
                    additionalButton: SizedBox(
                      child: ElevatedButton(
                        child: Text('중복 확인'),
                        onPressed: () {
                          // todo: if( 이메일이 중복되지 않았다면)
                          _emailNotifier.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  MyInputForm(
                    title: Text('이메일'),
                    controller: _emailEditingController,
                    textInputType: TextInputType.emailAddress,
                    errorText: _emailErrorNotifier.value,
                    onChanged: (innerText) {
                      if(innerText == '') {
                        _emailErrorNotifier.value = '올바른 값을 입력해주세요';
                        _emailNotifier.value = false;
                      }
                      else {
                        _emailErrorNotifier.value = null;
                      }
                    },
                    additionalButton: SizedBox(
                      child: ElevatedButton(
                        child: Text('중복 확인'),
                        onPressed: () {
                          // todo: if( 이메일이 중복되지 않았다면)
                          _emailNotifier.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // todo: 생년월일 입력 필드
                  // SizedBox(height: 20),
                  MyInputForm(
                    title: Text('비밀번호'),
                    // hintText: '비밀번호',
                    controller: _passwordEditingController,
                    textInputType: TextInputType.visiblePassword,
                    errorText: _passwordErrorNotifier.value,
                    obscureText: true,
                    onChanged: (innerText) {
                      if(innerText == '') {
                        _passwordErrorNotifier.value = '올바른 값을 입력해주세요';
                      }
                      else _passwordErrorNotifier.value = null;
                    },
                  ),
                  SizedBox(height: 20),
                  MyInputForm(
                    title: Text('비밀번호 확인'),
                    controller: _password2EditingController,
                    textInputType: TextInputType.visiblePassword,
                    errorText: _password2ErrorNotifier.value,
                    helperText: _password2HelperNotifier.value,
                    obscureText: true,
                    onChanged: (innerText) {
                      if (innerText == '') {
                        _password2ErrorNotifier.value = '올바른 값을 입력해주세요';
                      }
                      else {
                        _password2ErrorNotifier.value = null;

                        if(innerText == _passwordEditingController.text) {
                          _password2HelperNotifier.value = '비밀번호가 일치합니다';
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    child: BlocListener(
                      bloc: _signInCubit,
                      listener: (context, state) async {
                        if(state is SignInSuccessState) {
                          // final userId = state.user.id;
                          // final userEmail = state.user.email;
                          // final userNickname = state.user.nickname;
                          // final userBirthDate = state.user.birthDate;
                          // final userManegeFlag = state.user.managerFlag;
                          //
                          // UserHive().setUser(
                          //   userId,
                          //   userNickname,
                          //   userEmail,
                          //   userBirthDate,
                          //   userManegeFlag,
                          // );

                          Navigator.pop(context, (route) => route.isFirst);
                        }
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        // onPressed:  !_isAllSatisfied(
                        //   _nameNotifier.value,
                        //   _nicknameNotifier.value,
                        //   _emailNotifier.value,
                        //   _passwordNotifier.value,
                        // )
                        //     ? null
                        onPressed : () async {
                          await _signInCubit.signIn(
                            _nicknameEditingController.text,
                            _emailEditingController.text,
                            _passwordEditingController.text,
                            '1996-08-23',
                            widget.manageType,
                          );
                        },
                        child: Text('가입하기'),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width*0.9 ,
                    height:45,
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: Divider(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Text("간편하게 회원가입",
                        style: TextStyle(
                          color: Colors.black54,
                        ),),
                      Expanded(
                        child: new Container(
                          margin: const EdgeInsets.only(left: 10,),
                          child: Divider(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: ()=>{},
                        child: SizedBox(
                            height: 48,
                            child: Image.asset('assets/images/kakao_circular.png')
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: CircleBorder(),
                        ),
                      ),
                      ElevatedButton(onPressed: ()=>{},
                        child: SizedBox(
                            height: 48,
                            child: Image.asset('assets/images/naver_circular.png')
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: CircleBorder(),
                        ),
                      ),
                      ElevatedButton(onPressed: ()=>{},
                        child: SizedBox(
                            height: 48,
                            child: Image.asset('assets/images/google_circular.png')
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: CircleBorder(),
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

  bool _isAllSatisfied(
      bool nameCondition,
      bool nicknameCondition,
      bool emailCondition,
      bool passwordCondition
      ) {
    return emailCondition && nicknameCondition &&
        nameCondition && passwordCondition;
  }
}