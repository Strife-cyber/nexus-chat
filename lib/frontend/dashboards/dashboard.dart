import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/frontend/pages/chat_page.dart';
import 'package:nexus_chats/frontend/pages/settings_page.dart';
import 'package:nexus_chats/frontend/dashboards/desktop_dashboard.dart';
import 'package:nexus_chats/frontend/dashboards/mobile_dashboard.dart';

class ResponsiveDashboard extends ConsumerWidget {
  final List<Widget> mobilePages = [
    const ChatPage(),
    const Center(child: Text('Status')),
    const Center(child: Text('Shorts')),
  ];

  final List<Widget> desktopPages = [
    const ChatPage(),
    const Center(child: Text('Status')),
    const Center(child: Text('Shorts')),
    const Center(child: Text('Notifications')),
    const SettingsPage()
  ];

  ResponsiveDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          // Render Mobile Layout
          return MobileDashboard(
            pages: mobilePages,
            bottomIcons: const [
              Icon(Icons.chat_bubble, color: Colors.white),
              Icon(Icons.timeline, color: Colors.white),
              Icon(Icons.play_circle, color: Colors.white),
            ],
          );
        } else {
          // Render Desktop Layout
          return DesktopDashboard(
            pages: desktopPages,
            sidebarIcons: const [
              Icons.chat_bubble,
              Icons.timeline,
              Icons.play_circle,
              Icons.notifications,
              Icons.settings
            ],
            sidebarLabels: const [
              'Chats',
              'Status',
              'Shorts',
              'Notifications',
              'Settings'
            ],
          );
        }
      },
    );
  }
}
