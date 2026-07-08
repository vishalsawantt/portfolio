/// delete_account_model.dart
/// --------------------------
/// Typed model layer for the Delete Account & Data Deletion Policy page.
/// Mirrors the structure of `assets/data/delete_account_data.json`.

class DeleteAccountModel {
  final HeaderModel header;
  final List<PolicySectionModel> sections;
  final String checklistTitle;
  final String checklistIcon;
  final List<String> checklistItems;
  final PolicySectionModel retention;
  final PolicyContactModel contact;
  final String footer;

  DeleteAccountModel({
    required this.header,
    required this.sections,
    required this.checklistTitle,
    required this.checklistIcon,
    required this.checklistItems,
    required this.retention,
    required this.contact,
    required this.footer,
  });

  factory DeleteAccountModel.fromJson(Map<String, dynamic> json) {
    return DeleteAccountModel(
      header: HeaderModel.fromJson(json['header'] as Map<String, dynamic>),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => PolicySectionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      checklistTitle: json['checklistTitle'] as String,
      checklistIcon: json['checklistIcon'] as String,
      checklistItems: (json['checklistItems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      retention:
          PolicySectionModel.fromJson(json['retention'] as Map<String, dynamic>),
      contact:
          PolicyContactModel.fromJson(json['contact'] as Map<String, dynamic>),
      footer: json['footer'] as String,
    );
  }
}

class HeaderModel {
  final String title;
  final String subtitle;

  HeaderModel({required this.title, required this.subtitle});

  factory HeaderModel.fromJson(Map<String, dynamic> json) {
    return HeaderModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
    );
  }
}

/// Used for both "Delete Account" / "Delete Data" cards and the
/// "Data Retention" card since they share the same shape (icon/title/description).
class PolicySectionModel {
  final String icon;
  final String title;
  final String description;

  PolicySectionModel({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory PolicySectionModel.fromJson(Map<String, dynamic> json) {
    return PolicySectionModel(
      icon: json['icon'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}

/// Named PolicyContactModel (not ContactModel) to avoid clashing with the
/// ContactModel class already used by your Contact Us page/form.
class PolicyContactModel {
  final String developerName;
  final String developerEmail;
  final String portfolioUrl;

  PolicyContactModel({
    required this.developerName,
    required this.developerEmail,
    required this.portfolioUrl,
  });

  factory PolicyContactModel.fromJson(Map<String, dynamic> json) {
    return PolicyContactModel(
      developerName: json['developerName'] as String,
      developerEmail: json['developerEmail'] as String,
      portfolioUrl: json['portfolioUrl'] as String,
    );
  }
}