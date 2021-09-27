import 'tag_data.dart';

class Review {
  final int reviewId;
  final int storeId;
  final String userNickname;
  final String comment;
  final String createAt;  // todo: 자로횽 DateTime으로 수정 (정확히 모룸)
  final List<String> imageUri;
  final List<Tag> tags;

  const Review(
      this.reviewId,
      this.storeId,
      this.userNickname,
      this.comment,
      this.createAt,
      this.imageUri,
      this.tags,
      );
}