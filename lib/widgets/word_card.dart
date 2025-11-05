import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Widget hiển thị thẻ từ vựng
/// Được sử dụng trong trang_chu.dart và tu_cua_ban.dart
class WordCard extends StatelessWidget {
  final Map<String, dynamic> word;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onSpeak;
  final Color themeColor;
  final Color textColor;
  final bool isDarkMode;

  const WordCard({
    super.key,
    required this.word,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onSpeak,
    required this.themeColor,
    required this.textColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Nội dung từ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Từ tiếng Anh
                    Text(
                      word["english"]!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Phiên âm
                    Text(
                      word["phonetic"]!,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Nghĩa tiếng Việt
                    Text(
                      word["vietnamese"]!,
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Action buttons
              Column(
                children: [
                  // Nút phát âm
                  IconButton(
                    icon: Icon(Icons.volume_up, color: themeColor, size: 28),
                    onPressed: onSpeak,
                    tooltip: "speak".tr(),
                  ),
                  const SizedBox(height: 8),
                  // Nút yêu thích
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.amber : Colors.grey,
                      size: 28,
                    ),
                    onPressed: onFavoriteToggle,
                    tooltip: isFavorite
                        ? "remove_favorite".tr()
                        : "add_favorite".tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
