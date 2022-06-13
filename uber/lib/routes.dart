import 'package:flutter/material.dart';
import 'package:uber/pages/driver_painel.dart';
import 'package:uber/pages/login_page.dart';
import 'package:uber/pages/passanger_painel.dart';
import 'package:uber/pages/register_page.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/cadastro':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/painel-passageiro':
        return MaterialPageRoute(builder: (_) => const PassengerPainel());
      case '/painel-motorista':
        return MaterialPageRoute(builder: (_) => const DriverPainel());

      default:
        return _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Tela não encontrada')),
            ));
  }
}
