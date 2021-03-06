import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/sign_in/screen/sign_in_success_screen.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:courageous_people/widget/my_drop_down.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:email_validator/email_validator.dart';

import '../../sign_in/cubit/sign_in_state.dart';
import '../../sign_in/cubit/sign_in_cubit.dart';

class SignInScreen extends StatelessWidget {
  final int managerFlag;

  SignInScreen({Key? key, required this.managerFlag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        elevation: 0,
      ),
      body: _Content(managerFlag: managerFlag),
    );
  }
}

class _Content extends HookWidget {
  final int managerFlag;

  _Content({Key? key, required this.managerFlag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signInCubit = context.read<SignInCubit>();

    final nicknameNotifier = useState('닉네임 중복 검사를 해주세요');
    final emailNotifier = useState('이메일을 입력해주세요');
    final passwordNotifier = useState('비밀번호를 입력해주세요');
    final password2Notifier = useState('비밀번호 확인란을 입력해주세요');
    final businessNumberNotifier = useState('사업자 등록 번호를 인증해주세요');

    final nicknameErrorNotifier = useState<String?>('닉네임 중복 검사를 해주세요');
    final emailErrorNotifier = useState<String?>('이메일을 입력해주세요');
    final passwordErrorNotifier = useState<String?>('비밀번호를 입력해주세요');
    final password2ErrorNotifier = useState<String?>('비밀번호 확인란을 입력해주세요');
    final businessNumberErrorNotifier = useState<String?>('사업자 등록 번호를 인증해주세요');

    final nicknameHelperNotifier = useState<String?>(null);
    final password2HelperNotifier = useState<String?>(null);
    final businessNumberHelperNotifier = useState<String?>(null);

    final yearNotifier = useState<String?>(null);
    final monthNotifier = useState<String?>(null);
    final dayNotifier = useState<String?>(null);

    return GestureDetector(
      onTap:() => FocusScope.of(context).unfocus(),
      child: BlocListener<SignInCubit, SignInState>(
        bloc: signInCubit,
        listener: (context, state) async {
          if(state is NicknameCheckedState) {
            showAlertDialog(
              context: context,
              title: state.message,
            );

            nicknameErrorNotifier.value = null;
            nicknameHelperNotifier.value = '사용 가능한 닉네임입니다';
          }

          if(state is NicknameCheckErrorState) {
            showAlertDialog(
              context: context,
              title: '이미 사용중인 닉네임입니다',
            );

            nicknameHelperNotifier.value = null;
            nicknameErrorNotifier.value = '이미 사용중인 닉네임입니다';
          }

          if(state is SignInSuccessState) {
            await showAlertDialog(
              context: context,
              title: state.message,
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => SignInSuccessScreen(
                  email: emailNotifier.value,
                ),
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

          if(state is BusinessNumberCheckedState) {
            businessNumberHelperNotifier.value = '인증되었습니다';

            showAlertDialog(
              context: context,
              title: state.message,
            );
          }

          if(state is BusinessNumberCheckErrorState) {
            showAlertDialog(
              context: context,
              title: state.message,
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nicknameSection(
                  // errorText: nicknameErrorNotifier.value,
                  errorText: null,
                  // helperText: nicknameHelperNotifier.value,
                  helperText: null,
                  checkNicknameDuplicated: () async {
                    if(nicknameNotifier.value == '') {
                      await showAlertDialog(
                        context: context,
                        title: '닉네임을 입력해주세요',
                      );

                      return;
                    }

                    await signInCubit.checkNicknameDuplicated(
                      nicknameNotifier.value,
                    );
                  },
                  onChanged: (nickname) {
                    nicknameHelperNotifier.value = null;
                    nicknameNotifier.value = nickname;
                    nicknameErrorNotifier.value = _nicknameErrorString(nickname);
                  },
                ),
                SizedBox(height: 40),
                _emailSection(
                  // errorText: emailErrorNotifier.value,
                  errorText: null,
                  onChanged:  (email) {
                    emailNotifier.value = email;
                    emailErrorNotifier.value = _emailErrorString(email);
                  },
                ),
                SizedBox(height: 40),
                _birthDateInputSection(
                  onYearChanged: (year) => yearNotifier.value = year,
                  onMonthChanged: (month) => monthNotifier.value = month,
                  onDayChanged: (day) => dayNotifier.value = day,
                  year: yearNotifier.value,
                  month: monthNotifier.value,
                ),
                SizedBox(height: 40),
                _passwordSection(
                  // errorText: passwordErrorNotifier.value,
                  errorText: null,
                  onChanged: (password) {
                    passwordNotifier.value = password;
                    passwordErrorNotifier.value = _passwordErrorString(password);

                    if(password2Notifier.value == '') return;
                    password2ErrorNotifier.value = _password2ErrorString(
                      passwordNotifier.value,
                      password2Notifier.value,
                    );

                    if(password2ErrorNotifier.value == null) {
                      password2HelperNotifier.value = '비밀번호가 일치합니다';
                    }
                  },
                ),
                SizedBox(height: 40),
                _passwordCertificateSection(
                  // errorText: password2ErrorNotifier.value,
                  errorText: null,
                  helperText: null,
                  // helperText: password2HelperNotifier.value,
                  onChanged: (password2) {
                    if(passwordNotifier.value == '')  return;

                    password2Notifier.value = password2;
                    password2ErrorNotifier.value = _password2ErrorString(
                      passwordNotifier.value,
                      password2Notifier.value,
                    );

                    if(password2ErrorNotifier.value == null) {
                      password2HelperNotifier.value = '비밀번호가 일치합니다';
                    }
                  },
                ),
                SizedBox(height: 40),
                _businessNumberSection(
                  // errorText: businessNumberErrorNotifier.value,
                    errorText: null,
                    helperText: businessNumberHelperNotifier.value,
                    checkBusinessNumber: () async {
                      await signInCubit.checkRegisterNumber(
                        businessNumberNotifier.value,
                      );
                    },
                    onChanged: (businessNumber) async {
                      businessNumberHelperNotifier.value = null;
                      businessNumberNotifier.value = businessNumber;
                      businessNumberErrorNotifier.value =
                          _businessNumberErrorString(businessNumber);
                    }
                ),
                SizedBox(height: 20),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    onPressed: () async {
                      if(nicknameHelperNotifier.value == null) {
                        await showAlertDialog(
                          context: context,
                          title: '닉네임 중복 검사를 해주세요',
                        );

                        return;
                      }

                      if(emailErrorNotifier.value != null) {
                        await showAlertDialog(
                          context: context,
                          title: emailErrorNotifier.value!,
                        );

                        return;
                      }

                      if(dayNotifier.value == null) {
                        await showAlertDialog(
                          context: context,
                          title: '생년월일을 입력해주세요',
                        );

                        return;
                      }

                      if(passwordErrorNotifier.value != null) {
                        await showAlertDialog(
                          context: context,
                          title: passwordErrorNotifier.value!,
                        );

                        return;
                      }

                      if(password2ErrorNotifier.value != null) {
                        await showAlertDialog(
                          context: context,
                          title: password2ErrorNotifier.value!,
                        );

                        return;
                      }

                      if(managerFlag == 2 && businessNumberErrorNotifier.value != null) {
                        await showAlertDialog(
                          context: context,
                          title: businessNumberErrorNotifier.value!,
                        );

                        return;
                      }

                      await signInCubit.signIn(
                        nicknameNotifier.value,
                        emailNotifier.value,
                        passwordNotifier.value,
                        '${yearNotifier.value}-${monthNotifier.value}-${dayNotifier.value}',
                        managerFlag,
                      );
                    },
                    // onPressed: !_satisfied(
                    //   nicknameHelperNotifier.value != null,
                    //   emailNotifier.value != ''
                    //       && emailErrorNotifier.value == null,
                    //   passwordNotifier.value != ''
                    //       && password2Notifier.value != ''
                    //       && password2ErrorNotifier.value == null,
                    //   dayNotifier.value != null,
                    //   businessNumberHelperNotifier.value != null,
                    // )
                    //     ? null
                    //     : () async => await signInCubit.signIn(
                    //   nicknameNotifier.value,
                    //   emailNotifier.value,
                    //   passwordNotifier.value,
                    //   '${yearNotifier.value}-${monthNotifier.value}-${dayNotifier.value}',
                    //   managerFlag,
                    // ),
                    child: Text('가입하기'),
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

  Widget _nicknameSection({
    required String? errorText,
    required String? helperText,
    required void Function(String) onChanged,
    required void Function() checkNicknameDuplicated,
  }) {
    return MyInputForm(
      title: Text('닉네임'),
      textInputType: TextInputType.name,
      errorText: errorText,
      helperText: helperText,
      onChanged: onChanged,
      additionalButton: SizedBox(
        height: 30,
        child: ElevatedButton(
          child: Text('중복 확인'),
          onPressed: checkNicknameDuplicated,
        ),
      ),
    );
  }

  Widget _emailSection({
    required String? errorText,
    required void Function(String)? onChanged,
  }) {
    return MyInputForm(
      title: Text('이메일'),
      textInputType: TextInputType.emailAddress,
      errorText: errorText,
      onChanged: onChanged,
    );
  }

  Widget _birthDateInputSection({
    required void Function(String) onYearChanged,
    required void Function(String) onMonthChanged,
    required void Function(String) onDayChanged,
    required String? year,
    required String? month,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('생년월일'),
        SizedBox(height: 5),
        Row(
          children: [
            MyDropDown(
              title: '년',
              width: 100,
              contents: _yearList,
              onSelect: (year) => onYearChanged(year),
            ),
            SizedBox(width: 12),
            MyDropDown(
              title: '월',
              width: 100,
              contents: _monthList(year),
              onSelect: (month) => onMonthChanged(month),
            ),
            SizedBox(width: 12),
            MyDropDown(
              title: '일',
              width: 100,
              contents: _dayList(year, month),
              onSelect: (day) => onDayChanged(day),
            ),
          ],
        ),
      ],
    );
  }

  Widget _passwordSection({
    required String? errorText,
    required void Function(String)? onChanged,
  }) {
    return MyInputForm(
      title: Text('비밀번호'),
      textInputType: TextInputType.visiblePassword,
      obscureText: true,
      errorText: errorText,
      onChanged: onChanged,
    );
  }

  Widget _passwordCertificateSection({
    required String? errorText,
    required String? helperText,
    required void Function(String)? onChanged,
  }) {
    return MyInputForm(
      title: Text('비밀번호 확인'),
      textInputType: TextInputType.visiblePassword,
      obscureText: true,
      errorText: errorText,
      helperText: helperText,
      onChanged: onChanged,
    );
  }

  Widget _businessNumberSection({
    required String? errorText,
    required String? helperText,
    required void Function(String) onChanged,
    required void Function() checkBusinessNumber,
  }) {
    if (managerFlag == 2) {
      return MyInputForm(
        title: Text('사업자 등록 번호 인증'),
        textInputType: TextInputType.phone,
        errorText: errorText,
        helperText: helperText,
        onChanged: onChanged,
        additionalButton: SizedBox(
          height: 30,
          child: ElevatedButton(
            onPressed: checkBusinessNumber,
            child: Text('인증'),
          ),
        ),
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  bool _satisfied(
      bool nicknameCertificated,
      bool emailCertificated,
      bool passwordCertificated,
      bool birthDataCertificated,
      bool managerCertificated,
      ) {
    if (managerFlag == 1) {
      return nicknameCertificated && emailCertificated
          && passwordCertificated && birthDataCertificated;
    }

    if(managerFlag == 2) {
      return nicknameCertificated && emailCertificated
          && passwordCertificated && birthDataCertificated
          && managerCertificated;
    }

    return false;
  }

  String? _nicknameErrorString(String nickname) {
    if(nickname == '') return '닉네임을 입력해주세요';

    return null;
  }

  String? _emailErrorString(String email) {
    if(email == '') return '이메일을 입력해주세요';

    if(!(EmailValidator.validate(email))) return '잘못된 이메일 형식입니다';

    return null;
  }

  String? _passwordErrorString(String password) {
    if(password == '')  return '비밀번호를 입력해주세요';

    return null;
  }

  String? _password2ErrorString(String password, String password2) {
    if(password == '') return null;
    if(password2 == '') return '비밀번호를 재입력해주세요';

    if(password != password2) return '비밀번호가 일치하지 않습니다';

    return null;
  }

  String? _businessNumberErrorString(String businessNumber) {
    if(businessNumber == '') return '사업자 등록 번호를 입력해주세요';

    return null;
  }

  List<String> get _yearList {
    List<String> yearList = [];

    for(int i = 0; i < 100; i++) yearList.add('${DateTime.now().year - i}');

    return yearList;
  }

  List<String> _monthList(String? year) {
    if(year == null) return [];

    List<String> monthList = [];
    for(int month = 1; month <= 12; month++) monthList.add(month.toString());

    return monthList;
  }

  List<String> _dayList(String? year, String? month) {
    if(year == null || month == null) return [];

    final daysInMonth = DateTime(int.parse(year), int.parse(month) + 1, 0);
    List<String> dayList = [];

    for(int day = 1; day <= daysInMonth.day; day++) dayList.add(day.toString());

    return dayList;
  }
}

class _InputForm extends HookWidget {
  const _InputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
