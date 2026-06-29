class SkillsModel {
  final List<SkillCategory> categories;

  SkillsModel({required this.categories});

  factory SkillsModel.fromJson(Map<String, dynamic> json) {
    return SkillsModel(
      categories: (json['categories'] as List)
          .map((e) => SkillCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SkillCategory {
  final String title;
  final List<SkillItem> skills;

  SkillCategory({required this.title, required this.skills});

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      title: json['title'] as String,
      skills: (json['skills'] as List)
          .map((e) => SkillItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SkillItem {
  final String name;
  final String icon;

  SkillItem({required this.name, required this.icon});

  factory SkillItem.fromJson(Map<String, dynamic> json) {
    return SkillItem(
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }
}