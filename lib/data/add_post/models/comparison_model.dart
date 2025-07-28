import 'package:cloud_firestore/cloud_firestore.dart';

class ComparisonModel {
  final String? id;
  final String userId;
  final List<String> carIds;
  final DateTime createdAt;

  ComparisonModel({
    this.id,
    required this.userId,
    required this.carIds,
    required this.createdAt,
  });

  factory ComparisonModel.fromMap(Map<String, dynamic> map, String id) {
    return ComparisonModel(
      id: id,
      userId: map['userId'] as String,
      carIds: List<String>.from(map['carIds'] as List),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'carIds': carIds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}