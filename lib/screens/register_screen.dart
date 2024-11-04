import 'package:flutter/material.dart';
import 'package:agri_cameroun/services/auth_service.dart'; // Assurez-vous de mettre le bon chemin

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().signUpWithEmail(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Inscription réussie')));
        // Naviguer vers l'écran de connexion ou tableau de bord après l'inscription
        Navigator.of(context)
            .pop(); // Remplacez ceci par votre logique de navigation
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  } else if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('S\'inscrire'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      'login'); // Naviguer vers l'écran d'inscription
                },
                child: Text("Vous n'avez déjà un compte? login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
