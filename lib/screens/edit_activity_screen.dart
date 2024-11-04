import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Assurez-vous d'importer Firestore
import 'package:agri_cameroun/models/activity_model.dart'; // Remplacez par le chemin de votre modèle Activity

class Activity {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  // Méthode pour créer une instance d'Activity depuis un DocumentSnapshot
  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Activity(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}

class EditActivityScreen extends StatelessWidget {
  final Activity activity;

  EditActivityScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    // Contrôleurs pour les champs de texte
    final titleController = TextEditingController(text: activity.title);
    final descriptionController =
        TextEditingController(text: activity.description);
    final dateController =
        TextEditingController(text: activity.date.toIso8601String());

    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier l\'Activité'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Logique pour mettre à jour l'activité dans Firestore
                await FirebaseFirestore.instance
                    .collection('activities')
                    .doc(activity.id) // Utilisez l'ID de l'activité existante
                    .update({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'date': DateTime.parse(dateController.text),
                });

                Navigator.pop(context); // Retour à l'écran précédent
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
