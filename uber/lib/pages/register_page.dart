import 'package:flutter/material.dart';
import '../components/loading_widget.dart';
import '../models/local_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Beatriz Vocurca Frade');
  final TextEditingController _emailController =
      TextEditingController(text: 'beatrizvocurcafrade@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '1234567');
  bool? _passwordVisible;
  bool? isPassenger = true;
  bool _loading = false;
  String _errorMessage = '';
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  _validateInputs() {
    _loading = true;
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (name.isNotEmpty) {
      if (email.isNotEmpty && email.contains('@')) {
        if (password.isEmpty || password.length > 6) {
          _errorMessage = '';
          LocalUser user = LocalUser();
          user.email = email;
          user.name = name;
          user.password = password;
          user.type = isPassenger! ? 'Passageiro' : 'Motorista';
          _registerUser(user);
        } else {
          _errorMessage = 'Preencha a senha! digite mais de 6 caracteres';
        }
      } else {
        _errorMessage = 'Preencha o email corretamente';
      }
    } else {
      _errorMessage = 'Preencha o nome';
    }

    setState(() {
      _errorMessage;
    });
  }

  _registerUser(LocalUser user) {
    //  Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseFirestore db = FirebaseFirestore.instance;
    auth
        .createUserWithEmailAndPassword(
            email: user.email!, password: user.password)
        .then((fUser) {
      _loading = false;
      db.collection('users').doc(fUser.user!.uid).set(user.toMap());
      user.id = fUser.user!.uid;
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }).catchError((e) {
      _loading = false;
      setState(() {
        _errorMessage = e.toString();
      });
    });
    _errorMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                    child: Text("Cadastro",
                        style: Theme.of(context).textTheme.headline2)),
                const SizedBox(
                  height: 30,
                ),
                _loading ? const LoadingWidget() : Container(),
                Center(
                    child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                )),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autofocus: true,
                  controller: _emailController,
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
                    labelText: 'password',
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
                Row(
                  children: [
                    const Text('Motorista'),
                    Switch(
                      value: isPassenger!,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          isPassenger = value;
                        });
                      },
                    ),
                    const Text('Passageiro'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _validateInputs();
                    },
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
