class UserModel {
  final String? fullName;
  final String? email;
  final String? phoneNo;
  final String? password;
  final String? uid;
  final String? createdAt;
  final String? image;

  UserModel({
    this.fullName,
    this.email,
    this.phoneNo,
    this.password,
    this.uid,
    this.createdAt,
    this.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] as String?,
      email: map['email'] as String?,
      phoneNo: map['phoneNo'] as String?,
      password: map['password'] as String?,
      uid: map['uid'] as String?,
      createdAt: map['createdAt']?.toString(),
      image: map['image'] as String?,
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
      'image': image,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phoneNo,
    String? password,
    String? uid,
    String? createdAt,
    String? image,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      password: password ?? this.password,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
    );
  }
}