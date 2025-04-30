import 'dart:convert';

import 'package:shiftwheels/domain/auth/entitys/user_entity.dart';

class GetUserData {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNo;
  final String? image;
  GetUserData({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phoneNo': phoneNo,
      'image': image,
    };
  }

  factory GetUserData.fromMap(Map<String, dynamic> map) {
    return GetUserData(
      userId: map['uid'] as String? ?? map['userId'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNo: map['phoneNo']?.toString() ?? '',
      image: map['image'] as String?,
    );
  }

  String toJson() => json.encode(toMap());
  factory GetUserData.fromJson(String source) =>
      GetUserData.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension UserXmodel on GetUserData {
  GetUserEntity toEntity() {
    return GetUserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phoneNo: phoneNo,
      image: image,
    );
  }
}
