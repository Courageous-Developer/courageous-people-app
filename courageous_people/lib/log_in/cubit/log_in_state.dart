import '../../model/user_data.dart';
import '../../model/token.dart';

abstract class LogInState {
  const LogInState();
}

class LogInInitialState extends LogInState {}

class LogInErrorState extends LogInState {
  final String message;

  const LogInErrorState(this.message);
}

class LogInLoadingState extends LogInState {}

class LogInSuccessState extends LogInState {}

class LogInFailedState extends LogInState {
  final String message;

  const LogInFailedState(this.message);
}