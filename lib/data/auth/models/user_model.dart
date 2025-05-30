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

  // Add fromMap constructor if needed
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] as String?,
      email: map['email'] as String?,
      phoneNo: map['phoneNo'] as String?,
      password: map['password'] as String?,
      uid: map['uid'] as String?,
      createdAt: map['createdAt']?.toString(),
    );
  }
}