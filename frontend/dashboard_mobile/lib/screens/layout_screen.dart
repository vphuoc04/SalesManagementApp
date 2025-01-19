import 'package:flutter/material.dart';

// Screens
import 'package:dashboard_mobile/screens/dashboard_screen.dart';
import 'package:dashboard_mobile/screens/profile_screen.dart';

// Components
import 'package:dashboard_mobile/components/layout/custom_sidebar.dart';

class LayoutScreen extends StatefulWidget {
  final int? id;

  const LayoutScreen({super.key, required this.id});

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int selectedIndex = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = <Widget>[
      DashboardScreen(),
      ProfileScreen(),
    ];
  }

  void onSidebarItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          CustomSidebar(
            selectedIndex: selectedIndex,
            onItemTapped: onSidebarItemTapped,
          ),
          // Main content
          Expanded(
            child: screens[selectedIndex],
          ),
        ],
      ),
    );
  }
}