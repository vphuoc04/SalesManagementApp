import 'package:flutter/material.dart';

// Services
import 'package:dashboard_mobile/services/user_catalogues_service.dart';

// Constants
import 'package:dashboard_mobile/constants/colors.dart';

class UserCataloguesManagement extends StatefulWidget {
  @override
  _UserCataloguesManagementState createState() => _UserCataloguesManagementState();
}

class _UserCataloguesManagementState extends State<UserCataloguesManagement> {
  final UserCataloguesService userCataloguesService = UserCataloguesService();
  final TextEditingController nameController = TextEditingController();

  int publishStatus = 0;

  Future<void> addUserCatalogues() async {
    final name = nameController.text;

    if (name.isEmpty) {
      showError("Group name cannot be empty!");
      return;
    }

    try {
      final response = await userCataloguesService.add(name, publishStatus);

      if (response['success'] == true) {
        showSuccess("Group added successfully!");
      } else {
        showError(response['message'] ?? "Failed to add group");
      }
    } catch (error) {
      showError("Error: $error");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: errorColor));
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: myColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Group name"
              ),
            ),
            DropdownButton<int>(
              value: publishStatus,
              onChanged: (int? newValue) {
                setState(() {
                  publishStatus = newValue!;
                });
              },
              items: [
                DropdownMenuItem(value: 0, child: Text("Inactive")),
                DropdownMenuItem(value: 1, child: Text("Active")),
                DropdownMenuItem(value: 2, child: Text("Archived")),
              ],
            ),
            ElevatedButton(
              onPressed: addUserCatalogues, 
              child: Text("Add group")
            )
          ],
        ),
      ),
    );
  }
}