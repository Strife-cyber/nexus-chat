import 'package:flutter/material.dart';
import 'package:nexus_chats/frontend/components/animated_button.dart';
import 'package:nexus_chats/frontend/pages/auth_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient with theme colors
          AnimatedContainer(
            duration: const Duration(seconds: 4),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  Colors.deepPurple,
                  Colors.black,
                ],
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated icon with theme accent
                AnimatedScale(
                  scale: _animation.value,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple,
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 90,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Title
                const Text(
                  'Nexus Chats',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "pacifico",
                    letterSpacing: 3,
                    shadows: [
                      Shadow(
                        color: Colors.deepPurple,
                        offset: Offset(0, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Subtitle
                const Text(
                  'Bringing Calm to Conversations.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: "pacifico",
                  ),
                ),
                const SizedBox(height: 40),
                // Action button
                AnimatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthPage()));
                    },
                    displayText: 'Enter Chat',
                    fontFamily: 'pacifico',
                    seconds: 2)
              ],
            ),
          ),
          // Floating animated decorations
          Positioned.fill(
            child: Stack(
              children: List.generate(10, (index) {
                final randomX = (index + 1) * 20.0;
                final randomY = (index + 1) * 40.0;
                return AnimatedPositioned(
                  duration: const Duration(seconds: 5),
                  left: randomX * _animation.value,
                  top: randomY * _animation.value,
                  child: CircleAvatar(
                    radius: 5 + index.toDouble(),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
