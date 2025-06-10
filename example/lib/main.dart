import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:konnek_flutter/konnek_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await KonnekFlutter.initKonnek(
    inputClientId: 'your-client-id',
    inputClientSecret: 'your-client-secret',
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LiveChatSdkScreen(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Konnek Example App'),
          ),
          body: Center(
            child: Text('Your screen'),
          ),
        ),
      ),
    );
  }
}
