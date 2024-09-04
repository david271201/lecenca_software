import 'package:flutter/material.dart';
import 'package:licenca_app/App_imbel_crip/tela/encryption_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
      ),
      home: EncryptionScreen(),
    );
  }
}

// AP31.240617.003
// vlf+LyAgn1Qga0qEHCwydw==
