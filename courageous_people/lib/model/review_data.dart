import 'tag_data.dart';

class Review {
  final int storeId;
  final String userNickname;
  final String comment;
  final String createAt;  // todo: 자로횽 DateTime으로 수정 (정확히 모룸)
  final String? imageUri;   // 이미지 String??
  final List<Tags>? tags;

  const Review(
      this.storeId,
      this.userNickname,
      this.comment,
      this.createAt,
      this.imageUri,
      this.tags
      );
}