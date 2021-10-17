import 'package:courageous_people/model/menu_data.dart';

abstract class MenuState {
  const MenuState();
}

class MenuInitialState extends MenuState {}

class MenuLoadingState extends MenuState {}

class MenuLoadedState extends MenuState {
  final List<MenuData> menuList;

  const MenuLoadedState(this.menuList);
}

class MenuErrorState extends MenuState {
  final String message;

  const MenuErrorState(this.message);
}
