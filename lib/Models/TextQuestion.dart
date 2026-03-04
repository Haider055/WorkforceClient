class TextQuestion {
  int? id;
  String? question;
  String? type;
  int? hasIcon;
  int? isRequired;
  String? description;
  String answer = "";

  TextQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    type = json['type'];
    isRequired = json['is_required'];
    hasIcon = json['has_icon'];
    description = json['description'];
  }
}
