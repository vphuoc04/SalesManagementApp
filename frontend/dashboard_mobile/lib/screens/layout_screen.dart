import 'package:flutter/material.dart';

// Screens
import 'package:dashboard_mobile/screens/dashboard_screen.dart';

// Components
import 'package:dashboard_mobile/widgets/layout/custom_navigation_bar.dart';

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
      DashboardScreen()
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: screens[selectedIndex]
          )
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}