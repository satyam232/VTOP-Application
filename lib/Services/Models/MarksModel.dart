class MarksModel {
  String? classNbr;
  String? courseCode;
  String? courseMode;
  String? courseSystem;
  String? courseTitle;
  String? courseType;
  String? faculty;
  String? slot;
  List<Marks>? marks;

  MarksModel(
      {this.classNbr,
      this.courseCode,
      this.courseMode,
      this.courseSystem,
      this.courseTitle,
      this.courseType,
      this.faculty,
      this.slot,
      this.marks});

  MarksModel.fromJson(Map<String, dynamic> json) {
    classNbr = json['ClassNbr'] ?? 'N/A';
    courseCode = json['Course Code'] ?? 'N/A';
    courseMode = json['Course Mode'] ?? 'N/A';
    courseSystem = json['Course System'] ?? 'N/A';
    courseTitle = json['Course Title'] ?? 'N/A';
    courseType = json['Course Type'] ?? 'N/A';
    faculty = json['Faculty'] ?? 'N/A';
    slot = json['Slot'] ?? 'N/A';
    if (json['marks'] != null) {
      marks = <Marks>[];
      json['marks'].forEach((v) {
        marks!.add(Marks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClassNbr'] = classNbr;
    data['Course Code'] = courseCode;
    data['Course Mode'] = courseMode;
    data['Course System'] = courseSystem;
    data['Course Title'] = courseTitle;
    data['Course Type'] = courseType;
    data['Faculty'] = faculty;
    data['Slot'] = slot;
    if (marks != null) {
      data['marks'] = marks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Marks {
  String? markTitle;
  String? maxMark;
  String? remark;
  String? scoredMark;
  String? status;
  String? weightage;
  String? weightageMark;

  Marks(
      {this.markTitle,
      this.maxMark,
      this.remark,
      this.scoredMark,
      this.status,
      this.weightage,
      this.weightageMark});

  Marks.fromJson(Map<String, dynamic> json) {
    markTitle = json['Mark Title'] ?? 'N/A';
    maxMark = json['Max. Mark'] ?? 'N/A';
    remark = json['Remark'] ?? 'N/A';
    scoredMark = json['Scored Mark'] ?? 'N/A';
    status = json['Status'] ?? 'N/A';
    weightage = json['Weightage %'] ?? 'N/A';
    weightageMark = json['Weightage Mark'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Mark Title'] = markTitle;
    data['Max. Mark'] = maxMark;
    data['Remark'] = remark;
    data['Scored Mark'] = scoredMark;
    data['Status'] = status;
    data['Weightage %'] = weightage;
    data['Weightage Mark'] = weightageMark;
    return data;
  }
}
