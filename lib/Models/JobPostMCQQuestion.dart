class JobPostMCQQuestion {
  int? id;
  String? question;
  List<String>? choices;

  JobPostMCQQuestion({
    this.id,
    this.question,
    this.choices,
  });

  JobPostMCQQuestion.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // question = json['name'];
    // choices = json['father_name'];
  }
}
