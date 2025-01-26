import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/frontend/components/animated_button.dart';
import 'package:nexus_chats/frontend/providers.dart';
import 'package:nexus_chats/frontend/utilities/fetch_profile.dart';

class DesktopDashboard extends ConsumerStatefulWidget {
  final List<Widget> pages;
  final List<IconData> sidebarIcons;
  final List<String> sidebarLabels;

  const DesktopDashboard({
    super.key,
    required this.pages,
    required this.sidebarIcons,
    required this.sidebarLabels,
  });

  @override
  ConsumerState<DesktopDashboard> createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends ConsumerState<DesktopDashboard> {
  int _currentIndex = 0;
  Uint8List? profile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchImage();
  }

  void fetchImage() async {
    final user = ref.watch(userProvider);
    if (user?.profileLink != null) {
      profile = await fetchProfile(ref, user!.profileLink!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.sidebarLabels[_currentIndex],
          style: const TextStyle(fontFamily: 'montaga', color: Colors.white70),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      drawer: Drawer(
        child: _buildSidebar(),
      ),
      body: widget.pages[_currentIndex],
    );
  }

  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar Header
        DrawerHeader(
          decoration: const BoxDecoration(color: Colors.deepPurpleAccent),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: profile != null ? MemoryImage(profile!) : null,
                child: profile == null
                    ? const Icon(Icons.person, color: Colors.deepPurple)
                    : null,
              ),
              const SizedBox(width: 12),
              const Text(
                'Nexus Chats',
                style: TextStyle(
                  fontFamily: 'montaga',
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Divider(color: Colors.grey, thickness: 1.0),
        // Sidebar Menu Items
        Expanded(
          child: ListView.builder(
            itemCount: widget.sidebarIcons.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  widget.sidebarIcons[index],
                  color: _currentIndex == index
                      ? Colors.deepPurpleAccent
                      : Colors.black54,
                ),
                title: Text(
                  widget.sidebarLabels[index],
                  style: TextStyle(
                    color: _currentIndex == index
                        ? Colors.deepPurpleAccent
                        : Colors.black87,
                    fontFamily: 'montaga',
                  ),
                ),
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                  });
                  Navigator.of(context).pop(); // Close the drawer
                },
              );
            },
          ),
        ),
        // Logout Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedButton(
              onPressed: () {}, displayText: 'Log Out', fontFamily: 'montaga'),
        ),
      ],
    );
  }
}
