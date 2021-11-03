import 'dart:typed_data';

import 'package:bloc/bloc.dart';

import '../repository/review_repository.dart';
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
    required String menu,
    required String container,
    required String comment,
    Uint8List? pictureToByte,
  }) async {
    try {
      emit(AddingReviewLoadingState());
      final statusCode = await repository.addReview(
        storeId: storeId,
        userId: userId,
        comment: comment,
        menu: menu,
        container: container,
        pictureToByte: pictureToByte,
      );

      if (statusCode == 200 || statusCode == 201) {
        print(statusCode);
        emit(AddingReviewSuccessState('리뷰를 등록했습니다'));
        return;
      }

      emit(AddingReviewErrorState('리뷰 등록에 실패했습니다'));
    } on Exception catch (exception) {
      emit(AddingReviewErrorState(exception.toString()));
    }
  }


  Future<void> rewriteReview({
    required int reviewId,
    required int storeId,
    required int userId,
    required String comment,
  }) async {
    try {
      emit(RewriteReviewLoadingState());
      final statusCode = await repository.rewriteReview(
        reviewId: reviewId,
        storeId: storeId,
        userId: userId,
        comment: comment
      );

      if (statusCode == 201) {
        emit(ReviewRewrittenState('수정이 완료되었습니다'));
        return;
      }

      emit(ReviewRewriteErrorState('수정에 실패했습니다'));
    } on Exception catch (_) {
      emit(ReviewRewriteErrorState('수정에 실패했습니다'));
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
      emit(DeleteReviewLoadingState());
      final reviewDeleteResponse = await repository.deleteReview(reviewId);

      print(reviewDeleteResponse);
      if(reviewDeleteResponse == 204) {
        emit(ReviewDeletedState('리뷰를 삭제했습니다'));
        return;
      }

      emit(ReviewDeleteErrorState('리뷰 삭제에 실패했습니다'));
    } on Exception catch (_) {
      emit(ReviewDeleteErrorState('리뷰 삭제에 실패했습니다'));
    }
  }
}