import 'package:courageous_people/model/user_data.dart';

abstract class SignInState {
  const SignInState();
}

class SignInInitialState extends SignInState {}
class SignInLoadingState extends SignInState {}
class SignInSuccessState extends SignInState {
  final String message;

  const SignInSuccessState(this.message);
}
class SignInErrorState extends SignInState {
  final String message;

  const SignInErrorState(this.message);
}

class NicknameCheckingState extends SignInState {}

class NicknameCheckedState extends SignInState {
  final String message;

  const NicknameCheckedState(this.message);
}

class NicknameCheckErrorState extends SignInState {
  final String message;

  const NicknameCheckErrorState(this.message);
}

class BusinessNumberCheckingState extends SignInState {}

class BusinessNumberCheckedState extends SignInState {
  final String message;

  const BusinessNumberCheckedState(this.message);
}

class BusinessNumberCheckErrorState extends SignInState {
  final String message;

  const BusinessNumberCheckErrorState(this.message);
}