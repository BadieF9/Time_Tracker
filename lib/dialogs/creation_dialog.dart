import 'package:flutter/material.dart';

class CreationDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController projectNameController = TextEditingController();
  final String title;
  final String content;
  final void Function(GlobalKey<FormState>, String) onConfirm;
  final VoidCallback onCancel;
  final String? validationErrorMessage;

  CreationDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.onConfirm,
      required this.onCancel,
      this.validationErrorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: projectNameController,
          decoration: InputDecoration(labelText: content),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validationErrorMessage ?? 'Please enter a value';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => onConfirm(_formKey, projectNameController.text),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
