import 'package:flutter/material.dart';
import 'package:socials/data/model/user.dart';
import 'package:socials/domain/repository/user_repository.dart';

class EditProfileDialog extends StatelessWidget {
  final User user;
  final Function(User user) onSave;

  EditProfileDialog({required this.user, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController nameController =
        TextEditingController(text: user.name);
    final TextEditingController descriptionController =
        TextEditingController(text: user.description);
    final UserRepository userRepository = UserRepository();
    return AlertDialog(
      title: Text('Edit Profile', style: TextStyle(color: theme.colorScheme.primary),),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            subtitle: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(
                        color: theme.colorScheme.primary, fontSize: 20),
                    labelText: 'Name')),
          ),
          ListTile(
            subtitle: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(
                        color: theme.colorScheme.primary, fontSize: 20),
                    labelText: 'Description')),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () => {
            user.name = nameController.text,
            user.description = descriptionController.text,
            userRepository.updateUser(user),
            onSave(user),
            Navigator.of(context).pop()
          },
        ),
      ],
    );
  }
}
