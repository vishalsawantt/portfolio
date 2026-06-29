class AboutModel {
  final String badge;
  final String heading;
  final String description;
  final List<AboutStat> stats;
  final PhotoBadge photoBadge;
  final String image;
  final String cvUrl;

  AboutModel({
    required this.badge,
    required this.heading,
    required this.description,
    required this.stats,
    required this.photoBadge,
    required this.image,
    required this.cvUrl,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      badge: json['badge'] as String,
      heading: json['heading'] as String,
      description: json['description'] as String,
      stats: (json['stats'] as List)
          .map((e) => AboutStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      photoBadge: PhotoBadge.fromJson(
        json['photo_badge'] as Map<String, dynamic>,
      ),
      image: json['image'] as String,
      cvUrl: json['cv_url'] as String,
    );
  }
}

class AboutStat {
  final String value;
  final String label;

  AboutStat({required this.value, required this.label});

  factory AboutStat.fromJson(Map<String, dynamic> json) {
    return AboutStat(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }
}

class PhotoBadge {
  final String value;
  final String label;

  PhotoBadge({required this.value, required this.label});

  factory PhotoBadge.fromJson(Map<String, dynamic> json) {
    return PhotoBadge(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }
}