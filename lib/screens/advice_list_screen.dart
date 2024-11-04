import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart';
import 'advice_form_screen.dart';

class AdviceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Conseils Agricoles Saisonniers'),
      ),
      drawer: user != null ? CustomDrawer() : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('conseils').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Aucun conseil pour le moment.'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdviceFormScreen(),
                        ),
                      );
                    },
                    child: Text('Ajouter un nouveau conseil'),
                  ),
                ],
              ),
            );
          }

          final conseils = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conseils.length,
            itemBuilder: (context, index) {
              var conseil = conseils[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    conseil['titre'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    conseil['description'],
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdviceFormScreen(conseilId: conseil.id),
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
                                  "Voulez-vous vraiment supprimer ce conseil ?"),
                              actions: [
                                TextButton(
                                  child: Text("Annuler"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: Text("Supprimer"),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('conseils')
                                        .doc(conseil.id)
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdviceFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
