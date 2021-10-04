import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'log_out_repository.dart';
import 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  final LogOutRepository repository;

  static LogOutCubit of(BuildContext context) => context.read<LogOutCubit>();

  LogOutCubit(this.repository) : super(LogOutInitialState());

  Future<void> logOut() async {
    emit(LogOutLoadingState());
    await repository.logOut();
    emit(LogOutSuccessState());
  }
}