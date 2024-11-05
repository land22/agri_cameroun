import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart';
import 'add_activity_screen.dart';
import 'edit_activity_screen.dart'; // Vérifiez que le nom du fichier est correct.

class CultureTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Suivi des Cultures'),
      ),
      drawer: user != null ? CustomDrawer() : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('activities').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune activité enregistrée.'));
          }

          final activities = snapshot.data!.docs.map((doc) {
            return Activity.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            padding:
                EdgeInsets.all(16), // Ajouter un padding autour de la liste
            itemCount: activities.length,
            itemBuilder: (context, index) {
              var activity = activities[index];
              return Card(
                margin: EdgeInsets.symmetric(
                    vertical: 8), // Espace vertical entre les cartes
                elevation: 4,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.all(16), // Espace interne dans la carte
                  title: Text(
                    activity.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    '${activity.description}\n${activity.date.toLocal().toString().split(' ')[0]}', // Format de date
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Naviguer vers l'écran d'édition d'activité
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditActivityScreen(activity: activity),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Confirmation avant suppression
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Confirmation"),
                              content: Text(
                                  "Voulez-vous vraiment supprimer cette activité ?"),
                              actions: [
                                TextButton(
                                  child: Text("Annuler"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: Text("Supprimer"),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('activities')
                                        .doc(activity.id)
                                        .delete();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers l'écran pour ajouter une activité
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddActivityScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
