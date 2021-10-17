abstract class MenuState {
  const MenuState();
}

class MenuInitialState extends MenuState {}

class MenuLoadingState extends MenuState {}

class MenuLoadedState extends MenuState {

}

class MenuErrorState extends MenuState {
  final String message;

  const MenuErrorState(this.message);
}

menu interpreter
    