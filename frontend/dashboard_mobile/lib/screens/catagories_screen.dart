import 'package:flutter/material.dart';

// Components
import 'package:dashboard_mobile/components/categories/user_catalogues_management.dart';

class ManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Management Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserCataloguesManagement()),
                );
              },
              child: Text("Manage User Catalogues"),
            ),
          ],
        ),
      ),
    );
  }
}
