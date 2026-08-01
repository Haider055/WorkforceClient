class QuestionOption {
  int? id;
  String? optionText;

  QuestionOption({this.id, this.optionText});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: JsonParseHelper.toInt(json['id']),
      optionText: json['option_text'],
    );
  }
}

class Question {
  int? id;
  String? question;
  String? type;
  int? hasIcon;
  int? isRequired;
  String? description;
  List<QuestionOption>? options;

  Question({
    this.id,
    this.question,
    this.type,
    this.hasIcon,
    this.isRequired,
    this.description,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: JsonParseHelper.toInt(json['id']),
      question: json['question'],
      type: json['type'],
      hasIcon: JsonParseHelper.toInt(json['has_icon']),
      isRequired: JsonParseHelper.toInt(json['is_required']),
      description: json['description'],
      options: json['options'] != null
          ? (json['options'] as List)
              .map((o) => QuestionOption.fromJson(o))
              .toList()
          : [],
    );
  }
}

class PostedJobAnswers {
  int? id;
  int? anwserOptionId;
  List<int>? anwserOptionIds;
  String? type;
  String? answer;
  Question? question;

  PostedJobAnswers({
    this.id,
    this.anwserOptionId,
    this.anwserOptionIds,
    this.type,
    this.answer,
    this.question,
  });

  factory PostedJobAnswers.fromJson(Map<String, dynamic> json) {
    final Question questionObj = Question.fromJson(json['question']);

    final int singleOptionId =
        JsonParseHelper.toInt(json['anwser_option_id']) ?? 0;

    final List<int> multiOptionIds = json['anwser_option_ids'] != null
        ? (json['anwser_option_ids'] as List)
            .map((e) => JsonParseHelper.toInt(e))
            .whereType<int>()
            .toList()
        : [];

    final String? type = json['type'];
    String? resolvedAnswer = json['answer'];

    if (resolvedAnswer == null) {
      switch (type) {
        case 'checkbox':
          if (multiOptionIds.isNotEmpty) {
            final matchedTexts = (questionObj.options ?? [])
                .where((opt) => multiOptionIds.contains(opt.id))
                .map((opt) => opt.optionText ?? '')
                .where((text) => text.isNotEmpty)
                .toList();
            if (matchedTexts.isNotEmpty) {
              resolvedAnswer = matchedTexts.join(', ');
            }
          }
          break;

        case 'radio':
          if (singleOptionId != 0) {
            final matched = (questionObj.options ?? []).firstWhere(
              (opt) => opt.id == singleOptionId,
              orElse: () => QuestionOption(id: null, optionText: null),
            );
            resolvedAnswer = matched.optionText;
          }
          break;

        case 'text':
          break;

        default:
          break;
      }
    }

    return PostedJobAnswers(
      id: JsonParseHelper.toInt(json['id']),
      anwserOptionId: singleOptionId,
      anwserOptionIds: multiOptionIds,
      type: type,
      answer: resolvedAnswer,
      question: questionObj,
    );
  }
}

class JsonParseHelper {
  static int? toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
