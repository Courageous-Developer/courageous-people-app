import 'package:courageous_people/model/store_data.dart';

abstract class StoreState {
  const StoreState();
}

class StoreInitialState extends StoreState {}

class StoreErrorState extends StoreState {
  final String message;

  const StoreErrorState(this.message);
}

class StoreLoadingState extends StoreState {}

class StoreLoadedState extends StoreState {
  final List<Store> storeList;

  const StoreLoadedState(this.storeList);
}