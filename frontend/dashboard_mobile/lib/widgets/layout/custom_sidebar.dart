import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:dashboard_mobile/constants/colors.dart';

class CustomSidebar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _CustomSidebarState createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  bool isExpanded = false;

  void handleItemTap(int index) {
    setState(() {
      widget.onItemTapped(index);
      isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 300 : 50,
      color: isExpanded ? myColor : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          IconButton(
            icon: Icon(
              isExpanded ? Icons.arrow_back_ios : Icons.menu,
              color: isExpanded ? Colors.white : myColor,
            ),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          SidebarItem(
            icon: IconlyLight.chart,
            label: 'Dashboard',
            isSelected: widget.selectedIndex == 0,
            onTap: () => handleItemTap(0),
            isExpanded: isExpanded, 
          ),
          SidebarItem(
            icon: IconlyLight.profile,
            label: 'Profile',
            isSelected: widget.selectedIndex == 1,
            onTap: () => handleItemTap(1),
            isExpanded: isExpanded, 
          ),
        ]
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isExpanded;

  const SidebarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isExpanded ? 280 : 0.05, 
              height: 50,
              decoration: BoxDecoration(
                color: isSelected && isExpanded ? Colors.white : Colors.transparent, 
                borderRadius: isSelected && isExpanded ? BorderRadius.circular(20) : BorderRadius.zero,
              ),
              padding: EdgeInsets.symmetric(horizontal: isExpanded ? 10 : 1), 
              child: Row(
                children: [
                  if (isExpanded) ...[
                    Icon(
                      icon,
                      color: isSelected && isExpanded ? myColor : Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded( 
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected && isExpanded ? myColor : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
