class ChapterModel {
  final num chapterNumber;
  final String chapterName;

  ChapterModel({
    required this.chapterNumber,
    required this.chapterName,
  });

  Map<String, dynamic> toJson() {
    return {
      'chapter_number': chapterNumber,
      'chapter_name': chapterName,
    };
  }

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      chapterNumber: json['email'],
      chapterName: json['chapter_name'],
    );
  }
}
