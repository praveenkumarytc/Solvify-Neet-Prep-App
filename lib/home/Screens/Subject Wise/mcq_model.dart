import 'dart:convert';

class McqModel {
  McqModel({
    required this.question,
    required this.solutionImage,
    required this.options,
  });

  String question;
  String solutionImage;
  List<Option> options;

  factory McqModel.fromJson(Map<String, dynamic>? json) => json == null
      ? McqModel(question: '', solutionImage: '', options: [])
      : McqModel(
          question: json["question"] ?? '',
          solutionImage: json["solution_image"] ?? '',
          options: List<Option>.from((json["options"] ?? []).map((x) => Option.fromJson(x as Map<String, dynamic>))),
        );

  Map<String, dynamic> toJson() => {
        "question": question,
        "solution_image": solutionImage,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  Option({
    required this.isCorrect,
    required this.optNo,
    required this.optionDetail,
  });

  bool isCorrect;
  dynamic optNo;
  String optionDetail;

  factory Option.fromJson(Map<String, dynamic>? json) => json == null
      ? Option(isCorrect: false, optNo: '', optionDetail: '')
      : Option(
          isCorrect: json["is_correct"] ?? false,
          optNo: json["opt_no"] ?? '',
          optionDetail: json["option_detail"] ?? '',
        );

  Map<String, dynamic> toJson() => {
        "is_correct": isCorrect,
        "opt_no": optNo,
        "option_detail": optionDetail,
      };
}
