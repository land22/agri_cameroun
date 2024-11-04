import 'package:cloud_firestore/cloud_firestore.dart';

class AgriculturalAdvice {
  final String season;
  final String cropType;
  final String advice;
  final DateTime createdAt;

  AgriculturalAdvice({
    required this.season,
    required this.cropType,
    required this.advice,
    required this.createdAt,
  });

  // Méthode pour créer un objet AgriculturalAdvice à partir d'une map Firebase
  factory AgriculturalAdvice.fromMap(Map<String, dynamic> data) {
    return AgriculturalAdvice(
      season: data['season'],
      cropType: data['cropType'],
      advice: data['advice'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
