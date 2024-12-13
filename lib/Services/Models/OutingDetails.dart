class OutingDetails {
  String? hostelBlock;
  int? roomNo;
  String? bookingId;
  String? dateOfVisit;
  Null? download;
  String? placeOfVisit;
  String? status;

  OutingDetails(
      {this.hostelBlock,
      this.roomNo,
      this.bookingId,
      this.dateOfVisit,
      this.download,
      this.placeOfVisit,
      this.status});

  OutingDetails.fromJson(Map<String, dynamic> json) {
    hostelBlock = json['Hostel Block'];
    roomNo = json['Room no'];
    bookingId = json['bookingId'];
    dateOfVisit = json['dateOfVisit'];
    download = json['download'];
    placeOfVisit = json['placeOfVisit'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Hostel Block'] = this.hostelBlock;
    data['Room no'] = this.roomNo;
    data['bookingId'] = this.bookingId;
    data['dateOfVisit'] = this.dateOfVisit;
    data['download'] = this.download;
    data['placeOfVisit'] = this.placeOfVisit;
    data['status'] = this.status;
    return data;
  }
}
