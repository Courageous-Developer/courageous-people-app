import 'package:bloc/bloc.dart';
import 'package:courageous_people/log_in/cubit/log_in_repository.dart';
import 'package:courageous_people/log_in/cubit/log_in_state.dart';

import '';

class LogInCubit extends Cubit<LogInState> {
  final LogInRepository repository;

  LogInCubit(this.repository) : super(LogInInitialState());
}