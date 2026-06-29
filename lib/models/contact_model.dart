class ContactModel {
  final String heading;
  final String subheading;
  final String formsubmitEmail;
  final String email;
  final String phone;
  final String location;

  ContactModel({
    required this.heading,
    required this.subheading,
    required this.formsubmitEmail,
    required this.email,
    required this.phone,
    required this.location,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      heading: json['heading'] as String,
      subheading: json['subheading'] as String,
      formsubmitEmail: json['formsubmit_email'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
    );
  }
}