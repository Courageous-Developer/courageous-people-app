import 'tag_data.dart';

class ReviewData {
  final int reviewId;
  final int storeId;
  final String userNickname;
  final String comment;
  final String createAt;
  final List<String> imageUri;
  final List<TagData> tags;

  const ReviewData(
      this.reviewId,
      this.storeId,
      this.userNickname,
      this.comment,
      this.createAt,
      this.imageUri,
      this.tags,
      );
}