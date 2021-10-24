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
      int manageFlag,
      ) async {
    emit(SignInLoadingState());
    final resultCode = await _repository.signIn(
      nickname, email, password, birthDate, manageFlag,
    );

    if(resultCode == 201) {
      emit(SignInSuccessState('회원가입을 완료했습니다'));
      return;
    }

    if(resultCode == 400) {
      emit(SignInErrorState('이미 사용중인 이메일입니다'));
      return;
    }

    emit(SignInErrorState('잘못된 접근입니다'));
  }

  Future<void> checkNicknameDuplicated(String nickname) async {
    emit(NicknameCheckingState());
    final resultCode = await _repository.checkNicknameDuplicated(nickname);

    if(resultCode == 200) {
      emit(NicknameCheckedState('사용 가능한 닉네임입니다'));
      return;
    }

    if(resultCode == 400) {
      emit(NicknameCheckErrorState('닉네임이 중복되었습니다'));
      return;
    }

    emit(NicknameCheckErrorState('중복 조회에 실패했습니다'));
  }

  Future<void> checkRegisterNumber(String registerNumber) async {
    emit(RegisterNumberCheckingState());
    final resultCode = await _repository.checkRegisterNumber(registerNumber);

    if(resultCode == 200) {
      emit(RegisterNumberCheckedState('인증이 완료되었습니다'));
      return;
    }

    if(resultCode == 400) {
      emit(RegisterNumberCheckErrorState('올바르지 않은 등록 번호입니다'));
      return;
    }

    emit(RegisterNumberCheckErrorState('인증에 실패했습니다'));
  }
}