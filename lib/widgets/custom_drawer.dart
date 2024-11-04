import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 70, // Ajustez cette valeur pour définir la hauteur
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 42, 102, 40),
              ),
              margin: EdgeInsets.only(bottom: 2),
              padding: EdgeInsets.all(
                  8), // Réduisez cette valeur pour un padding plus petit
              child: Align(
                alignment:
                    Alignment.centerLeft, // Positionne le texte sur la gauche
                child: Text(
                  'Menu de navigation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.groups),
            title: Text('Gestion des utilisateurs'),
            onTap: () {
              // Navigation vers la gestion des utilisateurs
            },
          ),
          ListTile(
            leading: Icon(Icons.lightbulb),
            title: Text('Conseils Agricoles'),
            onTap: () {
              Navigator.pushNamed(context, 'advice_list_screem');
            },
          ),
          ListTile(
            leading: Icon(Icons.agriculture),
            title: Text('Gestion des cultures'),
            onTap: () {
              Navigator.pushNamed(context, 'culture_tracking');
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Marché virtuel'),
            onTap: () {
              Navigator.pushNamed(context, 'market_screen');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications), // Utiliser l'icône choisie
            title: Text('Notifications et alertes'),
            onTap: () {
              // Naviguer vers la page des notifications et alertes
            },
          ),
          ListTile(
            leading: Icon(Icons.language), // Icône pour la partie multilingue
            title: Text('Accessibilité'),
            onTap: () {
              // Naviguer vers la page des paramètres multilingues et accessibilité
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'home');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Déconnexion'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
