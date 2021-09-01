import 'package:courageous_people/model/review_data.dart';

abstract class ReviewState {
  const ReviewState();
}

class ReviewInitialState extends ReviewState {}

class ReviewErrorState extends ReviewState {
  final String message;

  const ReviewErrorState(this.message);
}

class ReviewLoadingState extends ReviewState {}

class ReviewLoadedState extends ReviewState {
  final List<Review> reviewList;

  const ReviewLoadedState(this.reviewList);
}