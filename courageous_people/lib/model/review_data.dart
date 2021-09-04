class Review {
  final int storeId;
  final int userId;
  final double grade;
  final String comment;
  final String createAt;  // todo: 자로횽 DateTime으로 수정 (정확히 모룸)
  final String? imageUri;   // 이미지 String??
  final String? tags;

  const Review(
      this.storeId,
      this.userId,
      this.grade,
      this.comment,
      this.createAt,
      this.imageUri,
      this.tags
      );
}