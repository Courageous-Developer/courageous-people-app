import '../../model/user_data.dart';

abstract class LogInState {
  const LogInState();
}

class LogInInitialState extends LogInState {}

class LogInErrorState extends LogInState {
  final String message;

  const LogInErrorState(this.message);
}

class LogInLoadingState extends LogInState {}

class LogInSuccessState extends LogInState {
  final User user;

  const LogInSuccessState(this.user);
}

class LogInFailedState extends LogInState {}