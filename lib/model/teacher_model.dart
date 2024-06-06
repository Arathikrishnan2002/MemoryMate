class Teacher {
  String? uid;
  String? email;
  String? fullname;
  String? patientName;
  String? referralId;
  String? phone;
  String? password;
  String? confirmpassword;
  String? role;

  Teacher({
    this.uid,
    this.email,
    this.fullname,
    this.patientName,
    this.referralId,
    this.phone,
    this.password,
    this.confirmpassword,
    this.role,
  });

  factory Teacher.fromMap(map) {
    return Teacher(
      uid: map['uid'],
      email: map['email'],
      fullname: map['fullname'],
      patientName: map['patientName'],
      referralId: map['referralId'],
      phone: map['phone'],
      password: map['password'],
      confirmpassword: map['onfirmpassword'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'patientName': patientName,
      'referralId': referralId,
      'phone': phone,
      'password': password,
      'confirmpassword': confirmpassword,
      'role': role,
    };
  }
}
