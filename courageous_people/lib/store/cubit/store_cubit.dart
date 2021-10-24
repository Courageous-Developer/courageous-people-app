import 'dart:typed_data';

import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/store/repository/store_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository repository;

  StoreCubit(this.repository) : super(StoreInitialState()) {
    emit(StoreInitialState());
  }

  static StoreCubit of(BuildContext context) => context.read<StoreCubit>();

  Future<void> getStores() async {
    emit(StoreLoadingState());
    List<StoreData> storeList = await repository.getStores();
    emit(StoreLoadedState(storeList));
  }

  Future<void> addStore(
      String storeName, String address, String post,
      Uint8List? imageToByte, double latitude, double longitude,
      int registrant, int managerFlag, List<Map<String, dynamic>> menuList,
      ) async {
    emit(AddingStoreSLoadingState());
    final resultCode = await repository.addStore(
      storeName, address, post, imageToByte,
      latitude, longitude, registrant, managerFlag, menuList,
    );

    resultCode == 200 || resultCode == 201
        ? emit(AddingStoreSuccessState('가게를 등록했습니다'))
        : emit(AddingStoreErrorState('가게 등록에 실패했습니다'));
  }

  Future<void> crawlStore(String location, String storeName) async {
    try {
      emit(StoreCrawlingState());
      final result = await repository.crawlStore(location, storeName);
      emit(StoreCrawlSuccessState(result));
    } on Exception catch (e) {
      emit(StoreCrawlErrorState('오류가 발생했습니다'));
    }
  }
}