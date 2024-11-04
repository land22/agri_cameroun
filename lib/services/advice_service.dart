import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/agricultural_advice.dart';

class AdviceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AgriculturalAdvice>> fetchSeasonalAdvices(String season) async {
    final querySnapshot = await _firestore
        .collection('conseilsAgricoles')
        .where('season', isEqualTo: season)
        .get();

    return querySnapshot.docs.map((doc) {
      return AgriculturalAdvice.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
