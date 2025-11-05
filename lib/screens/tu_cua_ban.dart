import 'package:flutter/material.dart';
import 'chi_tiet.dart';
import 'flashcard.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/empty_state.dart';
import '../widgets/word_card.dart';

class TuCuaBan extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteWordsList;
  final Function(String) onSpeak;
  final Function(String) onToggleFavorite;
  final VoidCallback? onFavoritesChanged; // Callback để reload
  final Color themeColor;
  final bool isDarkMode;

  const TuCuaBan({
    super.key,
    required this.favoriteWordsList,
    required this.onSpeak,
    required this.onToggleFavorite,
    this.onFavoritesChanged,
    this.themeColor = Colors.deepPurple,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteWordsList.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.star_border,
        title: "no_favorites".tr(),
        iconColor: Colors.grey,
        iconSize: 80,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Header with review button
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "favorites".tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (favoriteWordsList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("no_words_to_review".tr())),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FlashcardScreen(words: favoriteWordsList),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text("review_all".tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List of favorite words
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF8E1), Color(0xFFFFFDE7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                itemCount: favoriteWordsList.length,
                itemBuilder: (context, index) {
                  final word = favoriteWordsList[index];
                  return WordCard(
                    word: word,
                    isFavorite: true, // Tất cả từ ở đây đều là favorite
                    themeColor: themeColor,
                    textColor: isDarkMode ? Colors.white : Colors.black87,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChiTiet(
                            word: word,
                            onFavoriteChanged: onFavoritesChanged,
                          ),
                        ),
                      );
                    },
                    onFavoriteToggle: () {
                      onToggleFavorite(word["english"]!);
                    },
                    onSpeak: () {
                      onSpeak(word["english"]!);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
