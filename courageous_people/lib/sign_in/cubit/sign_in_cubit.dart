import 'package:bloc/bloc.dart';
import 'package:courageous_people/model/user_data.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_repository.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState>{
  final SignInRepository repository;

  SignInCubit(this.repository) : super(SignInInitialState());

  Future<void> signIn(
      String nickname,
      String email,
      String password,
      String birthDate,
      int manageFlag
      ) async {
    emit(SignInLoadingState());
    final user = await repository.signIn(
      nickname, email, password, birthDate, manageFlag,
    );
    emit(SignInSuccessState(user));
  }
}