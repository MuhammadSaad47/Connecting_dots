import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (icon == null) {
      child = ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      );
    } else {
      child = ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }

    if (!isExpanded) return child;

    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }
}
