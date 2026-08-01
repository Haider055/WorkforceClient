import 'package:workforceclientapp/Models/QuestionOption.dart';

class CheckBoxQuestion {
  int? id;
  String? question;
  String? type;
  int? hasIcon;
  int? isRequired;
  String? description;
  List<QuestionOption>? options;
  List<String> selectedOptions = [];
  List<int> selectedOptionsIds = [];

  CheckBoxQuestion(
      {required this.id,
      required this.question,
      required this.type,
      required this.hasIcon,
      required this.isRequired,
      required this.description,
      required this.options});

  factory CheckBoxQuestion.fromJson(
      Map<String, dynamic> json, List<QuestionOption>? checkBoxoptions) {
    return CheckBoxQuestion(
        id: json['id'],
        question: json['question'],
        type: json['type'],
        hasIcon: json['has_icon'],
        isRequired: json['is_required'],
        description: json['description'],
        options: checkBoxoptions);
  }
}
