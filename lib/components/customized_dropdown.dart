import 'package:flutter/material.dart';

class CustomizedDropdown extends StatefulWidget {
  final String hintText;
  final List<DropdownMenuItem<String>> items;
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustomizedDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.validator,
  });

  @override
  State<CustomizedDropdown> createState() => _CustomizedDropdownState();
}

class _CustomizedDropdownState extends State<CustomizedDropdown> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
        value: dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
          widget.onChanged(newValue);
        },
        decoration: InputDecoration(
            labelText: widget.hintText, border: InputBorder.none),
        icon: const SizedBox.shrink(),
        validator: widget.validator,
        items: widget.items);
        
  }
}
