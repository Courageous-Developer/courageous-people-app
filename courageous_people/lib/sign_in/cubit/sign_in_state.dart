abstract class SignInState {
  const SignInState();
}

class SignInInitialState extends SignInState {}
class SignInLoadingState extends SignInState {}
class SignInLoadedState extends SignInState {

}
class SignInErrorState extends SignInState {
  final String message;

  const SignInErrorState(this.message);
}