import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/store/cubit/store_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'store_state.dart';
import '../../classes.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository repository;

  StoreCubit(this.repository) : super(StoreLoadingState());

  static StoreCubit of(BuildContext context) => context.read<StoreCubit>();

  Future<void> getStores() async {
    emit(StoreLoadingState());
    List<Store> storeList = await repository.getStores();
    emit(StoreLoadedState(storeList));
  }

  void init() {
    emit(StoreInitialState());
  }
}