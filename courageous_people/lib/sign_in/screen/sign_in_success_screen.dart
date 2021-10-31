import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/log_in/log_In_screen.dart';
import 'package:flutter/material.dart';

import '../../log_in/log_In_screen.dart';

class SignInSuccessScreen extends StatelessWidget {
  const SignInSuccessScreen({Key? key, required this.email}) : super(key: key);

  final String email;

  final String _mainText = '회원가입이 완료되었습니다!\n';
  final String _subText1 = '로\n 계정 활설화 링크 메일을 발송하였습니다\n';
  final String _subText2 = '계정을 활성화하고 앱을 시작해보세요!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: SizedBox(height: 0)),
            Text(
              _mainText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            Text.rich(
              TextSpan(
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(text: '가입하신 이메일 '),
                  TextSpan(
                    text: '$email ',
                    style: TextStyle(
                      color: Colors.green.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: '$_subText1'),
                  TextSpan(text: '$_subText2'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(child: SizedBox(height: 0)),
            _bottomButton(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LogInScreen()),
                    (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton({
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        height: kToolbarHeight,
        color: THEME_COLOR,
        alignment: Alignment.center,
        child: Text(
          '로그인하러 가기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
