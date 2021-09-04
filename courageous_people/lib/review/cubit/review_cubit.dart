import 'package:bloc/bloc.dart';
import 'package:courageous_people/log_in/cubit/log_in_repository.dart';
import 'package:courageous_people/log_in/cubit/log_in_state.dart';

import '';
import 'review_repository.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository repository;

  ReviewCubit(this.repository) : super(ReviewInitialState());

  Future<void> getReviews(int storeId) async {
    emit(ReviewLoadingState());
    final reviewList = await repository.getReviews(storeId);
    emit(ReviewLoadedState(reviewList));
  }

  void init() {
    emit(ReviewInitialState());
  }
}