import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/frontend/dashboards/dashboard.dart';
import 'package:nexus_chats/backend/controllers/user_controller.dart';
import 'package:nexus_chats/frontend/components/animated_button.dart';
import 'package:nexus_chats/frontend/components/animated_text_field.dart';
import 'package:nexus_chats/frontend/components/animated_circle_avatar.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  final VoidCallback toggleAuthMode;
  const RegistrationPage({super.key, required this.toggleAuthMode});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  final List<TextEditingController> textEditingControllers =
      List.generate(4, (index) => TextEditingController());

  Uint8List? avatar;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in textEditingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void registerFunction() {
    final userController = ref.read(userControllerProvider);
    try {
      userController.registerUser(
        username: textEditingControllers[0].text,
        email: textEditingControllers[1].text,
        password: textEditingControllers[2].text,
        about: textEditingControllers[3].text,
        profile: avatar, // Pass the avatar bytes
      );

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ResponsiveDashboard()));
    } catch (e) {
      Scaffold.of(context)
          .showBottomSheet((context) => Text('An error ocurred $e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          AnimatedContainer(
            duration: const Duration(seconds: 4),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purpleAccent,
                  Colors.blueAccent,
                  Colors.tealAccent,
                ],
              ),
            ),
          ),

          // Registration form
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: AnimatedScale(
                scale: _scaleAnimation.value,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.blueAccent,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'montaga',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Avatar picker
                        AnimatedCircleAvatar(
                          onImagePicked: (Uint8List? image) {
                            avatar = image;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Input fields
                        AnimatedTextField(
                          label: "Full Name",
                          icon: Icons.person,
                          obscureText: false,
                          controller: textEditingControllers[0],
                        ),
                        AnimatedTextField(
                          label: "Email",
                          icon: Icons.email,
                          obscureText: false,
                          controller: textEditingControllers[1],
                        ),
                        AnimatedTextField(
                          label: "Password",
                          icon: Icons.lock,
                          obscureText: true,
                          controller: textEditingControllers[2],
                        ),
                        AnimatedTextField(
                          label: "About You",
                          icon: Icons.info,
                          obscureText: false,
                          controller: textEditingControllers[3],
                        ),
                        const SizedBox(height: 20),

                        // Register button
                        AnimatedButton(
                          onPressed: registerFunction,
                          displayText: "Register",
                          fontFamily: 'montaga',
                        ),

                        // Switch to login
                        TextButton(
                          onPressed: widget.toggleAuthMode,
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'pacifico',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
