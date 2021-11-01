import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/log_out_repository.dart';
import 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  final LogOutRepository repository;

  static LogOutCubit of(BuildContext context) => context.read<LogOutCubit>();

  LogOutCubit(this.repository) : super(LogOutInitialState());

  Future<void> logOut() async {
    try {
      emit(LogOutLoadingState());
      final logOutStatusCode = await repository.logOut();

      if(logOutStatusCode == 205) {
        emit(LogOutSuccessState());
        return;
      }

      emit(LogOutErrorState('로그아웃에 실패했습니다'));
    } on Exception catch(exception) {
      emit(LogOutErrorState(exception.toString()));
    }
  }
}