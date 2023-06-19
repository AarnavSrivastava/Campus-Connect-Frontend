import 'package:school_networking_project/pages/main_screen.dart';
import 'package:school_networking_project/pages/login_screen.dart';

var appRoutes = {
  '/': (context) => const AuthGate(),
  '/login': (context) => const LoginScreen(),
};
