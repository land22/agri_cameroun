import 'package:flutter/material.dart';
import 'package:agri_cameroun/services/auth_service.dart'; // Assurez-vous de mettre le bon chemin

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Connexion réussie')));
        // Naviguer vers l'écran principal ou tableau de bord après la connexion
        Navigator.of(context).pushReplacementNamed(
            '/'); // lien de la page après login réussi !!!
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
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loginUser,
                child: Text('Se connecter'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      'register'); // Naviguer vers l'écran d'inscription
                },
                child: Text("Vous n'avez pas de compte? Inscrivez-vous!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
