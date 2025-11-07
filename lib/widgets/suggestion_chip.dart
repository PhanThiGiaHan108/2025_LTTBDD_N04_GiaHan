import 'package:flutter/material.dart';

/// Widget hiển thị chip gợi ý từ với hiệu ứng đẹp mắt
/// Được sử dụng trong trang chủ để gợi ý các từ phổ biến
class SuggestionChip extends StatefulWidget {
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
  State<SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<SuggestionChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ActionChip(
          label: Text(
            widget.word,
            style: TextStyle(
              color: widget.themeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: widget.themeColor.withOpacity(0.1),
          side: BorderSide(color: widget.themeColor.withOpacity(0.3), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          onPressed: widget.onTap,
          elevation: 2,
          shadowColor: widget.themeColor.withOpacity(0.3),
        ),
      ),
    );
  }
}
