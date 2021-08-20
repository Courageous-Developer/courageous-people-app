import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(StoreInitialState());


}