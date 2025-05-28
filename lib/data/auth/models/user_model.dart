class UserModel {
  final String? fullName;
  final String? email;
  final String? phoneNo;
  final String? password;
  final String? uid;
  final String? createdAt;

  UserModel({
    this.fullName,
    this.email,
    this.phoneNo,
    this.password,
    this.uid,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return UserModel();
    }
    return UserModel(
      fullName: data['fullName'] as String?,
      email: data['email'] as String?,
      phoneNo: data['phoneNo'] as String?,
      password: data['password'] as String?,
      uid: data['uid'] as String?,
      createdAt: data['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNo': phoneNo,
      'password': password,
      'uid': uid,
      'createdAt': createdAt,
    };
  }
}