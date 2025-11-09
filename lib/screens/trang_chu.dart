import 'tu_cua_ban.dart';
import 'cai_dat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'chi_tiet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/empty_state.dart';
import '../widgets/suggestion_chip.dart';
import '../data/word.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  final FlutterTts tts = FlutterTts();
  int _selectedIndex = 0;
  Set<String> _favoriteWords = {}; // Store favorite word IDs (english names)
  List<String> _searchHistory = []; // Store search history
  String _searchQuery = ""; // Search query
  final TextEditingController _searchController = TextEditingController();

  // Settings
  bool _isDarkMode = false;
  int _themeColorIndex = 0; // 0=deepPurple, 1=blue, 2=green, 3=orange, 4=pink

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadSettings();
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_words') ?? [];
    setState(() {
      _favoriteWords = favorites.toSet();
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _themeColorIndex = prefs.getInt('theme_color') ?? 0;
    });
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
  }

  void _addToSearchHistory(String word) {
    if (word.isEmpty) return;

    setState(() {
      // Xóa từ cũ nếu đã tồn tại
      _searchHistory.remove(word);
      // Thêm vào đầu danh sách
      _searchHistory.insert(0, word);
      // Giới hạn 20 từ gần nhất
      if (_searchHistory.length > 20) {
        _searchHistory = _searchHistory.sublist(0, 20);
      }
    });
    _saveSearchHistory();
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
    _saveSearchHistory();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setInt('theme_color', _themeColorIndex);
  }

  Color _getThemeColor() {
    switch (_themeColorIndex) {
      case 0:
        return Colors.deepPurple;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.pink;
      default:
        return Colors.deepPurple;
    }
  }

  // Removed _getThemeColorName (unused after UI simplification)

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_words', _favoriteWords.toList());
  }

  void _toggleFavorite(String wordEnglish) {
    setState(() {
      if (_favoriteWords.contains(wordEnglish)) {
        _favoriteWords.remove(wordEnglish);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'removed_from_favorites'.tr(namedArgs: {"word": wordEnglish}),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        _favoriteWords.add(wordEnglish);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'added_to_favorites'.tr(namedArgs: {"word": wordEnglish}),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
    _saveFavorites();
  }

  bool _isFavorite(String wordEnglish) {
    return _favoriteWords.contains(wordEnglish);
  }

  List<Map<String, dynamic>> _getFilteredWords() {
    if (_searchQuery.isEmpty) {
      return [];
    }

    final query = _searchQuery.toLowerCase().trim();

    // Bước 1: Tìm các từ khớp trực tiếp
    List<Map<String, dynamic>> directMatches = wordList.where((word) {
      final english = (word['english'] ?? '').toString().toLowerCase();
      final vietnamese = (word['vietnamese'] ?? '').toString().toLowerCase();
      final phonetic = (word['phonetic'] ?? '').toString().toLowerCase();

      return english.contains(query) ||
          vietnamese.contains(query) ||
          phonetic.contains(query);
    }).toList();

    // Bước 2: Nếu tìm bằng tiếng Việt, tìm thêm các từ đồng nghĩa
    Set<String> allRelatedWords = {};
    List<Map<String, dynamic>> relatedWords = [];

    for (var word in directMatches) {
      allRelatedWords.add(word['english'].toString());

      // Lấy danh sách synonyms của từ này
      if (word['synonyms'] != null && word['synonyms'] is List) {
        for (var synonym in word['synonyms']) {
          allRelatedWords.add(synonym.toString());
        }
      }
    }

    // Bước 3: Tìm tất cả các từ trong danh sách từ đồng nghĩa
    for (var word in wordList) {
      if (allRelatedWords.contains(word['english'].toString())) {
        if (!relatedWords.any((w) => w['english'] == word['english'])) {
          relatedWords.add(word);
        }
      }
    }

    // Trả về kết quả: nếu có từ đồng nghĩa thì trả về cả nhóm, không thì trả về kết quả tìm trực tiếp
    return relatedWords.isNotEmpty ? relatedWords : directMatches;
  }

  Future<void> _speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.speak(text);
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để responsive
    final size = MediaQuery.of(context).size;
    final themeColor = _getThemeColor();
    final bgColor = _isDarkMode
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFFFFDE7);
    final cardColor = _isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(child: _buildBody(size, themeColor, cardColor, textColor)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: _isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home".tr()),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "favorites".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "settings".tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    Size size,
    Color themeColor,
    Color cardColor,
    Color textColor,
  ) {
    // 📄 Trang chủ
    if (_selectedIndex == 0) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔍 Thanh tìm kiếm
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 11, 2, 2).withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "search".tr(),
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.deepPurple,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = "";
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // 📚 Danh sách từ
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFF8E1), Color(0xFFFFFDE7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Builder(
                  builder: (context) {
                    final filteredWords = _getFilteredWords();

                    // Nếu không tìm kiếm gì và có lịch sử -> hiển thị lịch sử
                    if (_searchQuery.isEmpty && _searchHistory.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header lịch sử
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "history_title".tr(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: themeColor,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          "clear_history_confirm_title".tr(),
                                        ),
                                        content: Text(
                                          "clear_history_confirm_message".tr(),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("cancel".tr()),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _clearSearchHistory();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "history_cleared".tr(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "delete".tr(),
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_sweep,
                                    size: 18,
                                  ),
                                  label: Text("clear_history".tr()),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Danh sách lịch sử
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              itemCount: _searchHistory.length,
                              itemBuilder: (context, index) {
                                final wordEnglish = _searchHistory[index];
                                final word = wordList.firstWhere(
                                  (w) => w['english'] == wordEnglish,
                                  orElse: () => {},
                                );

                                if (word.isEmpty)
                                  return const SizedBox.shrink();

                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: Duration(
                                    milliseconds: 300 + (index * 30),
                                  ),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: Opacity(
                                        opacity: value,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: themeColor.withOpacity(
                                          0.1,
                                        ),
                                        child: Icon(
                                          Icons.history,
                                          color: themeColor,
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(
                                        word['english'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        word['vietnamese'] ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textColor.withOpacity(0.7),
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.volume_up,
                                              color: themeColor,
                                              size: 22,
                                            ),
                                            onPressed: () =>
                                                _speak(word['english']!),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              _isFavorite(word['english']!)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color:
                                                  _isFavorite(word['english']!)
                                                  ? Colors.amber
                                                  : Colors.grey,
                                              size: 22,
                                            ),
                                            onPressed: () => _toggleFavorite(
                                              word['english']!,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        _addToSearchHistory(word['english']!);
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ChiTiet(
                                              word: word,
                                              onFavoriteChanged: () {
                                                _loadFavorites();
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    if (filteredWords.isEmpty) {
                      // Hiển thị thông báo khác nhau tùy theo có đang tìm kiếm hay không
                      if (_searchQuery.isEmpty) {
                        // Chưa nhập gì và CHƯA CÓ lịch sử -> hiển thị lời nhắc tìm kiếm
                        return EmptyStateWidget(
                          icon: Icons.search,
                          title: "search_prompt".tr(),
                          subtitle: "search_hint".tr(),
                          iconColor: themeColor,
                          gradientColors: [
                            themeColor.withOpacity(0.2),
                            themeColor.withOpacity(0.1),
                          ],
                          iconSize: 60,
                          actionButton: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "popular_words".tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: [
                                  SuggestionChip(
                                    word: 'Hello',
                                    themeColor: themeColor,
                                    onTap: () {
                                      setState(() {
                                        _searchController.text = 'Hello';
                                        _searchQuery = 'Hello';
                                      });
                                    },
                                  ),
                                  SuggestionChip(
                                    word: 'Book',
                                    themeColor: themeColor,
                                    onTap: () {
                                      setState(() {
                                        _searchController.text = 'Book';
                                        _searchQuery = 'Book';
                                      });
                                    },
                                  ),
                                  SuggestionChip(
                                    word: 'Happy',
                                    themeColor: themeColor,
                                    onTap: () {
                                      setState(() {
                                        _searchController.text = 'Happy';
                                        _searchQuery = 'Happy';
                                      });
                                    },
                                  ),
                                  SuggestionChip(
                                    word: 'Learn',
                                    themeColor: themeColor,
                                    onTap: () {
                                      setState(() {
                                        _searchController.text = 'Learn';
                                        _searchQuery = 'Learn';
                                      });
                                    },
                                  ),
                                  SuggestionChip(
                                    word: 'Beautiful',
                                    themeColor: themeColor,
                                    onTap: () {
                                      setState(() {
                                        _searchController.text = 'Beautiful';
                                        _searchQuery = 'Beautiful';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ); // Đóng EmptyStateWidget
                      } else {
                        // Đã nhập nhưng không có kết quả
                        return EmptyStateWidget(
                          icon: Icons.search_off,
                          title: "no_results".tr(),
                          subtitle: "no_results_hint".tr(
                            namedArgs: {"query": _searchQuery},
                          ),
                          iconColor: Colors.orange,
                          gradientColors: [
                            Colors.orange.withOpacity(0.2),
                            Colors.orange.withOpacity(0.1),
                          ],
                          iconSize: 60,
                          actionButton: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = "";
                              });
                            },
                            icon: const Icon(Icons.clear),
                            label: Text("clear_search".tr()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        );
                      }
                    }

                    return ListView.builder(
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: Dismissible(
                            key: Key(word["english"]!),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("confirm_delete".tr()),
                                    content: Text(
                                      "confirm_delete_message".tr(
                                        namedArgs: {"word": word["english"]!},
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text("cancel".tr()),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          "delete".tr(),
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) {
                              setState(() {
                                wordList.removeWhere(
                                  (w) => w["english"] == word["english"],
                                );
                                _favoriteWords.remove(word["english"]);
                              });
                              _saveFavorites();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "word_deleted".tr(
                                      namedArgs: {"word": word["english"]!},
                                    ),
                                  ),
                                  action: SnackBarAction(
                                    label: "undo".tr(),
                                    onPressed: () {
                                      setState(() {
                                        wordList.insert(index, word);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Card(
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
                                onTap: () async {
                                  // Thêm vào lịch sử tra từ
                                  _addToSearchHistory(word["english"]!);

                                  // show a short confirmation then navigate to details
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('opening_details'.tr()),
                                    ),
                                  );
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChiTiet(
                                        word: word,
                                        onFavoriteChanged: () {
                                          // Reload favorites khi có thay đổi
                                          _loadFavorites();
                                        },
                                      ),
                                    ),
                                  );

                                  // Nếu người dùng click vào từ đồng nghĩa, tự động tìm kiếm từ đó
                                  if (result != null && result is String) {
                                    setState(() {
                                      _searchQuery = result;
                                      _searchController.text = result;
                                      _selectedIndex =
                                          0; // Chuyển về tab Trang chủ
                                    });
                                  }
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                      icon: Icon(
                                        _isFavorite(word["english"]!)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () {
                                        _toggleFavorite(word["english"]!);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.volume_up,
                                        color: Colors.deepPurple,
                                      ),
                                      onPressed: () => _speak(word["english"]!),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
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
    // ⭐ Trang "Từ của bạn"
    else if (_selectedIndex == 1) {
      final favoriteWordsList = wordList
          .where((word) => _favoriteWords.contains(word["english"]))
          .toList();
      return TuCuaBan(
        favoriteWordsList: favoriteWordsList,
        onSpeak: _speak,
        onToggleFavorite: _toggleFavorite,
        themeColor: _getThemeColor(),
        isDarkMode: _isDarkMode,
        onFavoritesChanged: () {
          _loadFavorites();
        },
      );
    }
    // ⚙️ Trang "Cài đặt"
    else {
      // index 2
      return CaiDat(
        isDarkMode: _isDarkMode,
        themeColor: _getThemeColor(),
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
          _saveSettings();
        },
        onThemeColorChanged: (color) {
          setState(() {
            final colorList = [
              Colors.deepPurple,
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.pink,
            ];
            _themeColorIndex = colorList.indexWhere(
              (c) => c.value == color.value,
            );
          });
          _saveSettings();
        },
        onLocaleChanged: (locale) {
          context.setLocale(locale);
        },
        currentLocale: context.locale,
      );
    }
  }

  // Widget helper cho suggestion chips
  // Removed _buildColorButton helper (handled within settings widget)
}
