import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:futuropdv/auth/auth_wrapper.dart';
import 'package:futuropdv/backend/services/push_notification_service.dart';
import 'package:futuropdv/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuturoPDV',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
    );
  }
}
