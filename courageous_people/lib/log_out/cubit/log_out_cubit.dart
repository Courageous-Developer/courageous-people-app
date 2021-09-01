import 'package:bloc/bloc.dart';
import 'package:courageous_people/log_in/cubit/log_in_repository.dart';
import 'package:courageous_people/log_in/cubit/log_in_state.dart';

import 'log_out_repository.dart';
import 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  final LogOutRepository repository;

  LogOutCubit(this.repository) : super(LogOutInitialState());
}