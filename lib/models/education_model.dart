class EducationModel {
  final String degree;
  final String institute;
  final String duration;
  final String score;

  EducationModel({
    required this.degree,
    required this.institute,
    required this.duration,
    required this.score,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json['degree'],
      institute: json['institute'],
      duration: json['duration'],
      score: json['score'],
    );
  }
}
