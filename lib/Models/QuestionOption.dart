import 'package:workforceclientapp/Models/CheckBoxQuestion.dart';
import 'package:workforceclientapp/Models/RadioQuestion.dart';
import 'package:workforceclientapp/Models/TextQuestion.dart';

class QuestionOption {
  int? id;
  String? optionText;
  String? icon;
  List<Map<String, dynamic>> questionsList;
  bool selected;

  QuestionOption({
    required this.id,
    required this.optionText,
    required this.icon,
    this.questionsList = const [], // Default empty list
    this.selected = false, // Default false
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> parsedQuestionsList = [];

    if (json.containsKey('child_questions')) {
      List<dynamic> questionsArray = json['child_questions'] ?? [];
      for (var question in questionsArray) {
        List<QuestionOption> questionOptions = [];

        if (question.containsKey('options')) {
          for (var option in (question['options'] as List<dynamic>)) {
            questionOptions.add(QuestionOption.fromJson(option));
          }
        }

        if (question['type'] == "radio") {
          parsedQuestionsList.add(
              {"radio": RadioQuestion.fromJson(question, questionOptions)});
        } else if (question['type'] == "checkbox") {
          parsedQuestionsList.add({
            "checkbox": CheckBoxQuestion.fromJson(question, questionOptions)
          });
        } else if (question['type'] == "text") {
          parsedQuestionsList.add({"text": TextQuestion.fromJson(question)});
        }
      }
    }

    return QuestionOption(
      id: json['id'],
      optionText: json['option_text'],
      icon: json['icon'],
      questionsList: parsedQuestionsList, // Assign parsed questions list
    );
  }
}
