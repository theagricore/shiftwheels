class UserPostLimit {
  final String userId;
  final int postCount;
  final DateTime resetDate;
  final bool isPremium;
  final DateTime? premiumExpiryDate;

  UserPostLimit({
    required this.userId,
    required this.postCount,
    required this.resetDate,
    this.isPremium = false,
    this.premiumExpiryDate,
  });

  factory UserPostLimit.fromMap(Map<String, dynamic> map) {
    return UserPostLimit(
      userId: map['userId'] as String,
      postCount: map['postCount'] as int,
      resetDate: DateTime.parse(map['resetDate'] as String),
      isPremium: map['isPremium'] as bool? ?? false,
      premiumExpiryDate: map['premiumExpiryDate'] != null 
          ? DateTime.parse(map['premiumExpiryDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'postCount': postCount,
      'resetDate': resetDate.toIso8601String(),
      'isPremium': isPremium,
      'premiumExpiryDate': premiumExpiryDate?.toIso8601String(),
    };
  }

  bool get hasReachedLimit => !isPremiumActive && postCount >= 4;

  bool get isPremiumActive {
    if (!isPremium) return false;
    if (premiumExpiryDate == null) return true;
    return DateTime.now().isBefore(premiumExpiryDate!);
  }

  UserPostLimit copyWith({
    String? userId,
    int? postCount,
    DateTime? resetDate,
    bool? isPremium,
    DateTime? premiumExpiryDate,
  }) {
    return UserPostLimit(
      userId: userId ?? this.userId,
      postCount: postCount ?? this.postCount,
      resetDate: resetDate ?? this.resetDate,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
    );
  }
}