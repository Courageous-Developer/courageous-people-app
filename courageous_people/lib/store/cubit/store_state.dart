import 'package:courageous_people/model/store_data.dart';

abstract class StoreState {
  const StoreState();
}

class StoreInitialState extends StoreState {}

class MapInitializeState extends StoreState {}

// 가게 추가

class AddingStoreSLoadingState extends StoreState {}

class AddingStoreSuccessState extends StoreState {
  final String message;

  const AddingStoreSuccessState(this.message);
}

class AddingStoreErrorState extends StoreState {
  final String message;

  const AddingStoreErrorState(this.message);
}

// 가게 불러오기

class StoreErrorState extends StoreState {
  final String message;

  const StoreErrorState(this.message);
}

class StoreLoadingState extends StoreState {}

class StoreLoadedState extends StoreState {
  final List<StoreData> storeList;

  const StoreLoadedState(this.storeList);
}

class StoreCrawlingState extends StoreState {}

class StoreCrawlSuccessState extends StoreState {
  // final List<Map<String, dynamic>> result;
  final List<dynamic> result;

  const StoreCrawlSuccessState(this.result);
}

class StoreCrawlErrorState extends StoreState {
  final String message;

  const StoreCrawlErrorState(this.message);
}

class StoreDuplicatedCheckingState extends StoreState {}

class StoreDuplicatedCheckedState extends StoreState {
  final StoreData? store;

  const StoreDuplicatedCheckedState(this.store);
}