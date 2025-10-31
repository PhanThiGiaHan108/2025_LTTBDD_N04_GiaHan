import 'tu_cua_ban.dart';
import 'cai_dat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'chi_tiet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  final FlutterTts tts = FlutterTts();
  int _selectedIndex = 0;
  Set<String> _favoriteWords = {}; // Store favorite word IDs (english names)
  String _searchQuery = ""; // Search query
  final TextEditingController _searchController = TextEditingController();

  // Settings
  bool _isDarkMode = false;
  double _fontSize = 1.0; // 0.8 = nhỏ, 1.0 = vừa, 1.2 = lớn
  int _themeColorIndex = 0; // 0=deepPurple, 1=blue, 2=green, 3=orange, 4=pink

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadSettings();
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
      _fontSize = prefs.getDouble('font_size') ?? 1.0;
      _themeColorIndex = prefs.getInt('theme_color') ?? 0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setDouble('font_size', _fontSize);
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

  String _getThemeColorName() {
    switch (_themeColorIndex) {
      case 0:
        return "theme_purple".tr();
      case 1:
        return "theme_blue".tr();
      case 2:
        return "theme_green".tr();
      case 3:
        return "theme_orange".tr();
      case 4:
        return "theme_pink".tr();
      default:
        return "theme_purple".tr();
    }
  }

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
      return _words;
    }

    final query = _searchQuery.toLowerCase();
    return _words.where((word) {
      final english = (word['english'] ?? '').toString().toLowerCase();
      final vietnamese = (word['vietnamese'] ?? '').toString().toLowerCase();
      final phonetic = (word['phonetic'] ?? '').toString().toLowerCase();

      return english.contains(query) ||
          vietnamese.contains(query) ||
          phonetic.contains(query);
    }).toList();
  }

  // 📘 Danh sách từ mẫu
  final List<Map<String, dynamic>> _words = [
    {
      "english": "Hello",
      "phonetic": "/həˈləʊ/",
      "type": "thán từ",
      "vietnamese": "Xin chào",
      "examples": [
        {"en": "Hello, how are you?", "vi": "Xin chào, bạn khỏe không?"},
        {
          "en": "He said hello to everyone.",
          "vi": "Anh ấy chào tất cả mọi người.",
        },
      ],
      "idioms": [
        {"en": "Say hello to somebody", "vi": "Gửi lời chào tới ai đó"},
      ],
      "synonyms": ["Hi", "Hey", "Greetings"],
    },
    {
      "english": "Book",
      "phonetic": "/bʊk/",
      "type": "danh từ",
      "vietnamese": "Quyển sách",
      "examples": [
        {
          "en": "I borrowed a new book from the library.",
          "vi": "Tôi mượn một quyển sách mới từ thư viện.",
        },
        {
          "en": "This book is very interesting.",
          "vi": "Quyển sách này rất thú vị.",
        },
      ],
      "idioms": [
        {"en": "By the book", "vi": "Theo đúng quy trình"},
      ],
      "synonyms": ["Volume", "Tome", "Publication"],
    },
    {
      "english": "Apple",
      "phonetic": "/ˈæpl/",
      "type": "danh từ",
      "vietnamese": "Quả táo",
      "examples": [
        {
          "en": "She ate an apple for breakfast.",
          "vi": "Cô ấy ăn một quả táo cho bữa sáng.",
        },
      ],
      "idioms": [
        {"en": "The apple of one's eye", "vi": "Người yêu quý nhất"},
      ],
      "synonyms": ["Pome", "Fruit"],
    },
    {
      "english": "Computer",
      "phonetic": "/kəmˈpjuːtə(r)/",
      "type": "danh từ",
      "vietnamese": "Máy tính",
      "examples": [
        {
          "en": "She works on her computer all day.",
          "vi": "Cô ấy làm việc trên máy tính suốt cả ngày.",
        },
      ],
      "idioms": [
        {"en": "Computer-savvy", "vi": "Thạo máy tính"},
      ],
      "synonyms": ["PC", "Machine", "Processor"],
    },
    {
      "english": "Beautiful",
      "phonetic": "/ˈbjuːtɪfl/",
      "type": "tính từ",
      "vietnamese": "Đẹp",
      "examples": [
        {"en": "She has beautiful eyes.", "vi": "Cô ấy có đôi mắt đẹp."},
        {"en": "What a beautiful day!", "vi": "Thật là một ngày đẹp trời!"},
      ],
      "idioms": [
        {
          "en": "Beauty is in the eye of the beholder",
          "vi": "Cái đẹp là do người nhìn",
        },
      ],
      "synonyms": ["Pretty", "Gorgeous", "Lovely"],
    },
    {
      "english": "Happy",
      "phonetic": "/ˈhæpi/",
      "type": "tính từ",
      "vietnamese": "Vui vẻ, hạnh phúc",
      "examples": [
        {"en": "I'm so happy to see you!", "vi": "Tôi rất vui được gặp bạn!"},
        {
          "en": "They lived happily ever after.",
          "vi": "Họ sống hạnh phúc mãi mãi.",
        },
      ],
      "idioms": [
        {"en": "Happy as a clam", "vi": "Vui như con chim"},
      ],
      "synonyms": ["Joyful", "Cheerful", "Delighted"],
    },
    {
      "english": "Water",
      "phonetic": "/ˈwɔːtə(r)/",
      "type": "danh từ",
      "vietnamese": "Nước",
      "examples": [
        {"en": "I need a glass of water.", "vi": "Tôi cần một ly nước."},
        {
          "en": "Water is essential for life.",
          "vi": "Nước là cần thiết cho sự sống.",
        },
      ],
      "idioms": [
        {"en": "Water under the bridge", "vi": "Chuyện đã qua rồi"},
      ],
      "synonyms": ["H2O", "Liquid"],
    },
    {
      "english": "Friend",
      "phonetic": "/frend/",
      "type": "danh từ",
      "vietnamese": "Bạn bè",
      "examples": [
        {
          "en": "She is my best friend.",
          "vi": "Cô ấy là bạn thân nhất của tôi.",
        },
        {
          "en": "A friend in need is a friend indeed.",
          "vi": "Bạn giúp lúc hoạn nạn mới là bạn thực sự.",
        },
      ],
      "idioms": [
        {"en": "Make friends with someone", "vi": "Kết bạn với ai đó"},
      ],
      "synonyms": ["Buddy", "Pal", "Companion"],
    },
    {
      "english": "House",
      "phonetic": "/haʊs/",
      "type": "danh từ",
      "vietnamese": "Ngôi nhà",
      "examples": [
        {"en": "They bought a new house.", "vi": "Họ đã mua một ngôi nhà mới."},
        {"en": "Welcome to my house!", "vi": "Chào mừng đến nhà tôi!"},
      ],
      "idioms": [
        {"en": "Feel at home", "vi": "Cảm thấy thoải mái như ở nhà"},
      ],
      "synonyms": ["Home", "Residence", "Dwelling"],
    },
    {
      "english": "Love",
      "phonetic": "/lʌv/",
      "type": "danh từ",
      "vietnamese": "Tình yêu",
      "examples": [
        {
          "en": "Love makes the world go round.",
          "vi": "Tình yêu làm cho thế giới quay tròn.",
        },
        {"en": "I love you.", "vi": "Anh yêu em."},
      ],
      "idioms": [
        {"en": "Love at first sight", "vi": "Tình yêu sét đánh"},
      ],
      "synonyms": ["Affection", "Adoration", "Devotion"],
    },
    {
      "english": "Study",
      "phonetic": "/ˈstʌdi/",
      "type": "động từ",
      "vietnamese": "Học, nghiên cứu",
      "examples": [
        {
          "en": "I study English every day.",
          "vi": "Tôi học tiếng Anh mỗi ngày.",
        },
        {"en": "She studies at university.", "vi": "Cô ấy học ở đại học."},
      ],
      "idioms": [
        {"en": "Hit the books", "vi": "Chăm chỉ học hành"},
      ],
      "synonyms": ["Learn", "Research", "Examine"],
    },
    {
      "english": "Food",
      "phonetic": "/fuːd/",
      "type": "danh từ",
      "vietnamese": "Thức ăn",
      "examples": [
        {"en": "The food here is delicious.", "vi": "Đồ ăn ở đây rất ngon."},
        {
          "en": "We need to buy some food.",
          "vi": "Chúng ta cần mua một ít thức ăn.",
        },
      ],
      "idioms": [
        {"en": "Food for thought", "vi": "Điều đáng suy ngẫm"},
      ],
      "synonyms": ["Meal", "Cuisine", "Dish"],
    },
    {
      "english": "Work",
      "phonetic": "/wɜːk/",
      "type": "động từ",
      "vietnamese": "Làm việc",
      "examples": [
        {"en": "I work at a hospital.", "vi": "Tôi làm việc ở bệnh viện."},
        {
          "en": "Hard work pays off.",
          "vi": "Làm việc chăm chỉ sẽ được đền đáp.",
        },
      ],
      "idioms": [
        {"en": "Work like a charm", "vi": "Hiệu quả tuyệt vời"},
      ],
      "synonyms": ["Labor", "Employment", "Job"],
    },
    {
      "english": "School",
      "phonetic": "/skuːl/",
      "type": "danh từ",
      "vietnamese": "Trường học",
      "examples": [
        {"en": "My children go to school.", "vi": "Con tôi đi học."},
        {
          "en": "School starts at 8 AM.",
          "vi": "Trường học bắt đầu lúc 8 giờ sáng.",
        },
      ],
      "idioms": [
        {"en": "Old school", "vi": "Lối cũ, truyền thống"},
      ],
      "synonyms": ["Academy", "Institution", "College"],
    },
    {
      "english": "Time",
      "phonetic": "/taɪm/",
      "type": "danh từ",
      "vietnamese": "Thời gian",
      "examples": [
        {
          "en": "Time flies when you're having fun.",
          "vi": "Thời gian trôi nhanh khi bạn vui vẻ.",
        },
        {"en": "What time is it?", "vi": "Mấy giờ rồi?"},
      ],
      "idioms": [
        {"en": "Time is money", "vi": "Thời gian là vàng bạc"},
      ],
      "synonyms": ["Period", "Moment", "Duration"],
    },
    {
      "english": "Cat",
      "phonetic": "/kæt/",
      "type": "danh từ",
      "vietnamese": "Con mèo",
      "examples": [
        {"en": "My cat is sleeping.", "vi": "Con mèo của tôi đang ngủ."},
        {"en": "Cats are very independent.", "vi": "Mèo rất độc lập."},
      ],
      "idioms": [
        {"en": "Let the cat out of the bag", "vi": "Vô tình tiết lộ bí mật"},
      ],
      "synonyms": ["Feline", "Kitty"],
    },
    {
      "english": "Dog",
      "phonetic": "/dɒɡ/",
      "type": "danh từ",
      "vietnamese": "Con chó",
      "examples": [
        {"en": "Dogs are loyal animals.", "vi": "Chó là động vật trung thành."},
        {
          "en": "I walk my dog every morning.",
          "vi": "Tôi dắt chó đi dạo mỗi sáng.",
        },
      ],
      "idioms": [
        {"en": "Every dog has its day", "vi": "Ai cũng có lúc thành công"},
      ],
      "synonyms": ["Canine", "Puppy", "Hound"],
    },
    {
      "english": "Money",
      "phonetic": "/ˈmʌni/",
      "type": "danh từ",
      "vietnamese": "Tiền",
      "examples": [
        {
          "en": "Money can't buy happiness.",
          "vi": "Tiền không mua được hạnh phúc.",
        },
        {"en": "I need to save money.", "vi": "Tôi cần tiết kiệm tiền."},
      ],
      "idioms": [
        {"en": "Money talks", "vi": "Có tiền mua tiên cũng được"},
      ],
      "synonyms": ["Cash", "Currency", "Funds"],
    },
    {
      "english": "Family",
      "phonetic": "/ˈfæməli/",
      "type": "danh từ",
      "vietnamese": "Gia đình",
      "examples": [
        {"en": "Family is everything.", "vi": "Gia đình là tất cả."},
        {
          "en": "I spend time with my family on weekends.",
          "vi": "Tôi dành thời gian cho gia đình vào cuối tuần.",
        },
      ],
      "idioms": [
        {
          "en": "Blood is thicker than water",
          "vi": "Một giọt máu đào hơn ao nước lã",
        },
      ],
      "synonyms": ["Relatives", "Kin", "Household"],
    },
    {
      "english": "Car",
      "phonetic": "/kɑː(r)/",
      "type": "danh từ",
      "vietnamese": "Ô tô, xe hơi",
      "examples": [
        {"en": "I bought a new car.", "vi": "Tôi đã mua một chiếc xe mới."},
        {"en": "She drives her car to work.", "vi": "Cô ấy lái xe đi làm."},
      ],
      "idioms": [
        {"en": "In the driver's seat", "vi": "Nắm quyền kiểm soát"},
      ],
      "synonyms": ["Vehicle", "Automobile", "Auto"],
    },
    {
      "english": "Phone",
      "phonetic": "/fəʊn/",
      "type": "danh từ",
      "vietnamese": "Điện thoại",
      "examples": [
        {"en": "My phone is ringing.", "vi": "Điện thoại của tôi đang reo."},
        {
          "en": "Can I use your phone?",
          "vi": "Tôi có thể dùng điện thoại của bạn được không?",
        },
      ],
      "idioms": [
        {"en": "On the phone", "vi": "Đang nói chuyện điện thoại"},
      ],
      "synonyms": ["Telephone", "Mobile", "Cellphone"],
    },
    {
      "english": "Good",
      "phonetic": "/ɡʊd/",
      "type": "tính từ",
      "vietnamese": "Tốt",
      "examples": [
        {"en": "That's a good idea!", "vi": "Đó là một ý tưởng hay!"},
        {"en": "She is a good person.", "vi": "Cô ấy là người tốt."},
      ],
      "idioms": [
        {"en": "Good as gold", "vi": "Ngoan ngoãn, tốt bụng"},
      ],
      "synonyms": ["Great", "Excellent", "Fine"],
    },
    {
      "english": "Bad",
      "phonetic": "/bæd/",
      "type": "tính từ",
      "vietnamese": "Xấu, tồi",
      "examples": [
        {"en": "The weather is bad today.", "vi": "Thời tiết hôm nay xấu."},
        {"en": "That was a bad decision.", "vi": "Đó là một quyết định tồi."},
      ],
      "idioms": [
        {"en": "Not bad", "vi": "Không tệ"},
      ],
      "synonyms": ["Poor", "Terrible", "Awful"],
    },
    {
      "english": "Big",
      "phonetic": "/bɪɡ/",
      "type": "tính từ",
      "vietnamese": "To, lớn",
      "examples": [
        {"en": "This is a big house.", "vi": "Đây là một ngôi nhà lớn."},
        {"en": "He has a big dream.", "vi": "Anh ấy có một giấc mơ lớn."},
      ],
      "idioms": [
        {"en": "Big fish in a small pond", "vi": "Ếch ngồi đáy giếng"},
      ],
      "synonyms": ["Large", "Huge", "Enormous"],
    },
    {
      "english": "Small",
      "phonetic": "/smɔːl/",
      "type": "tính từ",
      "vietnamese": "Nhỏ, bé",
      "examples": [
        {"en": "She has a small dog.", "vi": "Cô ấy có một con chó nhỏ."},
        {"en": "This shirt is too small.", "vi": "Chiếc áo này quá nhỏ."},
      ],
      "idioms": [
        {"en": "Small talk", "vi": "Nói chuyện phiếm"},
      ],
      "synonyms": ["Little", "Tiny", "Petite"],
    },
    {
      "english": "Hot",
      "phonetic": "/hɒt/",
      "type": "tính từ",
      "vietnamese": "Nóng",
      "examples": [
        {"en": "It's very hot today.", "vi": "Hôm nay rất nóng."},
        {"en": "The coffee is too hot.", "vi": "Cà phê quá nóng."},
      ],
      "idioms": [
        {"en": "Hot potato", "vi": "Vấn đề nóng hổi"},
      ],
      "synonyms": ["Warm", "Heated", "Boiling"],
    },
    {
      "english": "Cold",
      "phonetic": "/kəʊld/",
      "type": "tính từ",
      "vietnamese": "Lạnh",
      "examples": [
        {"en": "The water is cold.", "vi": "Nước lạnh."},
        {"en": "I caught a cold.", "vi": "Tôi bị cảm lạnh."},
      ],
      "idioms": [
        {"en": "Cold feet", "vi": "Sợ hãi, chùn bước"},
      ],
      "synonyms": ["Cool", "Chilly", "Freezing"],
    },
    {
      "english": "Run",
      "phonetic": "/rʌn/",
      "type": "động từ",
      "vietnamese": "Chạy",
      "examples": [
        {"en": "I run every morning.", "vi": "Tôi chạy bộ mỗi sáng."},
        {"en": "He runs very fast.", "vi": "Anh ấy chạy rất nhanh."},
      ],
      "idioms": [
        {"en": "Run out of time", "vi": "Hết thời gian"},
      ],
      "synonyms": ["Jog", "Sprint", "Dash"],
    },
    {
      "english": "Walk",
      "phonetic": "/wɔːk/",
      "type": "động từ",
      "vietnamese": "Đi bộ",
      "examples": [
        {
          "en": "Let's walk to the park.",
          "vi": "Chúng ta hãy đi bộ đến công viên.",
        },
        {"en": "She walks to school.", "vi": "Cô ấy đi bộ đến trường."},
      ],
      "idioms": [
        {"en": "Walk in the park", "vi": "Chuyện dễ như ăn kẹo"},
      ],
      "synonyms": ["Stroll", "March", "Hike"],
    },
    {
      "english": "Talk",
      "phonetic": "/tɔːk/",
      "type": "động từ",
      "vietnamese": "Nói chuyện",
      "examples": [
        {"en": "We need to talk.", "vi": "Chúng ta cần nói chuyện."},
        {"en": "She talks a lot.", "vi": "Cô ấy nói nhiều."},
      ],
      "idioms": [
        {"en": "Talk the talk", "vi": "Nói có sách, mách có chứng"},
      ],
      "synonyms": ["Speak", "Chat", "Converse"],
    },
    {
      "english": "Write",
      "phonetic": "/raɪt/",
      "type": "động từ",
      "vietnamese": "Viết",
      "examples": [
        {
          "en": "I write in my diary every day.",
          "vi": "Tôi viết nhật ký mỗi ngày.",
        },
        {
          "en": "She writes beautiful poems.",
          "vi": "Cô ấy viết những bài thơ đẹp.",
        },
      ],
      "idioms": [
        {"en": "Write off", "vi": "Gạch bỏ, từ bỏ"},
      ],
      "synonyms": ["Compose", "Author", "Pen"],
    },
    {
      "english": "Read",
      "phonetic": "/riːd/",
      "type": "động từ",
      "vietnamese": "Đọc",
      "examples": [
        {"en": "I love to read books.", "vi": "Tôi thích đọc sách."},
        {"en": "Can you read this?", "vi": "Bạn có thể đọc cái này không?"},
      ],
      "idioms": [
        {"en": "Read between the lines", "vi": "Hiểu ý nghĩa ẩn dụ"},
      ],
      "synonyms": ["Peruse", "Study", "Browse"],
    },
    {
      "english": "Eat",
      "phonetic": "/iːt/",
      "type": "động từ",
      "vietnamese": "Ăn",
      "examples": [
        {
          "en": "Let's eat dinner together.",
          "vi": "Chúng ta hãy ăn tối cùng nhau.",
        },
        {"en": "I eat breakfast at 7 AM.", "vi": "Tôi ăn sáng lúc 7 giờ."},
      ],
      "idioms": [
        {"en": "Eat your words", "vi": "Rút lại lời nói"},
      ],
      "synonyms": ["Consume", "Dine", "Feed"],
    },
    {
      "english": "Drink",
      "phonetic": "/drɪŋk/",
      "type": "động từ",
      "vietnamese": "Uống",
      "examples": [
        {
          "en": "I drink coffee every morning.",
          "vi": "Tôi uống cà phê mỗi sáng.",
        },
        {
          "en": "Would you like something to drink?",
          "vi": "Bạn muốn uống gì không?",
        },
      ],
      "idioms": [
        {"en": "Drink like a fish", "vi": "Uống rượu như tát nước"},
      ],
      "synonyms": ["Sip", "Gulp", "Consume"],
    },
    {
      "english": "Sleep",
      "phonetic": "/sliːp/",
      "type": "động từ",
      "vietnamese": "Ngủ",
      "examples": [
        {
          "en": "I need to sleep early tonight.",
          "vi": "Tôi cần ngủ sớm tối nay.",
        },
        {"en": "The baby is sleeping.", "vi": "Em bé đang ngủ."},
      ],
      "idioms": [
        {"en": "Sleep on it", "vi": "Suy nghĩ kỹ trước khi quyết định"},
      ],
      "synonyms": ["Slumber", "Rest", "Doze"],
    },
    {
      "english": "Play",
      "phonetic": "/pleɪ/",
      "type": "động từ",
      "vietnamese": "Chơi",
      "examples": [
        {"en": "Children love to play.", "vi": "Trẻ em thích chơi."},
        {
          "en": "I play soccer on weekends.",
          "vi": "Tôi chơi bóng đá vào cuối tuần.",
        },
      ],
      "idioms": [
        {"en": "Play it by ear", "vi": "Tùy cơ ứng biến"},
      ],
      "synonyms": ["Engage", "Participate", "Enjoy"],
    },
    {
      "english": "Learn",
      "phonetic": "/lɜːn/",
      "type": "động từ",
      "vietnamese": "Học hỏi",
      "examples": [
        {"en": "I want to learn English.", "vi": "Tôi muốn học tiếng Anh."},
        {
          "en": "We learn something new every day.",
          "vi": "Chúng ta học được điều mới mỗi ngày.",
        },
      ],
      "idioms": [
        {"en": "Learn the ropes", "vi": "Học hỏi kinh nghiệm"},
      ],
      "synonyms": ["Study", "Master", "Acquire"],
    },
    {
      "english": "Teach",
      "phonetic": "/tiːtʃ/",
      "type": "động từ",
      "vietnamese": "Dạy",
      "examples": [
        {"en": "She teaches English.", "vi": "Cô ấy dạy tiếng Anh."},
        {
          "en": "Can you teach me how to swim?",
          "vi": "Bạn có thể dạy tôi bơi không?",
        },
      ],
      "idioms": [
        {
          "en": "Teach an old dog new tricks",
          "vi": "Khó dạy người già thay đổi",
        },
      ],
      "synonyms": ["Instruct", "Educate", "Train"],
    },
    {
      "english": "Help",
      "phonetic": "/help/",
      "type": "động từ",
      "vietnamese": "Giúp đỡ",
      "examples": [
        {"en": "Can you help me?", "vi": "Bạn có thể giúp tôi không?"},
        {"en": "I always help my friends.", "vi": "Tôi luôn giúp đỡ bạn bè."},
      ],
      "idioms": [
        {"en": "Help yourself", "vi": "Tự nhiên như ở nhà"},
      ],
      "synonyms": ["Assist", "Aid", "Support"],
    },
    {
      "english": "Think",
      "phonetic": "/θɪŋk/",
      "type": "động từ",
      "vietnamese": "Suy nghĩ",
      "examples": [
        {"en": "I think you're right.", "vi": "Tôi nghĩ bạn đúng."},
        {"en": "Let me think about it.", "vi": "Để tôi suy nghĩ về điều đó."},
      ],
      "idioms": [
        {"en": "Think outside the box", "vi": "Suy nghĩ sáng tạo"},
      ],
      "synonyms": ["Consider", "Ponder", "Reflect"],
    },
    {
      "english": "Know",
      "phonetic": "/nəʊ/",
      "type": "động từ",
      "vietnamese": "Biết",
      "examples": [
        {"en": "I know the answer.", "vi": "Tôi biết câu trả lời."},
        {"en": "Do you know her?", "vi": "Bạn có biết cô ấy không?"},
      ],
      "idioms": [
        {"en": "Know the ropes", "vi": "Biết rõ công việc"},
      ],
      "synonyms": ["Understand", "Recognize", "Realize"],
    },
    {
      "english": "Want",
      "phonetic": "/wɒnt/",
      "type": "động từ",
      "vietnamese": "Muốn",
      "examples": [
        {"en": "What do you want?", "vi": "Bạn muốn gì?"},
        {"en": "I want to go home.", "vi": "Tôi muốn về nhà."},
      ],
      "idioms": [
        {"en": "Want for nothing", "vi": "Không thiếu thứ gì"},
      ],
      "synonyms": ["Desire", "Wish", "Need"],
    },
    {
      "english": "Give",
      "phonetic": "/ɡɪv/",
      "type": "động từ",
      "vietnamese": "Cho, tặng",
      "examples": [
        {"en": "Give me your hand.", "vi": "Đưa tay cho tôi."},
        {"en": "She gave me a gift.", "vi": "Cô ấy tặng tôi một món quà."},
      ],
      "idioms": [
        {"en": "Give it a shot", "vi": "Thử xem sao"},
      ],
      "synonyms": ["Provide", "Offer", "Present"],
    },
    {
      "english": "Take",
      "phonetic": "/teɪk/",
      "type": "động từ",
      "vietnamese": "Lấy, nhận",
      "examples": [
        {"en": "Take this book.", "vi": "Lấy quyển sách này."},
        {"en": "It takes time.", "vi": "Điều đó cần thời gian."},
      ],
      "idioms": [
        {"en": "Take it easy", "vi": "Bình tĩnh, thư giãn"},
      ],
      "synonyms": ["Accept", "Grab", "Receive"],
    },
    {
      "english": "Make",
      "phonetic": "/meɪk/",
      "type": "động từ",
      "vietnamese": "Làm, tạo ra",
      "examples": [
        {"en": "I made a mistake.", "vi": "Tôi đã phạm sai lầm."},
        {
          "en": "She makes beautiful cakes.",
          "vi": "Cô ấy làm những chiếc bánh đẹp.",
        },
      ],
      "idioms": [
        {"en": "Make up your mind", "vi": "Quyết định đi"},
      ],
      "synonyms": ["Create", "Build", "Produce"],
    },
    {
      "english": "Come",
      "phonetic": "/kʌm/",
      "type": "động từ",
      "vietnamese": "Đến",
      "examples": [
        {"en": "Come here!", "vi": "Đến đây!"},
        {"en": "Winter is coming.", "vi": "Mùa đông đang đến."},
      ],
      "idioms": [
        {"en": "Come what may", "vi": "Dù có chuyện gì xảy ra"},
      ],
      "synonyms": ["Arrive", "Approach", "Reach"],
    },
    {
      "english": "Go",
      "phonetic": "/ɡəʊ/",
      "type": "động từ",
      "vietnamese": "Đi",
      "examples": [
        {"en": "Let's go!", "vi": "Đi thôi!"},
        {"en": "Where are you going?", "vi": "Bạn đang đi đâu?"},
      ],
      "idioms": [
        {"en": "Go the extra mile", "vi": "Cố gắng hết mình"},
      ],
      "synonyms": ["Leave", "Depart", "Travel"],
    },
    {
      "english": "See",
      "phonetic": "/siː/",
      "type": "động từ",
      "vietnamese": "Nhìn, thấy",
      "examples": [
        {"en": "I can see you.", "vi": "Tôi có thể thấy bạn."},
        {"en": "See you later!", "vi": "Hẹn gặp lại!"},
      ],
      "idioms": [
        {"en": "See eye to eye", "vi": "Đồng ý với nhau"},
      ],
      "synonyms": ["Watch", "View", "Observe"],
    },
    {
      "english": "Look",
      "phonetic": "/lʊk/",
      "type": "động từ",
      "vietnamese": "Nhìn",
      "examples": [
        {"en": "Look at this!", "vi": "Nhìn cái này!"},
        {"en": "You look beautiful.", "vi": "Bạn trông đẹp."},
      ],
      "idioms": [
        {"en": "Look on the bright side", "vi": "Nhìn vào mặt tích cực"},
      ],
      "synonyms": ["Gaze", "Glance", "Stare"],
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

                    if (filteredWords.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "no_results".tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];
                        return Dismissible(
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
                              _words.removeWhere(
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
                                      _words.insert(index, word);
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
                              onTap: () {
                                // show a short confirmation then navigate to details
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('opening_details'.tr()),
                                  ),
                                );
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
      final favoriteWordsList = _words
          .where((word) => _favoriteWords.contains(word["english"]))
          .toList();
      return FavoritesTab(
        favoriteWordsList: favoriteWordsList,
        onSpeak: _speak,
        onToggleFavorite: _toggleFavorite,
      );
    }
    // ⚙️ Trang "Cài đặt"
    else {
      return SettingsTab(
        isDarkMode: _isDarkMode,
        fontSize: _fontSize,
        themeColor: _getThemeColor(),
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
          _saveSettings();
        },
        onFontSizeChanged: (value) {
          setState(() {
            _fontSize = value;
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

  Widget _buildSettingsCard({
    required Color cardColor,
    required Color textColor,
    required Color themeColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFontSizeButton(
    String label,
    double size,
    Color themeColor,
    Color textColor,
  ) {
    final isSelected = _fontSize == size;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _fontSize = size;
        });
        _saveSettings();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? themeColor : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : textColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }

  Widget _buildColorButton(int index, Color color, Color textColor) {
    final isSelected = _themeColorIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _themeColorIndex = index;
        });
        _saveSettings();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 30)
            : null,
      ),
    );
  }
}
