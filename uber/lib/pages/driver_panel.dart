import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverPanel extends StatefulWidget {
  const DriverPanel({Key? key}) : super(key: key);

  @override
  State<DriverPanel> createState() => _DriverPanelState();
}

_logOutUser() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();
}

class _DriverPanelState extends State<DriverPanel> {
  List<String> menuItens = ['Configurações', 'Deslogar'];

  _selectMenuItem(String item) {
    switch (item) {
      case 'Configurações':
        break;
      case 'Deslogar':
        _logOutUser();
        Navigator.pushReplacementNamed(context, '/');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('panel motorista'),
        actions: [
          PopupMenuButton(
              onSelected: _selectMenuItem,
              itemBuilder: (_) => menuItens
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList()),
        ],
      ),
    );
  }
}
