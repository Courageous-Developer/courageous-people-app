import 'package:bloc/bloc.dart';
import 'package:courageous_people/sign_in/repository/sign_in_repository.dart';
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
    try {
      emit(SignInLoadingState());
      final resultCode = await _repository.signIn(
        nickname,
        email,
        password,
        birthDate,
        manageFlag,
      );

      if (resultCode == 201) {
        emit(SignInSuccessState('회원가입을 완료했습니다'));
        return;
      }

      if (resultCode == 400) {
        emit(SignInErrorState('이미 사용중인 이메일입니다'));
        return;
      }

      emit(SignInErrorState('회원가입에 실패했습니다'));
    } on Exception catch (_) {
      emit(SignInErrorState('회원가입에 실패했습니다'));
    }
  }

  Future<void> checkNicknameDuplicated(String nickname) async {
    try {
      emit(NicknameCheckingState());
      final resultCode = await _repository.checkNicknameDuplicated(nickname);

      if (resultCode == 200) {
        emit(NicknameCheckedState('사용 가능한 닉네임입니다'));
        return;
      }

      if (resultCode == 400) {
        emit(NicknameCheckErrorState('닉네임이 중복되었습니다'));
        return;
      }

      emit(NicknameCheckErrorState('중복 조회에 실패했습니다'));
    } on Exception catch (_) {
      emit(NicknameCheckErrorState('중복 조회에 실패했습니다'));
    }
  }

  Future<void> checkRegisterNumber(String businessNumber) async {
    try {
      emit(BusinessNumberCheckingState());
      final resultCode = await _repository.checkRegisterNumber(businessNumber);

      if (resultCode == 200) {
        emit(BusinessNumberCheckedState('인증이 완료되었습니다'));
        return;
      }

      if (resultCode == 400) {
        emit(BusinessNumberCheckErrorState('올바르지 않은 사업자 등록 번호입니다'));
        return;
      }

      emit(BusinessNumberCheckErrorState('인증에 실패했습니다'));
    } on Exception catch (_) {
      emit(BusinessNumberCheckErrorState('인증에 실패했습니다'));
    }
  }
}