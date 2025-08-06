import 'package:flutter/material.dart';
import 'package:usemebefore/widgets/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:usemebefore/widgets/Landing.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00A8CC))
      ),
        home: StreamBuilder(stream:
        FirebaseAuth.instance.authStateChanges(),
        builder: (ctx,snapshot){
          if(snapshot.hasData){
            return Landing();
          }
          return AuthScreen();
        }),
  ) );
}

