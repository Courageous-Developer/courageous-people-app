import 'package:bloc/bloc.dart';
import 'package:courageous_people/log_in/cubit/log_in_repository.dart';
import 'package:courageous_people/log_in/cubit/log_in_state.dart';
import 'package:flutter/cupertino.dart';

import '';

class LogInCubit extends Cubit<LogInState> {
  final LogInRepository repository;

  LogInCubit(this.repository) : super(LogInInitialState());

  Future<void> logIn(BuildContext context, String email, String password) async {
    emit(LogInLoadingState());
    final result = await repository.logIn(context, email, password);

    result
        ? emit(LogInSuccessState(result))
        : emit(LogInFailedState());
  }
}