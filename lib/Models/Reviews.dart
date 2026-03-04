class Reviews {
  int? id;
  int? userId;
  String? userName;
  String? userCountry;
  String? userCity;
  int? jobPostingId;
  int? rating;
  String? comment;
  String? createdAt;
  String? humanReadableCreatedAt;
  int? revieweeId;
  String? title;

  Reviews({
    this.id,
    this.userId,
    this.userName,
    this.userCountry,
    this.userCity,
    this.jobPostingId,
    this.rating,
    this.comment,
    this.createdAt,
    this.humanReadableCreatedAt,
    this.revieweeId,
    this.title,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user'] == null ? "" : json['user']['name'],
      userCountry: json['job_posting']['country'],
      userCity: json['job_posting']['city'],
      jobPostingId: json['job_posting_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
      humanReadableCreatedAt: json['human_readable_created_at'],
      revieweeId: json['reviewee_id'],
      title: json['job_posting']['title'],
    );
  }
}
