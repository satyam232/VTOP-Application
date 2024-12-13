class AttendenceModel {
  String? slot;
  int? attended;
  String? code;
  String? courseId;
  String? courseName;
  String? courseShortType;
  String? faculty;
  List<HistoryModel>? history;
  String? percentage;
  String? subjectId;
  int? total;
  String? type;
  String? updatedOn;

  AttendenceModel({
    this.slot,
    this.attended,
    this.code,
    this.courseId,
    this.courseName,
    this.courseShortType,
    this.faculty,
    this.history,
    this.percentage,
    this.subjectId,
    this.total,
    this.type,
    this.updatedOn,
  });

  AttendenceModel.fromJson(Map<String, dynamic> json) {
    slot = json['Slot'];
    attended = json['attended'];
    code = json['code'];
    courseId = json['courseId'];
    courseName = json['courseName'];
    courseShortType = json['courseShortType'];
    faculty = json['faculty'];
    if (json['history'] != null) {
      history = List<HistoryModel>.from(
          json['history'].map((item) => HistoryModel.fromJson(item)));
    }
    percentage = json['percentage'];
    subjectId = json['subjectId'];
    total = json['total'];
    type = json['type'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Slot'] = slot;
    data['attended'] = attended;
    data['code'] = code;
    data['courseId'] = courseId;
    data['courseName'] = courseName;
    data['courseShortType'] = courseShortType;
    data['faculty'] = faculty;
    if (history != null) {
      data['history'] = history!.map((item) => item.toJson()).toList();
    }
    data['percentage'] = percentage;
    data['subjectId'] = subjectId;
    data['total'] = total;
    data['type'] = type;
    data['updatedOn'] = updatedOn;
    return data;
  }
}

class HistoryModel {
  String? attendanceDate;
  String? attendanceSlot;
  String? attendanceStatus;
  String? dayAndTiming;
  String? remarks;
  HistoryModel({
    this.attendanceDate,
    this.attendanceSlot,
    this.attendanceStatus,
    this.dayAndTiming,
  });

  HistoryModel.fromJson(Map<String, dynamic> json) {
    attendanceDate = json['Attendance Date'];
    attendanceSlot = json['Attendance Slot'];
    attendanceStatus = json['Attendance Status'];
    dayAndTiming = json['Day And Timing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Attendance Date'] = attendanceDate;
    data['Attendance Slot'] = attendanceSlot;
    data['Attendance Status'] = attendanceStatus;
    data['Day And Timing'] = dayAndTiming;

    return data;
  }
}
