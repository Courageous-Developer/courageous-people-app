import 'package:bloc/bloc.dart';
import 'package:courageous_people/log_in/cubit/log_in_repository.dart';
import 'package:courageous_people/log_in/cubit/log_in_state.dart';
import 'package:flutter/cupertino.dart';

import '';

class LogInCubit extends Cubit<LogInState> {
  final LogInRepository repository;

  LogInCubit(this.repository) : super(LogInInitialState());

  Future<void> logIn(BuildContext context, String id, String password) async {
    emit(LogInLoadingState());
    final result = await repository.logIn(context, id, password);

    result == null
      ? emit(LogInFailedState())
      : emit(LogInSuccessState(result));
  }
}