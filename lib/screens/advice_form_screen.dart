import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart';

class AdviceFormScreen extends StatefulWidget {
  final String? conseilId;

  AdviceFormScreen({this.conseilId});

  @override
  _AdviceFormScreenState createState() => _AdviceFormScreenState();
}

class _AdviceFormScreenState extends State<AdviceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _titre = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    if (widget.conseilId != null) {
      FirebaseFirestore.instance
          .collection('conseils')
          .doc(widget.conseilId)
          .get()
          .then((doc) {
        if (doc.exists) {
          setState(() {
            _titre = doc['titre'];
            _description = doc['description'];
          });
        }
      });
    }
  }

  void _saveAdvice() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.conseilId == null) {
        // Ajouter un nouveau conseil
        FirebaseFirestore.instance.collection('conseils').add({
          'titre': _titre,
          'description': _description,
          'date': Timestamp.now(),
        });
      } else {
        // Modifier un conseil existant
        FirebaseFirestore.instance
            .collection('conseils')
            .doc(widget.conseilId)
            .update({
          'titre': _titre,
          'description': _description,
        });
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conseilId == null
            ? 'Ajouter un Conseil'
            : 'Modifier le Conseil'),
      ),
      drawer: user != null ? CustomDrawer() : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _titre,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _titre = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAdvice,
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
