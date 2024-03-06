import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cocofapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cocofapp/modules/menu/menu.dart';
import 'package:cocofapp/modules/views/coir_in.dart';
import 'package:cocofapp/modules/views/coir_out.dart';
import 'package:cocofapp/modules/views/payments.dart';
import 'package:cocofapp/modules/views/salary.dart';
import 'package:cocofapp/modules/login/login.dart';

const apiKey = 'AIzaSyCqKk3e7YzakTJmhWaCsXuP9qxtAY8jTLE';
const projectId = 'cocofapp';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  //
  // // This is the last thing you need to add.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firestore.initialize(projectId);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(),
      initialRoute: 'login_screen',
      routes: {
        'menu_screen': (context) => const Menu(),
        'login_screen': (context) => const LoginScreen(),
        'coir_in_screen': (context) => const CoirInputs(),
        'coir_out_screen': (context) => const CoirOutputs(),
        'salary_screen': (context) => const Salary(),
        'pay_screen': (context) => const Payments(),
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}