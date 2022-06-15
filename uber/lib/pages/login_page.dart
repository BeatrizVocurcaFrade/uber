// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber/components/loading_widget.dart';
import '../models/local_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController(text: 'beatrizvocurcafrade@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '1234567');
  bool? _passwordVisible;
  String _errorMessage = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _checkIfUserIsLoggedIn();
  }
  _checkIfUserIsLoggedIn() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    if(user != null) {
      String type = await _getUserType(user.uid);
      _redirectUserByType(type);
    }

  }
  Future<String> _getUserType(String userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection('users').doc(userId).get();
    var data = snapshot.data();
    return (data as dynamic)['type'];
  }

  _redirectUserByType(String type) {
    switch (type) {
      case 'Motorista':
        Navigator.pushNamedAndRemoveUntil(
            context, '/panel-motorista', (_) => false);
        break;
      case 'Passageiro':
        Navigator.pushNamedAndRemoveUntil(
            context, '/panel-passageiro', (_) => false);
        break;
    }
  }

  _logInUser(LocalUser user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((value) async {
      String type = await _getUserType(value.user!.uid);
      _redirectUserByType(type);

      _loading = false;
    }).catchError((e) {
      _loading = false;
      _errorMessage = e.toString();
    });
    _errorMessage = '';
  }

  _validateInputs() {
     _loading = true;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && email.contains('@')) {
      if (password.isEmpty || password.length > 6) {
        _errorMessage = '';
        LocalUser user = LocalUser();
        user.email = email;
        user.password = password;
        _logInUser(user);
      } else {
        _errorMessage = 'Preencha a senha! digite mais de 6 caracteres';
      }
    } else {
      _errorMessage = 'Preencha o email corretamente';
    }

    setState(() {
      _errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 200,
                      ),
                    ),
                    _loading? LoadingWidget(): Container(),
                    Center(
                        child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    )),
                    const SizedBox(
                      height: 70,
                    ),
                    TextFormField(
                      controller: _emailController,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: _passwordVisible!,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible =
                                    (_passwordVisible == false) ? true : false;
                              });
                            },
                            icon: Icon(_passwordVisible == true
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/cadastro');
                            },
                            child: const Text('Não tem conta? Cadastre-se!'))),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _validateInputs();
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 20),
                        )),
                  ],
                ),
              ),
            ),
          );
  }
}
