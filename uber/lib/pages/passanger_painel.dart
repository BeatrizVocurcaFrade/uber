import 'package:flutter/material.dart';
class PassengerPainel extends StatefulWidget {
  const PassengerPainel({Key? key}) : super(key: key);

  @override
  State<PassengerPainel> createState() => _PassengerPainelState();
}

class _PassengerPainelState extends State<PassengerPainel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Painel passageiro')),);
  }
}