import 'package:courageous_people/model/review_data.dart';

abstract class ReviewState {
  const ReviewState();
}

class ReviewInitialState extends ReviewState {}

// class ReviewReadyState extends ReviewState {}

class ReviewErrorState extends ReviewState {
  final String message;

  const ReviewErrorState(this.message);
}

// 리뷰 등록

class AddingReviewLoadingState extends ReviewState {}

class AddingReviewSuccessState extends ReviewState {
  final String message;

  const AddingReviewSuccessState(this.message);
}

class AddingReviewErrorState extends ReviewState {
  final String message;

  const AddingReviewErrorState(this.message);
}

// 리뷰 불러오기

class ReviewLoadingState extends ReviewState {}

class ReviewLoadedState extends ReviewState {
  final List<Review> reviewList;

  const ReviewLoadedState(this.reviewList);
}