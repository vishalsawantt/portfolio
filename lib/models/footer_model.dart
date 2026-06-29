class FooterModel {
  final String name;
  final String tagline;
  final String github;
  final String linkedin;
  final String whatsapp;
  final String copyrightName;

  FooterModel({
    required this.name,
    required this.tagline,
    required this.github,
    required this.linkedin,
    required this.whatsapp,
    required this.copyrightName,
  });

  factory FooterModel.fromJson(Map<String, dynamic> json) {
    return FooterModel(
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      github: json['github'] as String,
      linkedin: json['linkedin'] as String,
      whatsapp: json['whatsapp'] as String,
      copyrightName: json['copyright_name'] as String,
    );
  }
}