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
    try {
      emit(StoreLoadingState());
      List<StoreData> storeList = await repository.getStores();
      emit(StoreLoadedState(storeList));
    } on Exception catch (_) {
      emit(StoreErrorState('가게 불러오기에 실패했습니다\n앱을 재시작해주세요'));
    }
  }

  Future<void> addStore(
      String storeName, String address, String post,
      Uint8List? imageToByte, double latitude, double longitude,
      int registrant, int managerFlag, List<Map<String, dynamic>> menuList,
      ) async {
    try {
      emit(AddingStoreSLoadingState());
      final resultCode = await repository.addStore(
        storeName,
        address,
        post,
        imageToByte,
        latitude,
        longitude,
        registrant,
        managerFlag,
        menuList,
      );

      resultCode == 201
          ? emit(AddingStoreSuccessState('가게가 등록 되었습니다'))
          : emit(AddingStoreErrorState('가게 등록에 실패했습니다'));
    } on Exception catch (exception) {
      emit(AddingStoreErrorState(exception.toString()));
    }
  }

  Future<void> crawlStore(String location, String storeName) async {
    try {
      emit(StoreCrawlingState());
      final result = await repository.crawlStore(location, storeName);

      final crawledList = result['crawled'] as List<dynamic>;
      final duplicatedList = result['duplicated'] as List<StoreData?>;

      emit(StoreCrawlSuccessState(crawledList, duplicatedList));
    } on Exception catch (_) {
      emit(StoreCrawlErrorState('가게 검색에 실패했습니다'));
    }
  }
}