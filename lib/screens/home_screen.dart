import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart'; // Assurez-vous de créer ce fichier

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Agri-Cameroun'),
      ),
      drawer: user != null ? CustomDrawer() : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Bienvenue à Agri-Cameroun',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Cette application facilite l\'agriculture locale en fournissant des conseils, un suivi des cultures et un marché virtuel.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 30),
            if (user == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'login');
                    },
                    child: Text("Connexion"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    child: Text("Inscription"),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                child: Text("Mon Profil"),
              ),
          ],
        ),
      ),
    );
  }
}
