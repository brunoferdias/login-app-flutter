import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:login_ui/auth/components/botao.dart';
import 'package:login_ui/auth/components/campoDeTexto.dart';
import 'package:login_ui/auth/signup.dart';
import 'package:login_ui/home/home.dart';
import 'dart:io' show Platform;

import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  bool carregandoDados = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final _emailFocusNode = FocusNode();
  final _senhaFocusNode = FocusNode();

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        return await _firebaseAuth.signInWithCredential(credential);
      }
    } catch (e) {
      print("Erro ao fazer login com o Google: $e");
    }
    return null;
  }

  login() async {

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Insira o email e a senha!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ));
    } else {
      setState(() {
        carregandoDados = true;
      });

      try {
        UserCredential userCredential =
            await _firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (userCredential != null) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              alignment: Alignment.center,
              child: Home(),
              isIos: true,
              duration: Duration(milliseconds: 1000),
              reverseDuration: Duration(milliseconds: 1000),
            ),
          );
          setState(() {
            carregandoDados = false;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          carregandoDados = false;
        });

        String errorMessage = 'Ocorreu um erro ao fazer login.';

        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Email não cadastrado!';
            break;
          case 'invalid-credential':
            errorMessage = 'Login ou senha incorretos!';
            break;
          case 'invalid-email':
            errorMessage = 'Email inválido!';
            break;
          case 'network-request-failed':
            errorMessage = 'Sem conexão de internet!';
            break;
        }
        print(e.code.toString());

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Animação
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Lottie.asset(
                          'assets/animacoes/loginanimation.json',
                          width: 220,
                          height: 220,
                          fit: BoxFit.fitWidth),
                    ),

                    //Email
                    CampoTexto(
                      hintText: 'Seu email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: SvgPicture.asset("assets/icons/email.svg"),
                      controller: _emailController,
                      onSaved: (email) {},
                    ),

                    //Senha
                    CampoTexto(
                      hintText: 'Sua senha',
                      prefixIcon: SvgPicture.asset("assets/icons/password.svg"),
                      obscureText: true,
                      controller: _passwordController,

                    ),

                    //Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),

                    //Entrar
                    carregandoDados
                        ? CircularProgressIndicator()
                        : BotaoCustomizado(
                            text: "Entrar",
                            onPressed: () {
                              print("entrar");
                              login();
                            },
                          ),

                    //Cadastrar
                    BotaoCustomizado(
                      text: "Cadastrar",
                      onPressed: () {
                        print("cadastrar");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                    ),

                    //Icones Google e Apple
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [


                        //Apple
                        Platform.isAndroid ? Container() : GestureDetector(
                            onTap: () async {
                              print("Entrar com Apple");

                              final credential =
                                  await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                              );

                              print(credential);
                            },
                            child: SvgPicture.asset(
                                "assets/icons/apple_box.svg",
                                width: 50)),




                        SizedBox(
                          width: 15,
                        ),


                        //Google
                        Platform.isIOS
                            ? Container()
                            : GestureDetector(
                                onTap: () async {
                                  print("Entrar com Google");

                                  UserCredential? userCredential =
                                      await _signInWithGoogle();
                                  if (userCredential != null) {
                                    print('Usuário logado com sucesso: ${userCredential.user!.displayName}');

                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        alignment: Alignment.center,
                                        child: Home(),
                                        isIos: true,
                                        duration: Duration(milliseconds: 1000),
                                        reverseDuration:
                                            Duration(milliseconds: 1000),
                                      ),
                                    );
                                  }
                                },
                                child: SvgPicture.asset(
                                    "assets/icons/google_box.svg",
                                    width: 50),
                              ),


                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
