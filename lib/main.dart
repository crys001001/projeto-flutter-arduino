import 'package:flutter/material.dart';
import 'package:flutter_application/src/auth/sign_in_screen.dart';
import 'package:flutter_application/src/pages_routes/app_pages.dart';
import 'package:flutter_application/src/services/user_controller.dart';
import 'package:get/get.dart';

void main() {
  // Registra o UserController globalmente para usar em toda a app
  Get.put(UserController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Presence+',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SignInScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: PagesRoutes.signInRoute,
      getPages: AppPages.pages,
    );
  }
}
