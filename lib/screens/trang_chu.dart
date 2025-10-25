import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dang_nhap.dart';
import 've_chung_toi.dart';
import 'package:easy_localization/easy_localization.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  final FlutterTts tts = FlutterTts();
  int _selectedIndex = 0;

  // 📘 Danh sách từ mẫu
  final List<Map<String, String>> _words = [
    {
      "english": "Hello",
      "phonetic": "/həˈləʊ/",
      "type": "thán từ",
      "vietnamese": "Xin chào",
    },
    {
      "english": "Book",
      "phonetic": "/bʊk/",
      "type": "danh từ",
      "vietnamese": "Quyển sách",
    },
    {
      "english": "Apple",
      "phonetic": "/ˈæpl/",
      "type": "danh từ",
      "vietnamese": "Quả táo",
    },
    {
      "english": "Computer",
      "phonetic": "/kəmˈpjuːtə(r)/",
      "type": "danh từ",
      "vietnamese": "Máy tính",
    },
  ];

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

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      body: SafeArea(child: _buildBody(size)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
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

  Widget _buildBody(Size size) {
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
                decoration: InputDecoration(
                  hintText: "search".tr(),
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.deepPurple,
                  ),
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
                child: ListView.builder(
                  itemCount: _words.length,
                  itemBuilder: (context, index) {
                    final word = _words[index];
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
                                "Phiên âm: ${word["phonetic"]}",
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
                              icon: const Icon(
                                Icons.star_border,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Đã thêm '${word["english"]}' vào yêu thích!",
                                    ),
                                  ),
                                );
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
      return Center(
        child: Text(
          "no_favorites".tr(),
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    // ⚙️ Trang "Cài đặt"
    // ⚙️ Trang "Cài đặt"
    else {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "settings".tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // 🌐 Chuyển ngôn ngữ
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.language, color: Colors.deepPurple),
                  const SizedBox(width: 10),
                  const Text(
                    "Ngôn ngữ:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<Locale>(
                    value: context.locale,
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        context.setLocale(newLocale);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: Locale('vi'),
                        child: Text('Tiếng Việt'),
                      ),
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 🧑‍💻 Nút xem thông tin nhóm
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VeChungToi()),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: Text("about".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🚪 Nút đăng xuất
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DangNhap()),
                  );
                },
                icon: const Icon(Icons.logout),
                label: Text("logout".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
