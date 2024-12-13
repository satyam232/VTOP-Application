// Curriculum.dart

class Curriculum {
  final List<Course> programCore;
  final List<Course> programElective;
  final List<Course> universityCore;
  final List<Course> universityElective;

  Curriculum({
    required this.programCore,
    required this.programElective,
    required this.universityCore,
    required this.universityElective,
  });

  factory Curriculum.fromJson(Map<String, dynamic> json) {
    return Curriculum(
      programCore: (json['ProgramCore'] as List<dynamic>)
          .map((item) => Course.fromJson(item))
          .toList(),
      programElective: (json['ProgramElective'] as List<dynamic>)
          .map((item) => Course.fromJson(item))
          .toList(),
      universityCore: (json['UniversityCore'] as List<dynamic>)
          .map((item) => Course.fromJson(item))
          .toList(),
      universityElective: (json['UniversityElective'] as List<dynamic>)
          .map((item) => Course.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProgramCore': programCore.map((course) => course.toJson()).toList(),
      'ProgramElective':
          programElective.map((course) => course.toJson()).toList(),
      'UniversityCore':
          universityCore.map((course) => course.toJson()).toList(),
      'UniversityElective':
          universityElective.map((course) => course.toJson()).toList(),
    };
  }
}

class Course {
  final String courseCode;
  final String courseTitle;
  final String credits;
  final String registrationStatus;

  Course({
    required this.courseCode,
    required this.courseTitle,
    required this.credits,
    required this.registrationStatus,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseCode: json['courseCode'] as String,
      courseTitle: json['courseTitle'] as String,
      credits: json['credits'] as String,
      registrationStatus: json['registrationStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'credits': credits,
      'registrationStatus': registrationStatus,
    };
  }
}
