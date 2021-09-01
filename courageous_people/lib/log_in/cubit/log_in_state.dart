abstract class LogInState {
  const LogInState();
}

class LogInInitialState extends LogInState {}

class LogInErrorState extends LogInState {
  final String message;

  const LogInErrorState(this.message);
}

class LogInLoadingState extends LogInState {}

class LogInLoadedState extends LogInState {
  final String accessToken;
  final String refreshToken;

  const LogInLoadedState(this.accessToken, this.refreshToken);
}