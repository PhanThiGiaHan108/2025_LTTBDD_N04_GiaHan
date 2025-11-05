import 'package:flutter/material.dart';

/// Widget hiển thị trạng thái empty với icon và message
/// Được sử dụng khi không có dữ liệu hoặc không có kết quả tìm kiếm
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final List<Color>? gradientColors;
  final Widget? actionButton;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = Colors.grey,
    this.gradientColors,
    this.actionButton,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon với gradient background (nếu có)
            if (gradientColors != null)
              Container(
                width: iconSize + 40,
                height: iconSize + 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors!,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: iconSize, color: iconColor),
              )
            else
              Icon(icon, size: iconSize, color: iconColor),
            const SizedBox(height: 24),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            // Subtitle (nếu có)
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.color?.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            // Action button (nếu có)
            if (actionButton != null) ...[
              const SizedBox(height: 24),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}
