import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gbxyrgzzebeidqtvkhmd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdieHlyZ3p6ZWJlaWRxdHZraG1kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU1NzkwODEsImV4cCI6MjA5MTE1NTA4MX0.e_QzayFJ0lidgrjk-Vem9hLVHHaODFhdHvPHVmevuI8',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nalo Chat',
      debugShowCheckedModeBanner: false, // Enlève le bandeau "DEBUG" en haut
      // 🎨 Thème violet inspiré du design
      theme: ThemeData(
        colorSchemeSeed: NaloColors.primary,
        useMaterial3: true,
        scaffoldBackgroundColor: NaloColors.background,
      ),
      home: const AuthGate(),
    );
  }
}

// 🚪 AuthGate : décide quel écran afficher
// - Pas connecté → WelcomeScreen (avec animation) → puis LoginScreen
// - Connecté → HomeScreen (liste de conversations)
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: NaloColors.background,
            body: const Center(
              child: CircularProgressIndicator(color: NaloColors.accent),
            ),
          );
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const HomeScreen();
        } else {
          // 🎬 Écran de bienvenue avec animation au lieu du login direct
          return const WelcomeScreen();
        }
      },
    );
  }
}
