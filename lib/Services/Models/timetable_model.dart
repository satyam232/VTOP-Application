class TimetableModel {
  List<ClassDetail>? friday;
  List<ClassDetail>? monday;
  List<ClassDetail>? saturday;
  List<ClassDetail>? sunday;
  List<ClassDetail>? thursday;
  List<ClassDetail>? tuesday;
  List<ClassDetail>? wednesday;

  TimetableModel({
    this.friday,
    this.monday,
    this.saturday,
    this.sunday,
    this.thursday,
    this.tuesday,
    this.wednesday,
  });

  TimetableModel.fromJson(Map<String, dynamic> json) {
    friday = json['Friday'] != null
        ? List<ClassDetail>.from(
            json['Friday'].map((v) => ClassDetail.fromJson(v)))
        : null;
    monday = json['Monday'] != null
        ? List<ClassDetail>.from(
            json['Monday'].map((v) => ClassDetail.fromJson(v)))
        : null;
    saturday = json['Saturday'] != null
        ? List<ClassDetail>.from(
            json['Saturday'].map((v) => ClassDetail.fromJson(v)))
        : null;
    sunday = json['Sunday'] != null
        ? List<ClassDetail>.from(
            json['Sunday'].map((v) => ClassDetail.fromJson(v)))
        : null;
    thursday = json['Thursday'] != null
        ? List<ClassDetail>.from(
            json['Thursday'].map((v) => ClassDetail.fromJson(v)))
        : null;
    tuesday = json['Tuesday'] != null
        ? List<ClassDetail>.from(
            json['Tuesday'].map((v) => ClassDetail.fromJson(v)))
        : null;
    wednesday = json['Wednesday'] != null
        ? List<ClassDetail>.from(
            json['Wednesday'].map((v) => ClassDetail.fromJson(v)))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.friday != null) {
      data['Friday'] = this.friday!.map((v) => v.toJson()).toList();
    }
    if (this.monday != null) {
      data['Monday'] = this.monday!.map((v) => v.toJson()).toList();
    }
    if (this.saturday != null) {
      data['Saturday'] = this.saturday!.map((v) => v.toJson()).toList();
    }
    if (this.sunday != null) {
      data['Sunday'] = this.sunday!.map((v) => v.toJson()).toList();
    }
    if (this.thursday != null) {
      data['Thursday'] = this.thursday!.map((v) => v.toJson()).toList();
    }
    if (this.tuesday != null) {
      data['Tuesday'] = this.tuesday!.map((v) => v.toJson()).toList();
    }
    if (this.wednesday != null) {
      data['Wednesday'] = this.wednesday!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassDetail {
  String? className;
  String? code;
  String? courseName;
  String? endTime;
  String? slot;
  String? startTime;
  String? type;

  ClassDetail({
    this.className,
    this.code,
    this.courseName,
    this.endTime,
    this.slot,
    this.startTime,
    this.type,
  });

  ClassDetail.fromJson(Map<String, dynamic> json) {
    className = json['class'];
    code = json['code'];
    courseName = json['courseName'];
    endTime = json['endTime'];
    slot = json['slot'];
    startTime = json['startTime'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class'] = this.className;
    data['code'] = this.code;
    data['courseName'] = this.courseName;
    data['endTime'] = this.endTime;
    data['slot'] = this.slot;
    data['startTime'] = this.startTime;
    data['type'] = this.type;
    return data;
  }
}
