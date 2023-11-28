import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';

import '../home/home.dart';
import 'components/botao.dart';
import 'components/campoDeTexto.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _auth = FirebaseAuth.instance;
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _cadastrarUsuario() async {
    setState(() {
      _carregando = true;
    });

    try {
      // Validar se os campos de senha coincidem
      if (_senhaController.text != _confirmarSenhaController.text) {
        throw 'As senhas não coincidem';
      }

      // Criar usuário com email e senha
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // Verificar se o usuário foi criado com sucesso
      if (userCredential.user != null) {
        // Usuário criado com sucesso, você pode realizar ações adicionais aqui, se necessário.
        print('Usuário cadastrado com sucesso: ${userCredential.user!.uid}');

        // Após o cadastro, você pode redirecionar o usuário para outra tela
        // Exemplo: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NovaTela()));

        await userCredential.user!.updateProfile(
          displayName: _nomeController.text.trim() + ' ' + _sobrenomeController.text.trim(),
        );

        Navigator.push(
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

      }
    } on FirebaseAuthException catch (e) {
      // Tratamento de erros específicos do Firebase Auth
      print('Erro ao criar usuário: ${e.message}');
      // Mostrar mensagem de erro para o usuário
      _mostrarSnackBar('Erro ao criar usuário');
    } catch (e) {
      // Tratamento de outros erros
      print('Erro desconhecido: $e');
      _mostrarSnackBar('Erro desconhecido ao criar usuário');
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: Duration(seconds: 3),
      ),
    );
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Cadastro'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CampoTexto(
                hintText: 'Nome',
                prefixIcon: SvgPicture.asset("assets/icons/User.svg"),
                controller: _nomeController,
              ),
              CampoTexto(
                hintText: 'Sobrenome',
                prefixIcon: SvgPicture.asset("assets/icons/User.svg"),
                controller: _sobrenomeController,
              ),
              CampoTexto(
                hintText: 'Email',
                prefixIcon: SvgPicture.asset("assets/icons/email.svg"),
                controller: _emailController,
              ),
              CampoTexto(
                hintText: 'Senha',
                prefixIcon: SvgPicture.asset("assets/icons/password.svg"),
                obscureText: true,
                controller: _senhaController,
              ),
              CampoTexto(
                hintText: 'Confirmar Senha',
                prefixIcon: SvgPicture.asset("assets/icons/password.svg"),
                obscureText: true,
                controller: _confirmarSenhaController,
              ),
              SizedBox(height: 20),
              _carregando
                  ? CircularProgressIndicator()
                  : BotaoCustomizado(
                text: "Cadastrar",
                onPressed: _cadastrarUsuario,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
