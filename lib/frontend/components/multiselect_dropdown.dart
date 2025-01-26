import 'package:flutter/material.dart';
import 'package:nexus_chats/backend/models/users.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<Users?> options;
  final List<Users?> selectedItems;
  final Function(Users?) onSelected;

  const MultiSelectDropdown({
    super.key,
    required this.options,
    required this.selectedItems,
    required this.onSelected,
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Select Members',
        labelStyle: TextStyle(fontFamily: 'pacifico'),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Users?>(
          hint: const Text("Select a user",
              style: TextStyle(fontFamily: 'montaga')),
          value: null,
          onChanged: (Users? user) {
            if (user != null && !widget.selectedItems.contains(user)) {
              widget.onSelected(user);
            }
          },
          items: widget.options.map<DropdownMenuItem<Users?>>((Users? user) {
            return DropdownMenuItem<Users?>(
              value: user,
              child: Text(user!.username),
            );
          }).toList(),
        ),
      ),
    );
  }
}
