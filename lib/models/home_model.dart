class HomeModel {
  // Defines the structure of data coming from home.json
  final String name;
  final List<String> titles; 
  final String bio;
  final String cvUrl;
  final String github;
  final String linkedin;
  final String profileImage;

  HomeModel({
    required this.name,
    required this.titles,
    required this.bio,
    required this.cvUrl,
    required this.github,
    required this.linkedin,
    required this.profileImage,
  });

  // factory constructor — converts JSON map → HomeModel object
  // json['name'] means → read "name" key from JSON file
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      name: json['name'],

      // json['titles'] is a List
      titles: List<String>.from(json['titles']),

      bio: json['bio'],
      cvUrl: json['cv_url'],
      github: json['github'],
      linkedin: json['linkedin'],
      profileImage: json['profile_image'],
    );
  }
}