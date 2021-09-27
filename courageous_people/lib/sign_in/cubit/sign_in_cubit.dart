import 'package:bloc/bloc.dart';
import 'package:courageous_people/model/user_data.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_repository.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState>{
  final SignInRepository _repository;

  SignInCubit(this._repository) : super(SignInInitialState());

  Future<void> signIn(
      String nickname,
      String email,
      String password,
      String birthDate,
      int manageFlag
      ) async {
    emit(SignInLoadingState());
    final message = await _repository.signIn(
      nickname, email, password, birthDate, manageFlag,
    );

    message == null
        ? emit(SignInSuccessState('회원가입을 완료했습니다'))
        : emit(SignInErrorState(message));
  }
}