import 'package:flutter/material.dart';
import 'package:time_tracker/dialogs/delete_confirmation_dialog.dart';

// Generic Dismissible List Item Component
class DismissibleListItem extends StatelessWidget {
  final Key itemKey;
  final Widget child;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;
  final void Function(DismissDirection)? onDismissed;
  final Widget? background;
  final Widget? secondaryBackground;

  const DismissibleListItem({
    super.key,
    required this.itemKey,
    required this.child,
    this.confirmDismiss,
    this.onDismissed,
    this.background,
    this.secondaryBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: itemKey,
      confirmDismiss: confirmDismiss ??
          (DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd ||
                direction == DismissDirection.endToStart) {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteConfirmationDialog(
                      title: 'Confirm Delete',
                      content: 'Are you sure you want to delete this item?',
                      onConfirm: () => Navigator.of(context).pop(true),
                      onCancel: () => Navigator.of(context).pop(false));
                },
              );
            }
            return null;
          },
      onDismissed: onDismissed,
      background: background ??
          Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
      secondaryBackground: secondaryBackground ??
          Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
      child: child,
    );
  }
}
