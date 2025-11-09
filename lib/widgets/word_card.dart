import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Được sử dụng trong trang_chu.dart và tu_cua_ban.dart
class WordCard extends StatefulWidget {
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
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              elevation: _isHovered ? 8 : 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: widget.isDarkMode ? Colors.grey[850] : Colors.white,
              child: child,
            ),
          );
        },
        child: InkWell(
          onTap: widget.onTap,
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
                        widget.word["english"]!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Phiên âm
                      Text(
                        widget.word["phonetic"]!,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.textColor.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Nghĩa tiếng Việt
                      Text(
                        widget.word["vietnamese"]!,
                        style: TextStyle(fontSize: 16, color: widget.textColor),
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
                      icon: Icon(
                        Icons.volume_up,
                        color: widget.themeColor,
                        size: 28,
                      ),
                      onPressed: widget.onSpeak,
                      tooltip: "speak".tr(),
                    ),
                    const SizedBox(height: 8),
                    // Nút yêu thích
                    IconButton(
                      icon: Icon(
                        widget.isFavorite ? Icons.star : Icons.star_border,
                        color: widget.isFavorite ? Colors.amber : Colors.grey,
                        size: 28,
                      ),
                      onPressed: widget.onFavoriteToggle,
                      tooltip: widget.isFavorite
                          ? "remove_favorite".tr()
                          : "add_favorite".tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
