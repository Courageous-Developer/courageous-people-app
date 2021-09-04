import 'package:bloc/bloc.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_repository.dart';
import 'package:courageous_people/sign_in/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState>{
  final SignInRepository repository;

  SignInCubit(this.repository) : super(SignInInitialState());

  Future<void> signIn() async {

  }
}