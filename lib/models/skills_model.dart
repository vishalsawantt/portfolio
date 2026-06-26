class SkillModel {
  final String category;
  final String icon;
  final List<String> skills;

  SkillModel({
    required this.category,
    required this.icon,
    required this.skills,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      category: json['category'],
      icon: json['icon'],
      skills: List<String>.from(json['skills']),
    );
  }
}