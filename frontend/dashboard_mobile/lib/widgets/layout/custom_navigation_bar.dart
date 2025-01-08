import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:dashboard_mobile/constants/colors.dart';

class CustomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final double iconSize; 

  const CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.iconSize = 27.0, 
  }) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory
      ), 
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          indicatorColor: Colors.transparent,
        ), 
        child: Container(
          height: 50,
          child: NavigationBar(
            selectedIndex: widget.selectedIndex,
            onDestinationSelected: widget.onItemTapped,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  widget.selectedIndex == 0 ? IconlyBold.chart : IconlyLight.chart,
                  color: widget.selectedIndex == 0
                      ? myColor
                      : baseColor
                  ,
                ),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(
                  widget.selectedIndex == 1 ? IconlyBold.profile : IconlyLight.profile,
                  color: widget.selectedIndex == 1
                      ? myColor
                      : baseColor
                ), 
                label: ''
              )
            ]
          ),
        )
      )
    );
  }
}