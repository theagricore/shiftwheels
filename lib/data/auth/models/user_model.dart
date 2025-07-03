class UserModel {
  final String? fullName;
  final String? email;
  final String? phoneNo;
  final String? password;
  final String? uid;
  final String? createdAt;
  final String? image;
  final bool isBlocked;  // Added field for blocking functionality

  UserModel({
    this.fullName,
    this.email,
    this.phoneNo,
    this.password,
    this.uid,
    this.createdAt,
    this.image,
    this.isBlocked = false,  // Default to false
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      return UserModel(
        fullName: _parseString(map['fullName']),
        email: _parseString(map['email']),
        phoneNo: _parseString(map['phoneNo']),
        password: _parseString(map['password']),
        uid: _parseString(map['uid']),
        createdAt: _parseString(map['createdAt']),
        image: _parseImageUrl(map['image']) ?? 'https://example.com/default-profile.jpg',
        isBlocked: map['isBlocked'] as bool? ?? false,  // Handle null case
      );
    } catch (e) {
      print('Error parsing UserModel: $e');
      return UserModel(
        uid: _parseString(map['uid']),
        isBlocked: map['isBlocked'] as bool? ?? false,
      );
    }
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static String? _parseImageUrl(dynamic value) {
    if (value == null) return null;
    final url = value.toString();
    return url.isEmpty ? null : url;
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
      'isBlocked': isBlocked,  // Include in serialization
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
    bool? isBlocked,  // Added to copyWith
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      password: password ?? this.password,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
      isBlocked: isBlocked ?? this.isBlocked,  // Include in copy
    );
  }

  @override
  String toString() {
    return 'UserModel('
        'fullName: $fullName, '
        'email: $email, '
        'phoneNo: $phoneNo, '
        'uid: $uid, '
        'isBlocked: $isBlocked, '
        'image: ${image != null ? "[set]" : "null"}'
        ')';
  }
}