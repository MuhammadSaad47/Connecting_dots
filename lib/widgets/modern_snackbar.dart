import 'package:flutter/material.dart';

class ModernSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor ?? _getSuccessColor(),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        margin: const EdgeInsets.only(
          top: 50,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  static void success(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: _getSuccessColor(),
      icon: Icons.check_circle,
    );
  }

  static void error(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: _getErrorColor(),
      icon: Icons.error,
    );
  }

  static void info(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: _getInfoColor(),
      icon: Icons.info,
    );
  }

  static Color _getSuccessColor() => const Color(0xFF10B981); // Green
  static Color _getErrorColor() => const Color(0xFFEF4444);   // Red
  static Color _getInfoColor() => const Color(0xFF3B82F6);    // Blue
}
