class ExperienceModel {
  final String role;
  final String company;
  final String duration;
  final String location;
  final String type;
  final String description;
  final List<String> points;

  ExperienceModel({
    required this.role,
    required this.company,
    required this.duration,
    required this.location,
    required this.type,
    required this.description,
    required this.points
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      role: json['role'],
      company: json['company'],
      duration: json['duration'],
      location: json['location'],
      type: json['type'],
      description: json['description'],
      points: List<String>.from(json['points']),
    );
  }
}