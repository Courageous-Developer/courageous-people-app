import 'package:bloc/bloc.dart';
import 'package:courageous_people/log_in/repository/log_in_repository.dart';
import 'package:courageous_people/log_in/cubit/log_in_state.dart';
import 'package:flutter/material.dart';

import '';

class LogInCubit extends Cubit<LogInState> {
  final LogInRepository repository;

  LogInCubit(this.repository) : super(LogInInitialState());

  Future<void> logIn(BuildContext context, String email, String password) async {
    try {
      emit(LogInLoadingState());
      final resultCode = await repository.logIn(context, email, password);
      print(resultCode);

      if(resultCode == 200) {
        emit(LogInSuccessState());
        return;
      }

      if(resultCode == 401) {
        emit(LogInFailedState('비밀번호가 틀렸거나\n 이메일 인증을 하지 않은 계정입니다'));
        return;
      }

    } on Exception catch(exception) {
      emit(LogInErrorState(exception.toString()));
    }
  }
}