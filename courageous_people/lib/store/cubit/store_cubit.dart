import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/store/cubit/store_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'store_state.dart';
import '../../common/classes.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository repository;

  StoreCubit(this.repository) : super(StoreInitialState()) {
    emit(StoreInitialState());
  }

  static StoreCubit of(BuildContext context) => context.read<StoreCubit>();

  Future<void> getStores() async {
    emit(StoreLoadingState());
    List<Stores> storeList = await repository.getStores();
    emit(StoreLoadedState(storeList));
  }

  Future<void> addStore(
      String storeName, String address, String post,
      String? imageUrl, double latitude, double longitude, int registrant
      ) async {
    emit(AddingStoreSLoadingState());
    final succeeded = await repository.addStore(
      storeName, address, post, imageUrl, latitude, longitude, registrant,
    );

    succeeded
        ? emit(AddingStoreSuccessState('가게를 등록했습니다'))
        : emit(AddingStoreErrorState('가게 등록에 실패했습니다'));
  }

  void initMap() {
    emit(MapInitializeState());
  }
}