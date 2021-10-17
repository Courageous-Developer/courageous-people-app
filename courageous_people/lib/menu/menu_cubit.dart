import 'package:bloc/bloc.dart';
import 'package:courageous_people/menu/menu_repository.dart';
import 'package:courageous_people/menu/menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository repository;

  MenuCubit(this.repository) : super(MenuInitialState());

  Future<void> getMenu(int storeId) async {
    emit(MenuLoadingState());
    final menuList = await repository.getMenu(storeId);
    emit(MenuLoadedState(menuList));
  }
}