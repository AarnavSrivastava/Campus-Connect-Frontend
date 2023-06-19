import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../firebase/auth_firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            baseColor: Theme.of(context).primaryColor,
            spawnOpacity: 0.0,
            opacityChangeRate: 0.25,
            minOpacity: 0.1,
            maxOpacity: 0.4,
            particleCount: 70,
            spawnMaxRadius: 7.0,
            spawnMaxSpeed: 100.0,
            spawnMinSpeed: 30,
            spawnMinRadius: 2.0,
          ),
        ),
        vsync: this,
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                FontAwesomeIcons.graduationCap,
                size: 150,
              ),
              Text(
                "CampusConnect",
                textAlign: TextAlign.center,
                style: GoogleFonts.abel(
                  fontSize: 48,
                ),
              ),
              Flexible(
                child: LoginButton(
                  text: 'Sign in with Google',
                  icon: FontAwesomeIcons.google,
                  color: Theme.of(context).primaryColor,
                  loginMethod: AuthService().googleLogin,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.loginMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
        ),
        onPressed: () {
          loginMethod();
        },
        label: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
