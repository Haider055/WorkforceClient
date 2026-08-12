class ReportOption {
  String? value;
  String? label;

  ReportOption({this.value, this.label});

  factory ReportOption.fromJson(Map<String, dynamic> json) {
    return ReportOption(
      value: json['value'],
      label: json['label'],
    );
  }
}

class ReportOptions {
  List<ReportOption> reasons;
  List<ReportOption> reportableTypes;
  int detailsMaxLength;

  ReportOptions({
    required this.reasons,
    required this.reportableTypes,
    required this.detailsMaxLength,
  });

  factory ReportOptions.fromJson(Map<String, dynamic> json) {
    return ReportOptions(
      reasons: json['reasons'] != null
          ? (json['reasons'] as List)
              .map((item) => ReportOption.fromJson(item))
              .toList()
          : [],
      reportableTypes: json['reportable_types'] != null
          ? (json['reportable_types'] as List)
              .map((item) => ReportOption.fromJson(item))
              .toList()
          : [],
      detailsMaxLength: json['details_max_length'] ?? 1000,
    );
  }
}
