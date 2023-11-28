import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_ui/auth/login.dart'; // Substitua com o caminho correto para a sua tela de login

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
      );
    } catch (e) {
      print("Erro ao fazer logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    String nome = user?.displayName ?? '';

    List<String> nomeSobrenome = nome.split(' ');
    String nomeUsuario = nomeSobrenome.isNotEmpty ? nomeSobrenome[0] : '';
    String sobrenomeUsuario =
    nomeSobrenome.length > 1 ? nomeSobrenome[1] : '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Login App"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text("Deslogar"),
            ),
            SizedBox(height: 20),
            Text(
              "Nome: $nomeUsuario\nSobrenome: $sobrenomeUsuario",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text("15 Pessoas já cadastraram login nesse app"),
          ],
        ),
      ),
    );
  }
}
