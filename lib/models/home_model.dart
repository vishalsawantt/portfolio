class HomeModel {
  // Defines the structure of data coming from home.json
  final String name;
  final List<String> titles; 
  final String status;
  final String headline;
  final String bio;
  final String cvUrl;
  final String github;
  final String linkedin;
  final String profileImage;
  final String email;

  HomeModel({
    required this.name,
    required this.titles,
    required this.status,
    required this.headline,
    required this.bio,
    required this.cvUrl,
    required this.github,
    required this.linkedin,
    required this.profileImage,
    required this.email
  });

  // factory constructor — converts JSON map → HomeModel object
  // json['name'] means → read "name" key from JSON file
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      name: json['name'],

      // json['titles'] is a List
      titles: List<String>.from(json['titles']),

      status: json['status'] as String,
      headline: json['headline'] as String,
      bio: json['bio'],
      cvUrl: json['cv_url'],
      github: json['github'],
      linkedin: json['linkedin'],
      profileImage: json['profile_image'],
      email: json['email']
    );
  }
}