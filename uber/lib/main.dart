import 'package:flutter/material.dart';
import 'package:uber/routes.dart';
void main() async {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}

// class App extends StatelessWidget {
//   const App({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Erro'),
//             ),
//           );
//         }

//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           return MaterialApp(
//             title: 'Uber',
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               brightness: Brightness.dark,
//               primarySwatch: Colors.blue,
//             ),
//             initialRoute: '/',
//             onGenerateRoute: Routes.generateRoutes,
//           );
//         }

//         // Otherwise, show something whilst waiting for initialization to complete

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Carregando'),
//           ),
//         );
//       },
//     );
//   }
// }
