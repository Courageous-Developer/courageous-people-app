abstract class LogOutState {
  const LogOutState();
}

class LogOutInitialState extends LogOutState {}

class LogOutErrorState extends LogOutState {
  final String message;

  const LogOutErrorState(this.message);
}

class LogOutLoadingState extends LogOutState {}

class LogOutLoadedState extends LogOutState {

  const LogOutLoadedState();
}