class JobPostTextQuestion {
  int? id;
  String? question;
  String? questionDesc;
  String? answer;

  JobPostTextQuestion({
    this.id,
    this.question,
    this.questionDesc,
    this.answer,
  });

  JobPostTextQuestion.fromJson(Map<String, dynamic> json);
}
