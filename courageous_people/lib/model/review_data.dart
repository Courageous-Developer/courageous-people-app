class Review {
  final String id;
  final double grade;
  final String comment;
  final String? imageUri;   // 이미지 String??
  final String? tags;

  const Review(
      this.id,
      this.grade,
      this.comment,
      this.imageUri,
      this.tags
      );
}