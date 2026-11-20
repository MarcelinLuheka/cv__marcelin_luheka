import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const CVMarcelinApp());
}

class CVMarcelinApp extends StatelessWidget {
  const CVMarcelinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'CV Marcelin Luheka',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: AppColors.background,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),

        fontFamily: 'Roboto',
      ),

      home: const LoginPage(),
    );
  }
}