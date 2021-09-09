import 'package:courageous_people/model/user_data.dart';

abstract class SignInState {
  const SignInState();
}

class SignInInitialState extends SignInState {}
class SignInLoadingState extends SignInState {}
class SignInSuccessState extends SignInState {
  final User user;

  const SignInSuccessState(this.user);
}
class SignInErrorState extends SignInState {
  final String message;

  const SignInErrorState(this.message);
}