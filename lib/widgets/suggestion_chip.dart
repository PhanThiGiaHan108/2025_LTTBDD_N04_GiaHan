import 'package:flutter/material.dart';

/// Widget hiển thị chip gợi ý từ
/// Được sử dụng trong trang chủ để gợi ý các từ phổ biến
class SuggestionChip extends StatelessWidget {
  final String word;
  final Color themeColor;
  final VoidCallback onTap;

  const SuggestionChip({
    super.key,
    required this.word,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        word,
        style: TextStyle(color: themeColor, fontWeight: FontWeight.w500),
      ),
      backgroundColor: themeColor.withOpacity(0.1),
      side: BorderSide(color: themeColor.withOpacity(0.3), width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onPressed: onTap,
    );
  }
}
