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

  const ReviewLoadedState();
}