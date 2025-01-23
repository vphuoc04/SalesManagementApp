import 'package:flutter/material.dart';

// Services
import 'package:dashboard_mobile/services/user_catalogues_service.dart';

// Constants
import 'package:dashboard_mobile/constants/colors.dart';

// Models
import 'package:dashboard_mobile/models/user_catalogues.dart';

// Widgets
import 'package:dashboard_mobile/widgets/loading_widget.dart';

class UserCataloguesManagement extends StatefulWidget {
  @override
  _UserCataloguesManagementState createState() =>
      _UserCataloguesManagementState();
}

class _UserCataloguesManagementState extends State<UserCataloguesManagement> {
  final UserCataloguesService userCataloguesService = UserCataloguesService();
  final TextEditingController nameController = TextEditingController();

  int publishStatus = 0;
  int? currentGroupId;
  List<UserCatalogues> userCataloguesList = [];
  bool isLoading = false; 

  @override
  void initState() {
    super.initState();
    loadUserCatalogues();
  }

  // Load data user catalogues
  Future<void> loadUserCatalogues() async {
    setState(() {
      isLoading = true; 
    });
    try {
      final groups = await userCataloguesService.getAll();
      setState(() {
        userCataloguesList = groups;
      });
    } catch (error) {
      showError("Error loading groups: $error");
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  void onGroupTap(UserCatalogues group) {
    setEditGroup(group.id, group.name, group.publish);
  }

  void setEditGroup(int id, String name, int publish) {
    setState(() {
      currentGroupId = id;
      nameController.text = name;
      publishStatus = publish;
    });
  }

  // Add user catalogues
  Future<void> addUserCatalogues() async {
    final name = nameController.text;

    if (name.isEmpty) {
      showError("Group name cannot be empty!");
      return;
    }

    setState(() {
      isLoading = true; 
    });

    try {
      final response = await userCataloguesService.add(name, publishStatus);

      if (response['success'] == true) {
        showSuccess("Group added successfully!");
        clearInputs();
        await loadUserCatalogues();
      } else {
        showError(response['message'] ?? "Failed to add group");
      }
    } catch (error) {
      showError("Error: $error");
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  // Update user catalogues
  Future<void> updateUserCatalogues() async {
    if (currentGroupId == null) {
      showError("No group selected for update!");
      return;
    }

    final name = nameController.text;
    if (name.isEmpty) {
      showError("Group name cannot be empty!");
      return;
    }

    setState(() {
      isLoading = true; 
    });

    try {
      final response = await userCataloguesService.update(
        currentGroupId!,
        name,
        publishStatus,
      );

      if (response['success'] == true) {
        showSuccess("Group updated successfully!");
        clearInputs();
        await loadUserCatalogues();
      } else {
        showError(response['message'] ?? "Failed to update group");
      }
    } catch (error) {
      showError("Error: $error");
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  void clearInputs() {
    setState(() {
      currentGroupId = null;
      nameController.clear();
      publishStatus = 0;
    });
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: errorColor,
      ),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: myColor,
      ),
    );
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
              decoration: InputDecoration(labelText: "Group name"),
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
              onPressed: () {
                if (currentGroupId == null) {
                  addUserCatalogues();
                } else {
                  updateUserCatalogues();
                }
              },
              child: Text(currentGroupId == null ? "Add group" : "Update group"),
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child: LoadingWidget(color: myColor), 
                    )
                  : ListView.builder(
                      itemCount: userCataloguesList.length,
                      itemBuilder: (context, index) {
                        final group = userCataloguesList[index];
                        return ListTile(
                          title: Text(group.name),
                          subtitle: Text(group.publish == 1 ? "Active" : group.publish == 0 ? "Inactive" : "Archived"),
                          onTap: () => onGroupTap(group),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
