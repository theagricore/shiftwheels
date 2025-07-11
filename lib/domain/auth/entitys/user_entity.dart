class GetUserEntity {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNo;
  final String? image;
  final bool isBlocked;  
  GetUserEntity({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    this.image,
    this.isBlocked = false, 
  });
}
