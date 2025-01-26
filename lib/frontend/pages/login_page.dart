import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/backend/controllers/user_controller.dart';
import 'package:nexus_chats/frontend/components/animated_button.dart';
import 'package:nexus_chats/frontend/components/animated_text_field.dart';
import 'package:nexus_chats/frontend/dashboards/dashboard.dart';

class SimpleLoginPage extends ConsumerStatefulWidget {
  final VoidCallback toggleAuthMode;

  const SimpleLoginPage({super.key, required this.toggleAuthMode});

  @override
  ConsumerState<SimpleLoginPage> createState() => _SimpleLoginPageState();
}

class _SimpleLoginPageState extends ConsumerState<SimpleLoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginFunction() async {
    final userController = ref.read(userControllerProvider);

    if (await userController.logIn(
        email: emailController.text, password: passwordController.text)) {
      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ResponsiveDashboard()));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Login unsuccessful. Please check your credentials.',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'pacifico', // Ensure font is added correctly.
              ),
            ),
            backgroundColor: Colors.red[300],
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple, Colors.deepPurpleAccent],
                ),
              ),
            ),
          ),
          // Login Form
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'montaga',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Login to continue',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontFamily: 'pacifico'),
                      ),
                      const SizedBox(height: 20),

                      // Email Input
                      AnimatedTextField(
                        label: 'Email',
                        icon: Icons.email,
                        controller: emailController,
                        obscureText: false,
                      ),

                      // Password Input
                      AnimatedTextField(
                        label: 'Password',
                        icon: Icons.lock,
                        controller: passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      AnimatedButton(
                          onPressed: loginFunction,
                          displayText: 'Log In',
                          fontFamily: 'montaga',
                          width: MediaQuery.of(context).size.width * 0.75),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: widget.toggleAuthMode,
                        child: const Text(
                          "Don't have an account? Register",
                          style: TextStyle(
                              color: Colors.white70, fontFamily: 'pacifico'),
                        ),
                      ),
                    ],
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
