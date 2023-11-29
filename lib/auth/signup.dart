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

  final _formKey = GlobalKey<FormState>();

  final _nomeFocusNode = FocusNode();
  final _sobrenomeFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _senhaFocusNode = FocusNode();
  final _confirmarSenhaFocusNode = FocusNode();

  void _focusNodeListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _nomeFocusNode.addListener(_focusNodeListener);
    _sobrenomeFocusNode.addListener(_focusNodeListener);
    _emailFocusNode.addListener(_focusNodeListener);
    _senhaFocusNode.addListener(_focusNodeListener);
    _confirmarSenhaFocusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _nomeFocusNode.removeListener(_focusNodeListener);
    _sobrenomeFocusNode.removeListener(_focusNodeListener);
    _emailFocusNode.removeListener(_focusNodeListener);
    _senhaFocusNode.removeListener(_focusNodeListener);
    _confirmarSenhaFocusNode.removeListener(_focusNodeListener);

    _nomeFocusNode.dispose();
    _sobrenomeFocusNode.dispose();
    _emailFocusNode.dispose();
    _senhaFocusNode.dispose();
    _confirmarSenhaFocusNode.dispose();

    super.dispose();
  }

  String? _nomeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _sobrenomeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (!value.contains('@')) {
      return 'Email inválido';
    }
    return null;
  }

  String? _senhaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _confirmarSenhaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value != _senhaController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  Future<void> _cadastrarUsuario() async {
    setState(() {
      _carregando = true;
    });

    try {
      if (_senhaController.text != _confirmarSenhaController.text) {
        throw 'As senhas não coincidem';
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      if (userCredential.user != null) {
        print('Usuário cadastrado com sucesso: ${userCredential.user!.uid}');

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
      print('Erro ao criar usuário: ${e.message}');
      _mostrarSnackBar('Erro ao criar usuário');
    } catch (e) {
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
              CampoTexto(
              hintText: 'Nome',
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              prefixIcon: SvgPicture.asset("assets/icons/User.svg"),
              controller: _nomeController,
              validator: _nomeValidator,
              errorText: _nomeValidator(_nomeController.text),
            ),
            CampoTexto(
              hintText: 'Sobrenome',
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              prefixIcon: SvgPicture.asset("assets/icons/User.svg"),
              controller: _sobrenomeController,
              validator: _sobrenomeValidator,
              errorText: _sobrenomeValidator(_sobrenomeController.text), // Mostra erro ao iniciar
            ),
            CampoTexto(
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: SvgPicture.asset("assets/icons/email.svg"),
              controller: _emailController,
              validator: _emailValidator,
              errorText: _emailValidator(_emailController.text), // Mostra erro ao iniciar
            ),
            CampoTexto(
              hintText: 'Senha',
              prefixIcon: SvgPicture.asset("assets/icons/password.svg"),
              obscureText: true,
              controller: _senhaController,
              validator: _senhaValidator,
              errorText: _senhaValidator(_senhaController.text), // Mostra erro ao iniciar
            ),
            CampoTexto(
              hintText: 'Confirmar Senha',
              prefixIcon: SvgPicture.asset("assets/icons/password.svg"),
              obscureText: true,
              controller: _confirmarSenhaController,
              validator: _confirmarSenhaValidator,
              errorText: _confirmarSenhaValidator(_confirmarSenhaController.text), // Mostra erro ao iniciar
            ),
            SizedBox(height: 20),
            _carregando
                ? CircularProgressIndicator()
                : BotaoCustomizado(
              text: "Cadastrar",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _cadastrarUsuario();
                }
              },
            ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
