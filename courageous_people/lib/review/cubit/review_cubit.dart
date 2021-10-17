import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:courageous_people/log_in/cubit/log_in_repository.dart';
import 'package:courageous_people/log_in/cubit/log_in_state.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> addReview({
    required int storeId,
    required int userId,
    required String comment,
    Uint8List? pictureToByte,
  }) async {
    emit(AddingReviewLoadingState());
    final statusCode = await repository.addReview(
      storeId: storeId,
      userId: userId,
      comment: comment,
      pictureToByte: pictureToByte,
    );

    if(statusCode == 200 || statusCode == 201) {
      emit(AddingReviewSuccessState('리뷰를 등록했습니다'));
      return;
    }

    emit(AddingReviewErrorState('리뷰 등록에 실패했습니다'));
  }
}