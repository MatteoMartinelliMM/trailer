import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trailer/change_modulo_widget.dart';
import 'package:trailer/change_player_widget.dart';
import 'package:trailer/modulo_pick_widget.dart';
import 'package:trailer/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      theme: FakeFootballDashboardTheme(context).mainTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? ChangePlayerWidget() : ChangeModuloWidget();
  }
}
