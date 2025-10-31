import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math';

class FlashcardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> words;

  const FlashcardScreen({super.key, required this.words});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final FlutterTts tts = FlutterTts();
  int _currentIndex = 0;
  bool _showVietnamese = false;
  List<Map<String, dynamic>> _shuffledWords = [];

  @override
  void initState() {
    super.initState();
    _shuffleWords();
  }

  void _shuffleWords() {
    _shuffledWords = List.from(widget.words);
    _shuffledWords.shuffle(Random());
  }

  void _nextCard() {
    setState(() {
      if (_currentIndex < _shuffledWords.length - 1) {
        _currentIndex++;
        _showVietnamese = false;
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _previousCard() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _showVietnamese = false;
      }
    });
  }

  void _flipCard() {
    setState(() {
      _showVietnamese = !_showVietnamese;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("flashcard_complete".tr()),
        content: Text("flashcard_complete_message".tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("exit".tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _showVietnamese = false;
                _shuffleWords();
              });
            },
            child: Text("restart".tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    if (_shuffledWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("flashcard".tr()),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Text(
            "no_words_to_review".tr(),
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    final currentWord = _shuffledWords[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("flashcard".tr()),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              setState(() {
                _shuffleWords();
                _currentIndex = 0;
                _showVietnamese = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("cards_shuffled".tr()),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFFDE7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${"card".tr()} ${_currentIndex + 1} / ${_shuffledWords.length}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _shuffledWords.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30),

              // Flashcard
              Expanded(
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Container(
                      key: ValueKey(_showVietnamese),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _showVietnamese
                              ? [Colors.green[300]!, Colors.green[100]!]
                              : [Colors.blue[300]!, Colors.blue[100]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!_showVietnamese) ...[
                                // English side
                                Text(
                                  currentWord["english"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  currentWord["phonetic"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    currentWord["type"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                IconButton(
                                  onPressed: () =>
                                      _speak(currentWord["english"]!),
                                  icon: const Icon(
                                    Icons.volume_up,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ] else ...[
                                // Vietnamese side
                                Text(
                                  currentWord["vietnamese"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30),
                                if (currentWord["examples"] != null &&
                                    (currentWord["examples"] as List)
                                        .isNotEmpty) ...[
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "example".tr(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          (currentWord["examples"][0]["en"] ??
                                              ""),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          (currentWord["examples"][0]["vi"] ??
                                              ""),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white70,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                              const SizedBox(height: 40),
                              Text(
                                "tap_to_flip".tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _currentIndex > 0 ? _previousCard : null,
                    icon: const Icon(Icons.arrow_back),
                    label: Text("previous".tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _nextCard,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(
                      _currentIndex < _shuffledWords.length - 1
                          ? "next".tr()
                          : "finish".tr(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
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
