import 'tu_cua_ban.dart';
import 'cai_dat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'chi_tiet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/word_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/suggestion_chip.dart';

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
    // Nếu chưa nhập gì thì trả về danh sách rỗng (không hiển thị gì)
    if (_searchQuery.isEmpty) {
      return [];
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
  List<Map<String, dynamic>> _words = [
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
      "english": "Tome",
      "phonetic": "/təʊm/",
      "type": "danh từ",
      "vietnamese": "Sách lớn, quyển sách dày",
      "examples": [
        {"en": "He opened the ancient tome.", "vi": "Anh ấy mở quyển sách cổ."},
        {
          "en": "The library contains many rare tomes.",
          "vi": "Thư viện chứa nhiều quyển sách quý hiếm.",
        },
      ],
      "idioms": [
        {"en": "A scholarly tome", "vi": "Một quyển sách học thuật"},
      ],
      "synonyms": ["Book", "Volume", "Work"],
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
      "english": "Lovely",
      "phonetic": "/ˈlʌvli/",
      "type": "tính từ",
      "vietnamese": "Đẹp, dễ thương",
      "examples": [
        {"en": "What a lovely dress!", "vi": "Chiếc váy thật đẹp!"},
        {"en": "She is a lovely person.", "vi": "Cô ấy là người dễ thương."},
      ],
      "idioms": [
        {"en": "Lovely weather", "vi": "Thời tiết đẹp"},
      ],
      "synonyms": ["Beautiful", "Pretty", "Charming"],
    },
    {
      "english": "Gorgeous",
      "phonetic": "/ˈɡɔːdʒəs/",
      "type": "tính từ",
      "vietnamese": "Tuyệt đẹp, lộng lẫy",
      "examples": [
        {"en": "You look gorgeous!", "vi": "Bạn trông tuyệt đẹp!"},
        {"en": "The sunset is gorgeous.", "vi": "Hoàng hôn thật lộng lẫy."},
      ],
      "idioms": [
        {"en": "Drop-dead gorgeous", "vi": "Đẹp xuất sắc"},
      ],
      "synonyms": ["Beautiful", "Stunning", "Magnificent"],
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
      "english": "Joyful",
      "phonetic": "/ˈdʒɔɪfl/",
      "type": "tính từ",
      "vietnamese": "Vui vẻ, hân hoan",
      "examples": [
        {"en": "The children were joyful.", "vi": "Bọn trẻ rất vui vẻ."},
        {"en": "It was a joyful occasion.", "vi": "Đó là một dịp vui vẻ."},
      ],
      "idioms": [
        {"en": "Joyful noise", "vi": "Tiếng rộn vui"},
      ],
      "synonyms": ["Happy", "Cheerful", "Merry"],
    },
    {
      "english": "Cheerful",
      "phonetic": "/ˈtʃɪəfl/",
      "type": "tính từ",
      "vietnamese": "Vui vẻ, phấn khởi",
      "examples": [
        {
          "en": "She has a cheerful personality.",
          "vi": "Cô ấy có tính cách vui vẻ.",
        },
        {
          "en": "The room is bright and cheerful.",
          "vi": "Căn phòng sáng sủa và vui vẻ.",
        },
      ],
      "idioms": [
        {"en": "Cheerful disposition", "vi": "Tính tình vui vẻ"},
      ],
      "synonyms": ["Happy", "Joyful", "Bright"],
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
    {
      "english": "Travel",
      "phonetic": "/ˈtræv.əl/",
      "type": "động từ",
      "vietnamese": "Du lịch, đi lại",
      "examples": [
        {
          "en": "I love to travel the world.",
          "vi": "Tôi thích đi du lịch khắp thế giới.",
        },
        {"en": "They travel by train.", "vi": "Họ đi lại bằng tàu hỏa."},
      ],
      "idioms": [
        {"en": "Travel light", "vi": "Đi nhẹ, mang ít đồ"},
      ],
      "synonyms": ["Journey", "Tour", "Roam"],
    },
    {
      "english": "Weather",
      "phonetic": "/ˈweð.ər/",
      "type": "danh từ",
      "vietnamese": "Thời tiết",
      "examples": [
        {
          "en": "The weather is pleasant today.",
          "vi": "Thời tiết hôm nay dễ chịu.",
        },
        {
          "en": "Check the weather before you leave.",
          "vi": "Kiểm tra thời tiết trước khi bạn đi.",
        },
      ],
      "idioms": [
        {"en": "Under the weather", "vi": "Cảm thấy mệt, không khỏe"},
      ],
      "synonyms": ["Climate", "Conditions"],
    },
    {
      "english": "Teacher",
      "phonetic": "/ˈtiː.tʃər/",
      "type": "danh từ",
      "vietnamese": "Giáo viên",
      "examples": [
        {
          "en": "My teacher is very kind.",
          "vi": "Giáo viên của tôi rất tốt bụng.",
        },
        {
          "en": "Teachers inspire students.",
          "vi": "Giáo viên truyền cảm hứng cho học sinh.",
        },
      ],
      "idioms": [
        {"en": "Teacher's pet", "vi": "Học trò cưng"},
      ],
      "synonyms": ["Instructor", "Educator", "Tutor"],
    },
    {
      "english": "Student",
      "phonetic": "/ˈstjuː.dənt/",
      "type": "danh từ",
      "vietnamese": "Học sinh, sinh viên",
      "examples": [
        {
          "en": "She is a diligent student.",
          "vi": "Cô ấy là một sinh viên chăm chỉ.",
        },
        {
          "en": "Students are taking the exam.",
          "vi": "Sinh viên đang làm bài kiểm tra.",
        },
      ],
      "idioms": [
        {"en": "Model student", "vi": "Học sinh gương mẫu"},
      ],
      "synonyms": ["Pupil", "Learner"],
    },
    {
      "english": "Hospital",
      "phonetic": "/ˈhɒs.pɪ.təl/",
      "type": "danh từ",
      "vietnamese": "Bệnh viện",
      "examples": [
        {
          "en": "He works at the hospital.",
          "vi": "Anh ấy làm việc ở bệnh viện.",
        },
        {
          "en": "She was taken to the hospital.",
          "vi": "Cô ấy được đưa đến bệnh viện.",
        },
      ],
      "idioms": [
        {"en": "Hospitality", "vi": "Lòng hiếu khách (khác nghĩa)"},
      ],
      "synonyms": ["Medical center", "Clinic"],
    },
    {
      "english": "Airport",
      "phonetic": "/ˈeə.pɔːt/",
      "type": "danh từ",
      "vietnamese": "Sân bay",
      "examples": [
        {
          "en": "We arrived at the airport early.",
          "vi": "Chúng tôi đến sân bay sớm.",
        },
        {"en": "The airport is very busy.", "vi": "Sân bay rất đông đúc."},
      ],
      "idioms": [
        {"en": "Airport pickup", "vi": "Đón ở sân bay"},
      ],
      "synonyms": ["Airfield", "Terminal"],
    },
    {
      "english": "Ticket",
      "phonetic": "/ˈtɪk.ɪt/",
      "type": "danh từ",
      "vietnamese": "Vé",
      "examples": [
        {"en": "I bought a train ticket.", "vi": "Tôi đã mua một vé tàu."},
        {"en": "Keep your ticket safe.", "vi": "Giữ vé của bạn cẩn thận."},
      ],
      "idioms": [
        {"en": "Golden ticket", "vi": "Tấm vé vàng (cơ hội hiếm)"},
      ],
      "synonyms": ["Pass", "Voucher", "Coupon"],
    },
    {
      "english": "Restaurant",
      "phonetic": "/ˈres.trɒnt/",
      "type": "danh từ",
      "vietnamese": "Nhà hàng",
      "examples": [
        {
          "en": "This restaurant serves Italian food.",
          "vi": "Nhà hàng này phục vụ đồ ăn Ý.",
        },
        {
          "en": "We booked a table at the restaurant.",
          "vi": "Chúng tôi đã đặt bàn ở nhà hàng.",
        },
      ],
      "idioms": [
        {"en": "Restaurant week", "vi": "Tuần lễ nhà hàng (sự kiện)"},
      ],
      "synonyms": ["Eatery", "Dining place"],
    },
    {
      "english": "Delicious",
      "phonetic": "/dɪˈlɪʃ.əs/",
      "type": "tính từ",
      "vietnamese": "Ngon miệng",
      "examples": [
        {"en": "The soup is delicious.", "vi": "Món súp rất ngon."},
        {"en": "What a delicious cake!", "vi": "Chiếc bánh thật ngon!"},
      ],
      "idioms": [
        {"en": "Look delicious", "vi": "Trông ngon miệng"},
      ],
      "synonyms": ["Tasty", "Yummy", "Flavorful"],
    },
    {
      "english": "Breakfast",
      "phonetic": "/ˈbrek.fəst/",
      "type": "danh từ",
      "vietnamese": "Bữa sáng",
      "examples": [
        {
          "en": "I usually have bread for breakfast.",
          "vi": "Tôi thường ăn bánh mì cho bữa sáng.",
        },
        {
          "en": "Breakfast is the most important meal.",
          "vi": "Bữa sáng là bữa quan trọng nhất.",
        },
      ],
      "idioms": [
        {"en": "Breakfast of champions", "vi": "Bữa sáng của nhà vô địch"},
      ],
      "synonyms": ["Morning meal"],
    },
    {
      "english": "Library",
      "phonetic": "/ˈlaɪ.brər.i/",
      "type": "danh từ",
      "vietnamese": "Thư viện",
      "examples": [
        {
          "en": "I borrowed a book from the library.",
          "vi": "Tôi mượn sách từ thư viện.",
        },
        {"en": "The library is quiet.", "vi": "Thư viện yên tĩnh."},
      ],
      "idioms": [
        {"en": "Library card", "vi": "Thẻ thư viện"},
      ],
      "synonyms": ["Bookroom", "Athenaeum"],
    },
    {
      "english": "Keyboard",
      "phonetic": "/ˈkiː.bɔːd/",
      "type": "danh từ",
      "vietnamese": "Bàn phím",
      "examples": [
        {"en": "The keyboard is wireless.", "vi": "Bàn phím không dây."},
        {
          "en": "Clean your keyboard regularly.",
          "vi": "Vệ sinh bàn phím thường xuyên.",
        },
      ],
      "idioms": [
        {"en": "Keyboard warrior", "vi": "Anh hùng bàn phím"},
      ],
      "synonyms": ["Keypad"],
    },
    {
      "english": "Screen",
      "phonetic": "/skriːn/",
      "type": "danh từ",
      "vietnamese": "Màn hình",
      "examples": [
        {
          "en": "Don't stare at the screen too long.",
          "vi": "Đừng nhìn màn hình quá lâu.",
        },
        {
          "en": "The phone screen cracked.",
          "vi": "Màn hình điện thoại bị nứt.",
        },
      ],
      "idioms": [
        {"en": "On screen", "vi": "Trên màn ảnh"},
      ],
      "synonyms": ["Display", "Monitor"],
    },
    {
      "english": "Battery",
      "phonetic": "/ˈbæt.ər.i/",
      "type": "danh từ",
      "vietnamese": "Pin, ắc quy",
      "examples": [
        {
          "en": "My phone battery is low.",
          "vi": "Pin điện thoại của tôi sắp hết.",
        },
        {"en": "Charge the battery overnight.", "vi": "Sạc pin qua đêm."},
      ],
      "idioms": [
        {"en": "Recharge your batteries", "vi": "Nạp lại năng lượng"},
      ],
      "synonyms": ["Cell", "Accumulator"],
    },
    {
      "english": "Network",
      "phonetic": "/ˈnet.wɜːk/",
      "type": "danh từ",
      "vietnamese": "Mạng lưới, mạng",
      "examples": [
        {
          "en": "The Wi‑Fi network is unstable.",
          "vi": "Mạng Wi‑Fi không ổn định.",
        },
        {
          "en": "Build a professional network.",
          "vi": "Xây dựng mạng lưới chuyên nghiệp.",
        },
      ],
      "idioms": [
        {"en": "Network effect", "vi": "Hiệu ứng mạng lưới"},
      ],
      "synonyms": ["Web", "Grid"],
    },
    {
      "english": "Interview",
      "phonetic": "/ˈɪn.tə.vjuː/",
      "type": "danh từ",
      "vietnamese": "Phỏng vấn",
      "examples": [
        {
          "en": "I have a job interview tomorrow.",
          "vi": "Tôi có buổi phỏng vấn xin việc vào ngày mai.",
        },
        {
          "en": "The interview went well.",
          "vi": "Buổi phỏng vấn diễn ra tốt đẹp.",
        },
      ],
      "idioms": [
        {"en": "Exit interview", "vi": "Phỏng vấn thôi việc"},
      ],
      "synonyms": ["Meeting", "Q&A"],
    },
    {
      "english": "Salary",
      "phonetic": "/ˈsæl.ər.i/",
      "type": "danh từ",
      "vietnamese": "Lương",
      "examples": [
        {
          "en": "Her salary increased this year.",
          "vi": "Lương của cô ấy tăng năm nay.",
        },
        {
          "en": "They offer a competitive salary.",
          "vi": "Họ đưa ra mức lương cạnh tranh.",
        },
      ],
      "idioms": [
        {"en": "On salary", "vi": "Hưởng lương cố định"},
      ],
      "synonyms": ["Wage", "Pay", "Income"],
    },
    {
      "english": "Vacation",
      "phonetic": "/vəˈkeɪ.ʃən/",
      "type": "danh từ",
      "vietnamese": "Kỳ nghỉ",
      "examples": [
        {
          "en": "We are planning a summer vacation.",
          "vi": "Chúng tôi đang lên kế hoạch cho kỳ nghỉ hè.",
        },
        {"en": "Enjoy your vacation!", "vi": "Chúc bạn có kỳ nghỉ vui vẻ!"},
      ],
      "idioms": [
        {"en": "On vacation", "vi": "Đang đi nghỉ"},
      ],
      "synonyms": ["Holiday", "Break"],
    },
    {
      "english": "Mountain",
      "phonetic": "/ˈmaʊn.tɪn/",
      "type": "danh từ",
      "vietnamese": "Núi",
      "examples": [
        {"en": "They climbed the mountain.", "vi": "Họ đã leo núi."},
        {
          "en": "The mountain is covered with snow.",
          "vi": "Ngọn núi phủ đầy tuyết.",
        },
      ],
      "idioms": [
        {
          "en": "Make a mountain out of a molehill",
          "vi": "Làm quá lên chuyện nhỏ",
        },
      ],
      "synonyms": ["Peak", "Summit", "Hill"],
    },
    {
      "english": "River",
      "phonetic": "/ˈrɪv.ər/",
      "type": "danh từ",
      "vietnamese": "Sông",
      "examples": [
        {"en": "The river flows to the sea.", "vi": "Con sông chảy ra biển."},
        {
          "en": "We had a picnic by the river.",
          "vi": "Chúng tôi dã ngoại bên bờ sông.",
        },
      ],
      "idioms": [
        {"en": "Sell down the river", "vi": "Phản bội"},
      ],
      "synonyms": ["Stream", "Waterway"],
    },
    {
      "english": "Ocean",
      "phonetic": "/ˈəʊ.ʃən/",
      "type": "danh từ",
      "vietnamese": "Đại dương",
      "examples": [
        {"en": "The ocean is vast.", "vi": "Đại dương bao la."},
        {"en": "We swam in the ocean.", "vi": "Chúng tôi bơi ở đại dương."},
      ],
      "idioms": [
        {"en": "A drop in the ocean", "vi": "Muối bỏ biển"},
      ],
      "synonyms": ["Sea", "Blue"],
    },
    {
      "english": "Island",
      "phonetic": "/ˈaɪ.lənd/",
      "type": "danh từ",
      "vietnamese": "Hòn đảo",
      "examples": [
        {
          "en": "They live on a small island.",
          "vi": "Họ sống trên một hòn đảo nhỏ.",
        },
        {"en": "The island is beautiful.", "vi": "Hòn đảo rất đẹp."},
      ],
      "idioms": [
        {"en": "No man is an island", "vi": "Không ai là một ốc đảo"},
      ],
      "synonyms": ["Isle", "Islet"],
    },
    {
      "english": "Forest",
      "phonetic": "/ˈfɒr.ɪst/",
      "type": "danh từ",
      "vietnamese": "Khu rừng",
      "examples": [
        {"en": "The forest is dense.", "vi": "Khu rừng rậm rạp."},
        {
          "en": "We camped in the forest.",
          "vi": "Chúng tôi cắm trại trong rừng.",
        },
      ],
      "idioms": [
        {
          "en": "Can't see the forest for the trees",
          "vi": "Không thấy rừng vì mải nhìn cây",
        },
      ],
      "synonyms": ["Woods", "Jungle"],
    },
    {
      "english": "City",
      "phonetic": "/ˈsɪt.i/",
      "type": "danh từ",
      "vietnamese": "Thành phố",
      "examples": [
        {
          "en": "Hanoi is a busy city.",
          "vi": "Hà Nội là một thành phố nhộn nhịp.",
        },
        {"en": "The city never sleeps.", "vi": "Thành phố không bao giờ ngủ."},
      ],
      "idioms": [
        {"en": "City limits", "vi": "Ranh giới thành phố"},
      ],
      "synonyms": ["Metropolis", "Urban area"],
    },
    {
      "english": "Village",
      "phonetic": "/ˈvɪl.ɪdʒ/",
      "type": "danh từ",
      "vietnamese": "Làng",
      "examples": [
        {
          "en": "My grandparents live in a village.",
          "vi": "Ông bà tôi sống ở một ngôi làng.",
        },
        {"en": "The village is peaceful.", "vi": "Ngôi làng yên bình."},
      ],
      "idioms": [
        {"en": "Global village", "vi": "Làng toàn cầu"},
      ],
      "synonyms": ["Hamlet", "Rural community"],
    },
    {
      "english": "Market",
      "phonetic": "/ˈmɑː.kɪt/",
      "type": "danh từ",
      "vietnamese": "Chợ, thị trường",
      "examples": [
        {
          "en": "We bought vegetables at the market.",
          "vi": "Chúng tôi mua rau ở chợ.",
        },
        {"en": "The market is competitive.", "vi": "Thị trường cạnh tranh."},
      ],
      "idioms": [
        {"en": "Market share", "vi": "Thị phần"},
      ],
      "synonyms": ["Bazaar", "Marketplace"],
    },
    {
      "english": "Train",
      "phonetic": "/treɪn/",
      "type": "danh từ",
      "vietnamese": "Tàu hỏa; (v) đào tạo",
      "examples": [
        {"en": "The train arrives at 9 AM.", "vi": "Tàu đến lúc 9 giờ sáng."},
        {
          "en": "We train new employees.",
          "vi": "Chúng tôi đào tạo nhân viên mới.",
        },
      ],
      "idioms": [
        {"en": "Train of thought", "vi": "Mạch suy nghĩ"},
      ],
      "synonyms": ["Rail", "Coach", "Educate"],
    },
    {
      "english": "Flight",
      "phonetic": "/flaɪt/",
      "type": "danh từ",
      "vietnamese": "Chuyến bay",
      "examples": [
        {
          "en": "Our flight was delayed.",
          "vi": "Chuyến bay của chúng tôi bị hoãn.",
        },
        {"en": "The flight takes two hours.", "vi": "Chuyến bay mất hai giờ."},
      ],
      "idioms": [
        {"en": "Take flight", "vi": "Bỏ chạy, bay đi"},
      ],
      "synonyms": ["Air trip", "Journey"],
    },
    {
      "english": "Appointment",
      "phonetic": "/əˈpɔɪnt.mənt/",
      "type": "danh từ",
      "vietnamese": "Cuộc hẹn",
      "examples": [
        {
          "en": "I have a dentist appointment.",
          "vi": "Tôi có cuộc hẹn với nha sĩ.",
        },
        {
          "en": "Please confirm your appointment.",
          "vi": "Vui lòng xác nhận cuộc hẹn.",
        },
      ],
      "idioms": [
        {"en": "Keep an appointment", "vi": "Giữ đúng cuộc hẹn"},
      ],
      "synonyms": ["Meeting", "Arrangement"],
    },
    {
      "english": "Medicine",
      "phonetic": "/ˈmed.ɪ.sɪn/",
      "type": "danh từ",
      "vietnamese": "Thuốc; y học",
      "examples": [
        {
          "en": "Take your medicine after meals.",
          "vi": "Uống thuốc sau bữa ăn.",
        },
        {"en": "She studies medicine.", "vi": "Cô ấy học ngành y."},
      ],
      "idioms": [
        {"en": "A bitter pill to swallow", "vi": "Sự thật khó chấp nhận"},
      ],
      "synonyms": ["Drug", "Treatment"],
    },
    {
      "english": "Healthy",
      "phonetic": "/ˈhel.θi/",
      "type": "tính từ",
      "vietnamese": "Khỏe mạnh, lành mạnh",
      "examples": [
        {"en": "Eat a healthy diet.", "vi": "Ăn uống lành mạnh."},
        {"en": "She is very healthy.", "vi": "Cô ấy rất khỏe mạnh."},
      ],
      "idioms": [
        {"en": "Healthy appetite", "vi": "Ăn khỏe"},
      ],
      "synonyms": ["Fit", "Well", "Robust"],
    },
    {
      "english": "Dangerous",
      "phonetic": "/ˈdeɪn.dʒər.əs/",
      "type": "tính từ",
      "vietnamese": "Nguy hiểm",
      "examples": [
        {
          "en": "Driving fast is dangerous.",
          "vi": "Lái xe nhanh rất nguy hiểm.",
        },
        {"en": "The sea can be dangerous.", "vi": "Biển có thể nguy hiểm."},
      ],
      "idioms": [
        {"en": "Flirt with danger", "vi": "Đùa với nguy hiểm"},
      ],
      "synonyms": ["Risky", "Hazardous", "Unsafe"],
    },
    {
      "english": "Careful",
      "phonetic": "/ˈkeə.fəl/",
      "type": "tính từ",
      "vietnamese": "Cẩn thận",
      "examples": [
        {
          "en": "Be careful when crossing the street.",
          "vi": "Hãy cẩn thận khi băng qua đường.",
        },
        {
          "en": "He is careful with money.",
          "vi": "Anh ấy cẩn thận trong chi tiêu.",
        },
      ],
      "idioms": [
        {"en": "Handle with care", "vi": "Xin nhẹ tay (cẩn thận)"},
      ],
      "synonyms": ["Cautious", "Prudent"],
    },
    {
      "english": "Quick",
      "phonetic": "/kwɪk/",
      "type": "tính từ",
      "vietnamese": "Nhanh",
      "examples": [
        {"en": "He is quick to learn.", "vi": "Anh ấy học nhanh."},
        {
          "en": "We need a quick decision.",
          "vi": "Chúng ta cần quyết định nhanh.",
        },
      ],
      "idioms": [
        {"en": "Quick on the draw", "vi": "Phản ứng nhanh"},
      ],
      "synonyms": ["Fast", "Rapid", "Swift"],
    },
    {
      "english": "Slow",
      "phonetic": "/sləʊ/",
      "type": "tính từ",
      "vietnamese": "Chậm",
      "examples": [
        {"en": "The internet is slow today.", "vi": "Internet hôm nay chậm."},
        {"en": "He walks slow in the rain.", "vi": "Anh ấy đi chậm trong mưa."},
      ],
      "idioms": [
        {"en": "On the slow side", "vi": "Hơi chậm"},
      ],
      "synonyms": ["Sluggish", "Leisurely"],
    },
    {
      "english": "Expensive",
      "phonetic": "/ɪkˈspen.sɪv/",
      "type": "tính từ",
      "vietnamese": "Đắt đỏ",
      "examples": [
        {"en": "This bag is expensive.", "vi": "Chiếc túi này đắt."},
        {
          "en": "Eating out can be expensive.",
          "vi": "Ăn ngoài có thể tốn kém.",
        },
      ],
      "idioms": [
        {"en": "Pay through the nose", "vi": "Trả giá cắt cổ"},
      ],
      "synonyms": ["Costly", "Pricey"],
    },
    {
      "english": "Cheap",
      "phonetic": "/tʃiːp/",
      "type": "tính từ",
      "vietnamese": "Rẻ",
      "examples": [
        {"en": "These shoes are cheap.", "vi": "Đôi giày này rẻ."},
        {
          "en": "Cheap doesn't always mean bad.",
          "vi": "Rẻ không phải lúc nào cũng xấu.",
        },
      ],
      "idioms": [
        {"en": "Cheap and cheerful", "vi": "Rẻ mà ổn"},
      ],
      "synonyms": ["Inexpensive", "Low-cost"],
    },
    {
      "english": "Important",
      "phonetic": "/ɪmˈpɔː.tənt/",
      "type": "tính từ",
      "vietnamese": "Quan trọng",
      "examples": [
        {"en": "It's important to sleep well.", "vi": "Ngủ đủ rất quan trọng."},
        {
          "en": "This is an important document.",
          "vi": "Đây là tài liệu quan trọng.",
        },
      ],
      "idioms": [
        {"en": "Of great importance", "vi": "Rất quan trọng"},
      ],
      "synonyms": ["Significant", "Crucial", "Vital"],
    },
    {
      "english": "Interesting",
      "phonetic": "/ˈɪn.trəs.tɪŋ/",
      "type": "tính từ",
      "vietnamese": "Thú vị",
      "examples": [
        {"en": "The film was interesting.", "vi": "Bộ phim rất thú vị."},
        {
          "en": "He told an interesting story.",
          "vi": "Anh ấy kể một câu chuyện thú vị.",
        },
      ],
      "idioms": [
        {"en": "Interestingly enough", "vi": "Thú vị là"},
      ],
      "synonyms": ["Engaging", "Fascinating", "Captivating"],
    },
    {
      "english": "Boring",
      "phonetic": "/ˈbɔː.rɪŋ/",
      "type": "tính từ",
      "vietnamese": "Nhàm chán",
      "examples": [
        {"en": "The lecture was boring.", "vi": "Bài giảng thật nhàm chán."},
        {"en": "I find this game boring.", "vi": "Tôi thấy trò chơi này chán."},
      ],
      "idioms": [
        {"en": "Bored to death", "vi": "Chán chết đi được"},
      ],
      "synonyms": ["Dull", "Tedious"],
    },
    {
      "english": "Celebrate",
      "phonetic": "/ˈsel.ə.breɪt/",
      "type": "động từ",
      "vietnamese": "Ăn mừng, kỷ niệm",
      "examples": [
        {
          "en": "We celebrate New Year together.",
          "vi": "Chúng tôi đón năm mới cùng nhau.",
        },
        {
          "en": "Let's celebrate your success.",
          "vi": "Hãy ăn mừng thành công của bạn.",
        },
      ],
      "idioms": [
        {"en": "In a celebratory mood", "vi": "Trong tâm trạng ăn mừng"},
      ],
      "synonyms": ["Commemorate", "Rejoice"],
    },
    {
      "english": "Surprise",
      "phonetic": "/səˈpraɪz/",
      "type": "danh từ; động từ",
      "vietnamese": "Bất ngờ; làm bất ngờ",
      "examples": [
        {"en": "What a nice surprise!", "vi": "Thật là một bất ngờ dễ chịu!"},
        {
          "en": "They surprised me with a gift.",
          "vi": "Họ làm tôi bất ngờ với một món quà.",
        },
      ],
      "idioms": [
        {"en": "Take by surprise", "vi": "Làm ai bất ngờ"},
      ],
      "synonyms": ["Astonish", "Amaze", "Shock"],
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
                      // Hiển thị thông báo khác nhau tùy theo có đang tìm kiếm hay không
                      if (_searchQuery.isEmpty) {
                        // Chưa nhập gì -> hiển thị lời nhắc tìm kiếm
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
                            children: [
                              Text(
                                "popular_words".tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
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
                        );
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
                              onTap: () async {
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
      return CaiDat(
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

  // Widget helper cho suggestion chips
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
