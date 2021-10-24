import 'dart:math';

import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_cubit.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_state.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:email_validator/email_validator.dart';

import '../home.dart';

class SignInScreen extends HookWidget {
  final int managerFlag;

  SignInScreen({Key? key, required this.managerFlag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _signInCubit = context.read<SignInCubit>();

    final _nicknameNotifier = useState('');
    final _nicknameErrorNotifier = useState<String?>(null);
    final _nicknameHelperNotifier = useState<String?>(null);
    final _nicknameCertificatedNotifier = useState(false);

    final _emailNotifier = useState('');
    final _emailErrorNotifier = useState<String?>(null);

    final _passwordNotifier = useState('');
    final _passwordErrorNotifier = useState<String?>(null);

    final _password2Notifier = useState('');
    final _password2ErrorNotifier = useState<String?>(null);
    final _password2HelperNotifier = useState<String?>(null);

    final _managerCertificatedNotifier = useState<bool?>(null);

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap:() => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyInputForm(
                  title: Text('닉네임'),
                  textInputType: TextInputType.emailAddress,
                  errorText: _nicknameErrorNotifier.value,
                  helperText: _nicknameHelperNotifier.value,
                  onChanged: (nickname) {
                    _nicknameCertificatedNotifier.value = false;
                    _nicknameNotifier.value = nickname;

                    if(nickname == '') {
                      _nicknameErrorNotifier.value = '닉네임을 입력해주세요';
                      return;
                    }

                    _nicknameErrorNotifier.value = null;
                  },
                  additionalButton: BlocListener<SignInCubit, SignInState>(
                    bloc: _signInCubit,
                    listener: (context, state) async {
                      if(state is NicknameCheckedState) {
                        showAlertDialog(
                          context: context,
                          title: state.message,
                        );

                        _nicknameErrorNotifier.value = null;
                        _nicknameHelperNotifier.value = '사용 가능한 닉네임입니다';
                        _nicknameCertificatedNotifier.value = true;
                      }

                      if(state is NicknameCheckErrorState) {
                        showAlertDialog(
                          context: context,
                          title: '이미 사용중인 닉네임입니다',
                        );

                        _nicknameHelperNotifier.value = null;
                        _nicknameErrorNotifier.value = '이미 사용중인 닉네임입니다';
                      }
                    },
                    child: ElevatedButton(
                      child: Text('중복 확인'),
                      onPressed: () async {
                        await _signInCubit.checkNicknameDuplicated(_nicknameNotifier.value);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MyInputForm(
                  title: Text('이메일'),
                  textInputType: TextInputType.emailAddress,
                  errorText: _emailErrorNotifier.value,
                  onChanged: (email) {
                    _emailNotifier.value = email;

                    if(email == '') {
                      _emailErrorNotifier.value = '이메일을 입력해주세요';
                      return;
                    }

                    if(!(EmailValidator.validate(email))) {
                      _emailErrorNotifier.value = '잘못된 이메일 형식입니다';
                      return;
                    }

                    _emailErrorNotifier.value = null;
                  },
                ),
                SizedBox(height: 20),
                // todo: 생년월일 입력 필드
                // SizedBox(height: 20),
                MyInputForm(
                  title: Text('비밀번호'),
                  textInputType: TextInputType.visiblePassword,
                  errorText: _passwordErrorNotifier.value,
                  obscureText: true,
                  onChanged: (password) {
                    _passwordNotifier.value = password;

                    if(password == '') {
                      _passwordErrorNotifier.value = '비밀번호를 입력해주세요';
                      return;
                    }

                    _passwordErrorNotifier.value = null;

                    if(_password2Notifier.value == '') return;

                    if(_password2Notifier.value != '' && password != _password2Notifier.value) {
                      _password2ErrorNotifier.value = '비밀번호가 일치하지 않습니다';
                      return;
                    }

                    _password2ErrorNotifier.value = null;
                    _password2HelperNotifier.value = '비밀번호가 일치합니다';
                  },
                ),
                SizedBox(height: 20),
                MyInputForm(
                  title: Text('비밀번호 확인'),
                  textInputType: TextInputType.visiblePassword,
                  errorText: _password2ErrorNotifier.value,
                  helperText: _password2HelperNotifier.value,
                  obscureText: true,
                  onChanged: (password2) {
                    _password2Notifier.value = password2;

                    if(password2 == '') {
                      _password2ErrorNotifier.value = '비밀번호를 재입력해주세요';
                      return;
                    }

                    _password2ErrorNotifier.value = null;

                    if(_passwordNotifier.value == '') return;

                    if(password2 != _passwordNotifier.value) {
                      _password2ErrorNotifier.value = '비밀번호가 일치하지 않습니다';
                      return;
                    }

                    _password2ErrorNotifier.value = null;
                    _password2HelperNotifier.value = '비밀번호가 일치합니다';
                  },
                ),
                SizedBox(height: 20),
                _registerNumberSection(),
                SizedBox(height: 20),
                SizedBox(
                  child: BlocListener(
                    bloc: _signInCubit,
                    listener: (context, state) async {
                      print('state: $state');

                      if(state is SignInSuccessState) {
                        // todo: 자동 로그인

                        await showAlertDialog(
                          context: context,
                          title: state.message,
                        );

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(succeedLogIn: false),
                          ),
                              (route) => false,
                        );
                      }

                      if(state is SignInErrorState) {
                        showAlertDialog(
                            context: context,
                            title: state.message,
                        );
                      }
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      onPressed: !_satisfied(
                        _nicknameCertificatedNotifier.value,
                        _emailErrorNotifier.value != ''
                            && _emailErrorNotifier.value != '',
                        _passwordNotifier.value != ''
                            && _password2Notifier.value != ''
                            && _password2ErrorNotifier.value == null,
                        true,
                        _managerCertificatedNotifier.value,
                      )
                          ? null
                          : () async => await _signInCubit.signIn(
                        _nicknameNotifier.value,
                        _emailNotifier.value,
                        _passwordNotifier.value,
                        '1996-08-23',
                        managerFlag,
                      ),
                      child: Text('가입하기'),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width*0.9 ,
                  height:45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerNumberSection() {
    return managerFlag == 1
        ? SizedBox(height: 1)
        : MyInputForm(
      title: Text('사업자 등록 번호'),
      additionalButton: ElevatedButton(
        onPressed: () {},
        child: Text('인증'),
      ),
    );
  }

  bool _satisfied(
      bool nicknameCertificated,
      bool emailCertificated,
      bool passwordCertificated,
      bool birthDataCertificated,
      bool? managerCertificated,
      ) {
    if (managerFlag == 1) {
      return nicknameCertificated && emailCertificated
          && passwordCertificated && birthDataCertificated;
    }

    if(managerFlag == 2) {
      return nicknameCertificated && emailCertificated
          && passwordCertificated && birthDataCertificated
          && managerCertificated!;
    }

    return false;
  }

// bool get _emailCertificated {
//   return ;
// }
//
// bool get _passwordCertificated {
//   return ;
// }
//
// bool get _birthDataCertificated {
//   return ;
// }
//
// bool get _managerCertificated {
//   return ;
// }
}