import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/frontend/pages/settings_page.dart';

class MobileDashboard extends ConsumerStatefulWidget {
  final List<Widget> pages;
  final List<Widget> bottomIcons;

  const MobileDashboard({
    super.key,
    required this.pages,
    required this.bottomIcons,
  });

  @override
  ConsumerState<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends ConsumerState<MobileDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurpleAccent, // Stylish app bar color
          elevation: 0,
          title: const Text(
            'Nexus Chats',
            style: TextStyle(
              fontFamily: 'montaga',
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Placeholder for notifications action
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                // Placeholder for settings action
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                            appBar: AppBar(
                                title: const Text("Settings",
                                    style: TextStyle(fontFamily: 'montaga'))),
                            body: const SettingsPage())));
              },
            ),
          ],
        ),
        extendBody: true, // For a more seamless bottom navigation
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: widget.pages[_currentIndex],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.deepPurpleAccent, // Vibrant color for navigation bar
          buttonBackgroundColor: Colors.amber, // Highlighted button
          items: widget.bottomIcons,
          height: 70, // Slightly taller for better visual hierarchy
          animationDuration: const Duration(milliseconds: 400),
          animationCurve: Curves.fastOutSlowIn, // Smooth animation curve
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}
