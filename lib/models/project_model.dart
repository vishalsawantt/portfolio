class FeaturedProject {
  final String title;
  final String tagline;
  final String descroption;
  final List<String> tech;
  final String image;
  final String github;
  final String demo;
  final String badge;
  final List<String> points; // ← add this


  FeaturedProject({
    required this.title,
    required this.tagline,
    required this.descroption,
    required this.tech,
    required this.image,
    required this.github,
    required this.demo,
    required this.badge,
    required this.points,
  });

  factory FeaturedProject.fromJson(Map<String, dynamic> json) {
    return FeaturedProject(
      title: json['title'],
      tagline: json['tagline'],
      descroption: json['description'],
      tech: List<String>.from(json['tech']),
      image: json['image'],
      github: json['github'],
      demo: json['demo'],
      badge: json['badge'],
      points: List<String>.from(json['points']), 
    );
  }
}

//other project
class OtherProject {
  final String title;
  final String description;
  final List<String> tech;
  final String github;
  final String image; 

  OtherProject({
    required this.title,
    required this.description,
    required this.tech,
    required this.github,
    required this.image
  });

  factory OtherProject.formJson(Map<String, dynamic> json) {
    return OtherProject(
      title: json['title'], 
      description: json['description'], 
      tech: List<String>.from(json['tech']),
      github: json['github'],
      image: json['image']
    );
  }
}

//wrapper class for hold together prod and per

class ProjectsModel {
  final List<FeaturedProject> featured;
  final List<OtherProject> other;

  ProjectsModel({required this.featured, required this.other});

  factory ProjectsModel.fromJson(Map<String, dynamic> json) {
    return ProjectsModel(
      // json['featured'] is a List → map each item → FeaturedProject
      featured: (json['featured'] as List)
      .map((item) => FeaturedProject.fromJson(item))
      .toList(),

      // json['other'] is a List → map each item → OtherProject
      other: (json['other'] as List)
      .map((item) => OtherProject.formJson(item))
      .toList(),
    );
  }
}
