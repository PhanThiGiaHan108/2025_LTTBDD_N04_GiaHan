import 'package:flutter/material.dart';
import 'chi_tiet.dart';
import 'flashcard.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoritesTab extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteWordsList;
  final Function(String) onSpeak;
  final Function(String) onToggleFavorite;

  const FavoritesTab({
    super.key,
    required this.favoriteWordsList,
    required this.onSpeak,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteWordsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_border, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              "no_favorites".tr(),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
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
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChiTiet(word: word),
                          ),
                        );
                      },
                      title: Text(
                        word["english"] ?? "",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${'phonetic_label'.tr()} ${word['phonetic']}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                word["type"] ?? "",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              word["vietnamese"] ?? "",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.star, color: Colors.orange),
                            onPressed: () {
                              onToggleFavorite(word["english"]!);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () => onSpeak(word["english"]!),
                          ),
                        ],
                      ),
                    ),
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
