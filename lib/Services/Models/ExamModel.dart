class ExamsModel {
  List<CAT1>? cAT1;
  List<CAT1>? cAT2;
  List<CAT1>? fAT;

  ExamsModel({this.cAT1, this.cAT2, this.fAT});

  ExamsModel.fromJson(Map<String, dynamic> json) {
    if (json['CAT1'] != null) {
      cAT1 = <CAT1>[];
      json['CAT1'].forEach((v) {
        cAT1!.add(new CAT1.fromJson(v));
      });
    }
    if (json['CAT2'] != null) {
      cAT2 = <CAT1>[];
      json['CAT2'].forEach((v) {
        cAT2!.add(new CAT1.fromJson(v));
      });
    }
    if (json['FAT'] != null) {
      fAT = <CAT1>[];
      json['FAT'].forEach((v) {
        fAT!.add(new CAT1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cAT1 != null) {
      data['CAT1'] = this.cAT1!.map((v) => v.toJson()).toList();
    }
    if (this.cAT2 != null) {
      data['CAT2'] = this.cAT2!.map((v) => v.toJson()).toList();
    }
    if (this.fAT != null) {
      data['FAT'] = this.fAT!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<String> getTypes() {
    List<String> types = [];
    if (cAT1 != null && cAT1!.isNotEmpty) types.add('CAT1');
    if (cAT2 != null && cAT2!.isNotEmpty) types.add('CAT2');
    if (fAT != null && fAT!.isNotEmpty) types.add('FAT');
    return types;
  }

  /// Method to get the exams for a given type
  List<CAT1> getExamsForType(String type) {
    switch (type) {
      case 'CAT1':
        return cAT1 ?? [];
      case 'CAT2':
        return cAT2 ?? [];
      case 'FAT':
        return fAT ?? [];
      default:
        return [];
    }
  }
}

class CAT1 {
  String? classID;
  String? courseCode;
  String? courseTitle;
  String? examDate;
  String? examTime;
  String? reportingTime;
  String? seatLocation;
  String? seatNo;
  String? slot;
  String? venueBlock;
  String? venueRoom;

  CAT1(
      {this.classID,
      this.courseCode,
      this.courseTitle,
      this.examDate,
      this.examTime,
      this.reportingTime,
      this.seatLocation,
      this.seatNo,
      this.slot,
      this.venueBlock,
      this.venueRoom});

  CAT1.fromJson(Map<String, dynamic> json) {
    classID = json['Class ID'];
    courseCode = json['Course Code'];
    courseTitle = json['Course Title'];
    examDate = json['Exam Date'];
    examTime = json['Exam Time'];
    reportingTime = json['Reporting Time'];
    seatLocation = json['Seat Location'];
    seatNo = json['Seat No'];
    slot = json['Slot'];
    venueBlock = json['Venue Block'];
    venueRoom = json['Venue Room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Class ID'] = this.classID;
    data['Course Code'] = this.courseCode;
    data['Course Title'] = this.courseTitle;
    data['Exam Date'] = this.examDate;
    data['Exam Time'] = this.examTime;
    data['Reporting Time'] = this.reportingTime;
    data['Seat Location'] = this.seatLocation;
    data['Seat No'] = this.seatNo;
    data['Slot'] = this.slot;
    data['Venue Block'] = this.venueBlock;
    data['Venue Room'] = this.venueRoom;
    return data;
  }
}
