import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChiTiet extends StatefulWidget {
  final Map<String, dynamic> word;

  const ChiTiet({super.key, required this.word});

  @override
  State<ChiTiet> createState() => _ChiTietState();
}

class _ChiTietState extends State<ChiTiet> {
  final FlutterTts tts = FlutterTts();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_words') ?? [];
    setState(() {
      _isFavorite = favorites.contains(widget.word["english"]);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_words') ?? [];

    setState(() {
      if (_isFavorite) {
        favorites.remove(widget.word["english"]);
        _isFavorite = false;
      } else {
        favorites.add(widget.word["english"]!);
        _isFavorite = true;
      }
    });

    await prefs.setStringList('favorite_words', favorites);
  }

  Future<void> _speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;

    // safe reads
    final List<dynamic>? examples = (word['examples'] is List)
        ? word['examples'] as List<dynamic>
        : null;
    final List<dynamic>? idioms = (word['idioms'] is List)
        ? word['idioms'] as List<dynamic>
        : null;
    final List<dynamic>? synonyms = (word['synonyms'] is List)
        ? word['synonyms'] as List<dynamic>
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFF00),
        elevation: 0,
        title: Text(
          word["english"] ?? "",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: Colors.deepPurple),
            onPressed: () => _speak(word["english"]!),
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: Colors.orange,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word["english"] ?? "",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 8),
            if ((word["phonetic"] ?? "").isNotEmpty) ...[
              Text(
                word["phonetic"] ?? "",
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 8),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                word["type"] ?? "",
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),

            // 🇻🇳 Nghĩa tiếng Việt
            if ((word["vietnamese"] ?? "").isNotEmpty) ...[
              Text(
                word["vietnamese"] ?? "",
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 20),
            ],

            // 📖 Ví dụ
            if (examples != null && examples.isNotEmpty) ...[
              const Text(
                "Ví dụ:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              for (final e in examples)
                if (e is Map && e['en'] != null)
                  _example(e['en'].toString(), e['vi']?.toString() ?? ''),

              const SizedBox(height: 20),
            ],

            // 🧩 Thành ngữ và cụm từ
            if (idioms != null && idioms.isNotEmpty) ...[
              const Text(
                "Thành ngữ & Cụm từ:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              for (final it in idioms)
                if (it is Map && it['en'] != null)
                  _example(it['en'].toString(), it['vi']?.toString() ?? ''),

              const SizedBox(height: 20),
            ],

            // 💬 Từ đồng nghĩa
            if (synonyms != null && synonyms.isNotEmpty) ...[
              const Text(
                "Từ đồng nghĩa:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final s in synonyms)
                    if (s != null) Chip(label: Text(s.toString())),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _example(String en, String vi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• $en",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(vi, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
