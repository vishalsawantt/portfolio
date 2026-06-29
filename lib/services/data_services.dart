import 'package:flutter/services.dart';
import 'package:portfolio/models/about_model.dart';
import 'package:portfolio/models/contact_model.dart';
import 'package:portfolio/models/education_model.dart';
import 'package:portfolio/models/experience_model.dart';
import 'package:portfolio/models/footer_model.dart';
import 'package:portfolio/models/project_model.dart';
import 'package:portfolio/models/skills_model.dart'; 
import 'dart:convert'; 
import '../models/home_model.dart';

class DataService {
  
  static Future<HomeModel> loadHome() async {
    // reads file from assets/data/home.json
    final String rawJson =
        await rootBundle.loadString('assets/data/home.json');

    // converts raw string → Map<String, dynamic>
    final Map<String, dynamic> jsonMap = jsonDecode(rawJson);

    // converts map → HomeModel object and returns it
    return HomeModel.fromJson(jsonMap);
  }

  // static Future<List<SkillModel>> loadSkills() async {
  //   final String rawJson = await rootBundle.loadString('assets/data/skills.json');
  //   final List<dynamic> jsonList = jsonDecode(rawJson);
  //   return jsonList.map((item) => SkillModel.fromJson(item)).toList();
  // }

  static Future<SkillsModel> loadSkills() async {
  final String jsonString = await rootBundle.loadString('assets/data/skills.json');
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);
  return SkillsModel.fromJson(jsonData);
}

  static Future<List<ExperienceModel>> loadExperience() async {
    final String rawJson = await rootBundle.loadString('assets/data/experience.json');
    final List<dynamic> jsonList = jsonDecode(rawJson);
    return jsonList.map((item) => ExperienceModel.fromJson(item)).toList();
  }

  static Future<List<EducationModel>> loadEducation() async {
    final String rawJson = await rootBundle.loadString('assets/data/education.json');
    final List<dynamic> jsonList = jsonDecode(rawJson);
    return jsonList.map((item) => EducationModel.fromJson(item)).toList();
  }

  static Future<ProjectsModel> loadProjects() async {
    final String rawJson = await rootBundle.loadString('assets/data/projects.json');
    // projects.json is ONE object (not a list) → jsonDecode gives Map
    final Map<String, dynamic> jsonMap = jsonDecode(rawJson);
    return ProjectsModel.fromJson(jsonMap);
  }

  static Future<AboutModel> loadAbout() async {
  final String jsonString = await rootBundle.loadString('assets/data/about.json');
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);
  return AboutModel.fromJson(jsonData);
}

static Future<ContactModel> loadContact() async {
  final String jsonString = await rootBundle.loadString('assets/data/contact.json');
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);
  return ContactModel.fromJson(jsonData);
}

static Future<FooterModel> loadFooter() async {
  final String jsonString = await rootBundle.loadString('assets/data/footer.json');
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);
  return FooterModel.fromJson(jsonData);
}
}