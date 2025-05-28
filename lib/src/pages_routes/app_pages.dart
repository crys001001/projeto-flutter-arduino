import 'package:flutter_application/src/auth/sign_in_screen.dart';
import 'package:flutter_application/src/auth/sign_up_screen.dart';
import 'package:flutter_application/src/base/base_screen.dart';
import 'package:flutter_application/src/pages/audit_screen.dart'; // <-- ADICIONE ISSO
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(page: () => SignInScreen(), name: PagesRoutes.signInRoute),
    GetPage(page: () => SignUpScreen(), name: PagesRoutes.signUpRoute),
    GetPage(page: () => BaseScreen(), name: PagesRoutes.BaseRoute),
    GetPage(
      page: () => AuditScreen(),
      name: PagesRoutes.auditRoute,
    ), // <-- ADICIONE ESTA LINHA
  ];
}

abstract class PagesRoutes {
  static const String signInRoute = '/signin';
  static const String signUpRoute = '/signup';
  static const String BaseRoute = '/baseScreen';
  static const String auditRoute = '/audit'; // <-- JÁ EXISTIA, MANTENHA
}
