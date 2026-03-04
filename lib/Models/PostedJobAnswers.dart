class PostedJobAnswers {
  int? id;
  int? anwserOptionId;
  String? type;
  String? answer;
  String? question;
  String? description;
  int? questionId;

  PostedJobAnswers({
    this.id,
    this.anwserOptionId,
    this.type,
    this.answer,
    this.question,
    this.description,
    this.questionId,
  });

  factory PostedJobAnswers.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> questionObj = json['question'];
    return PostedJobAnswers(
      id: json['id'],
      anwserOptionId: json['anwser_option_id'],
      type: json['type'],
      answer: json['answer'],
      question: questionObj['question'],
      description: questionObj['description'],
      questionId: questionObj['id'],
    );
  }
}
