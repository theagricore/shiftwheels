import 'dart:convert';

import 'package:shiftwheels/domain/auth/entitys/user_entity.dart';

class GetUserData {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNo;
  final String? image;
  final bool isBlocked;  

  GetUserData({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    this.image,
    this.isBlocked = false,  
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phoneNo': phoneNo,
      'image': image,
      'isBlocked': isBlocked,  
    };
  }

  factory GetUserData.fromMap(Map<String, dynamic> map) {
    return GetUserData(
      userId: map['uid'] as String? ?? map['userId'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNo: map['phoneNo']?.toString() ?? '',
      image: map['image'] as String?,
      isBlocked: map['isBlocked'] as bool? ?? false,  
    );
  }

  String toJson() => json.encode(toMap());
  
  factory GetUserData.fromJson(String source) =>
      GetUserData.fromMap(json.decode(source) as Map<String, dynamic>);

  GetUserData copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phoneNo,
    String? image,
    bool? isBlocked,
  }) {
    return GetUserData(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      image: image ?? this.image,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  @override
  String toString() {
    return 'GetUserData('
        'userId: $userId, '
        'fullName: $fullName, '
        'email: $email, '
        'phoneNo: $phoneNo, '
        'image: $image, '
        'isBlocked: $isBlocked'
        ')';
  }
}

extension UserXmodel on GetUserData {
  GetUserEntity toEntity() {
    return GetUserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phoneNo: phoneNo,
      image: image,
      isBlocked: isBlocked,  
    );
  }
}