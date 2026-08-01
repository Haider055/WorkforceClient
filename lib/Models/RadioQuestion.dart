import 'package:workforceclientapp/Models/QuestionOption.dart';

class RadioQuestion {
  int? id;
  String? question;
  String? type;
  int? hasIcon;
  String? description;
  int? isRequired;
  List<QuestionOption>? options;
  String? selectedOption = "";
  int? selectedOptionId = 0;

  RadioQuestion(
      {required this.id,
      required this.question,
      required this.type,
      required this.hasIcon,
      required this.isRequired,
      required this.description,
      required this.options});

  factory RadioQuestion.fromJson(
      Map<String, dynamic> json, List<QuestionOption>? options) {
    return RadioQuestion(
        id: json['id'],
        question: json['question'],
        type: json['type'],
        isRequired: json['is_required'],
        hasIcon: json['has_icon'],
        description: json['description'],
        options: options);
  }
}
