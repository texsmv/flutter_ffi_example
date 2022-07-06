import 'package:ffi_test/app/menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFI demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MenuView(),
    );
  }
}
