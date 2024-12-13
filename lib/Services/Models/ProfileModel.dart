class ProfileModel {
  String? appNo;
  String? branch;
  String? email;
  String? name;
  String? proctorEmail;
  String? proctorMobileNumber;
  String? proctorName;
  String? profileImageBase64;
  String? program;
  String? regNo;
  Null? school;
  String? token;

  ProfileModel(
      {this.appNo,
      this.branch,
      this.email,
      this.name,
      this.proctorEmail,
      this.proctorMobileNumber,
      this.proctorName,
      this.profileImageBase64,
      this.program,
      this.regNo,
      this.school,
      this.token});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    appNo = json['appNo'];
    branch = json['branch'];
    email = json['email'];
    name = json['name'];
    proctorEmail = json['proctorEmail'];
    proctorMobileNumber = json['proctorMobileNumber'];
    proctorName = json['proctorName'];
    profileImageBase64 = json['profileImageBase64'] ?? " ";
    program = json['program'];
    regNo = json['regNo'];
    school = json['school'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appNo'] = this.appNo;
    data['branch'] = this.branch;
    data['email'] = this.email;
    data['name'] = this.name;
    data['proctorEmail'] = this.proctorEmail;
    data['proctorMobileNumber'] = this.proctorMobileNumber;
    data['proctorName'] = this.proctorName;
    data['profileImageBase64'] = this.profileImageBase64;
    data['program'] = this.program;
    data['regNo'] = this.regNo;
    data['school'] = this.school;
    data['token'] = this.token;
    return data;
  }
}
