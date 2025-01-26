import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nexus_chats/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/frontend/widgets/theme.dart';
import 'package:nexus_chats/frontend/pages/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: NexusChats()));
}

class NexusChats extends StatelessWidget {
  const NexusChats({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nexus Chats',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const LandingPage(),
    );
  }
}
