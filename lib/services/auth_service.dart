import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour inscrire un nouvel utilisateur avec rôle "user" par défaut
  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    try {
      // Inscription de l'utilisateur
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtenir l'ID de l'utilisateur inscrit
      User? user = userCredential.user;
      if (user != null) {
        // Ajouter le profil utilisateur avec le rôle par défaut
        await _firestore.collection('profiles').doc(user.uid).set({
          'userId': user.uid,
          'name': name,
          'email': email,
          'profileType': 'user', // Attribuer le rôle "user" par défaut
          'bio': '',
        });
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      throw e;
    }
  }

  // Connexion de l'utilisateur
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (error) {
      throw error; // Gérer les erreurs ici si nécessaire
    }
  }
}
