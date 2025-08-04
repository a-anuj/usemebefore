import 'package:flutter/material.dart';
import 'package:usemebefore/widgets/Auth.dart';

void main() {
  runApp(
      MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00A8CC))
      ),
      home : AuthScreen(),
  ) );
}

