# SAD - Software Architecture Document

## Ứng dụng Từ điển Anh - Việt (Chicktionary)

---

## 1. GIỚI THIỆU

### 1.1 Mục đích

Tài liệu này mô tả kiến trúc phần mềm của ứng dụng Chicktionary, bao gồm các thành phần, cấu trúc, mô hình thiết kế và các quyết định kiến trúc quan trọng.

### 1.2 Phạm vi

Tài liệu SAD này bao gồm:

- Tổng quan kiến trúc hệ thống
- Mô hình kiến trúc
- Thiết kế chi tiết các thành phần
- Luồng dữ liệu
- Quyết định kiến trúc

### 1.3 Tài liệu tham khảo

- SRS - Software Requirements Specification
- Flutter Architecture Guide
- Material Design Guidelines

---

## 2. TỔNG QUAN KIẾN TRÚC

### 2.1 Mô hình kiến trúc

Chicktionary sử dụng **kiến trúc phân lớp (Layered Architecture)** kết hợp với **Widget-based Architecture** của Flutter.

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER              │
│  (Screens & Widgets - UI Components)    │
├─────────────────────────────────────────┤
│         BUSINESS LOGIC LAYER            │
│    (State Management & Controllers)     │
├─────────────────────────────────────────┤
│          DATA LAYER                     │
│   (Data Models & Local Storage)         │
├─────────────────────────────────────────┤
│         SERVICE LAYER                   │
│  (TTS, Localization, Preferences)       │
└─────────────────────────────────────────┘
```

### 2.2 Công nghệ sử dụng

| Thành phần           | Công nghệ         |
| -------------------- | ----------------- |
| Framework            | Flutter 3.9+      |
| Ngôn ngữ             | Dart              |
| UI Toolkit           | Material Design 3 |
| Local Storage        | SharedPreferences |
| Text-to-Speech       | flutter_tts       |
| Internationalization | easy_localization |
| Animation            | confetti          |

### 2.3 Deployment Architecture

```
┌─────────────────────────────────────────┐
│           User Device                   │
│  ┌───────────────────────────────────┐  │
│  │     Chicktionary App              │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │   Flutter Engine            │  │  │
│  │  │  ┌───────────────────────┐  │  │  │
│  │  │  │   Dart Runtime        │  │  │  │
│  │  │  │  - Business Logic     │  │  │  │
│  │  │  │  - UI Components      │  │  │  │
│  │  │  └───────────────────────┘  │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │    Local Storage                  │  │
│  │  - SharedPreferences              │  │
│  │  - Assets (words.dart)            │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

---

## 3. KIẾN TRÚC CHI TIẾT

### 3.1 Presentation Layer (Lớp giao diện)

#### 3.1.1 Cấu trúc thư mục screens/

```
screens/
├── logo.dart              # Splash screen
├── dang_nhap.dart        # Login screen
├── dang_ky.dart          # Register screen
├── trang_chu.dart        # Home screen (main navigation)
├── tu_cua_ban.dart       # Favorites list screen
├── chi_tiet.dart         # Word detail screen
├── flashcard.dart        # Flashcard review screen
├── cai_dat.dart          # Settings screen
├── ho_so.dart            # Profile screen
└── ve_chung_toi.dart     # About us screen
```

#### 3.1.2 Widget Architecture

**Atomic Design Pattern:**

```
Widgets/
├── Atoms (Basic components)
│   ├── custom_button.dart
│   ├── password_field.dart
│   └── suggestion_chip.dart
│
├── Molecules (Combination of atoms)
│   ├── word_card.dart
│   └── empty_state.dart
│
└── Organisms (Complex components)
    └── (Screens sử dụng molecules)
```

#### 3.1.3 Main Navigation Structure

```dart
TrangChu (StatefulWidget)
├── BottomNavigationBar
│   ├── Tab 1: Trang chủ (Search & Browse)
│   ├── Tab 2: Từ của bạn (Favorites)
│   └── Tab 3: Cài đặt (Settings)
│
└── PageView
    ├── Home Page
    ├── Favorites Page
    └── Settings Page
```

### 3.2 Business Logic Layer

#### 3.2.1 State Management

**Sử dụng StatefulWidget với setState:**

```dart
// Mô hình quản lý state đơn giản
class TrangChu extends StatefulWidget {
  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  int _currentIndex = 0;
  String _searchQuery = '';
  List<Map<String, dynamic>> _favoriteWords = [];

  // State management methods
  void _updateState() {
    setState(() {
      // Update UI
    });
  }
}
```

#### 3.2.2 Controllers & Logic

**FlashcardScreen Controller:**

```dart
class _FlashcardScreenState extends State<FlashcardScreen> {
  // Controllers
  late ConfettiController _confettiController;
  final FlutterTts tts = FlutterTts();

  // State variables
  int _currentIndex = 0;
  bool _showVietnamese = false;
  List<Map<String, dynamic>> _shuffledWords = [];

  // Business logic methods
  void _nextCard() { }
  void _previousCard() { }
  void _flipCard() { }
  void _showCompletionDialog() { }
  Future<void> _saveLearnedWords() async { }
}
```

#### 3.2.3 Data Flow

```
User Input
    ↓
Event Handler
    ↓
Business Logic
    ↓
setState()
    ↓
Widget Rebuild
    ↓
Updated UI
```

### 3.3 Data Layer

#### 3.3.1 Data Models

**Word Model:**

```dart
// data/word.dart
class Word {
  final String english;
  final String vietnamese;
  final String? phonetic;
  final String? example;
  final String? type;

  Word({
    required this.english,
    required this.vietnamese,
    this.phonetic,
    this.example,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'english': english,
      'vietnamese': vietnamese,
      'phonetic': phonetic,
      'example': example,
      'type': type,
    };
  }
}
```

#### 3.3.2 Data Storage

**SharedPreferences Keys:**

```dart
// Storage keys
const String KEY_FAVORITE_WORDS = 'favorite_words';
const String KEY_LEARNED_WORDS = 'learned_words';
const String KEY_PROFILE_NAME = 'profile_name';
const String KEY_PROFILE_EMAIL = 'profile_email';
const String KEY_THEME_COLOR = 'theme_color';
const String KEY_DARK_MODE = 'is_dark_mode';
const String KEY_LANGUAGE = 'selected_language';
const String KEY_AUTO_PLAY_SOUND = 'auto_play_sound';
```

**Data Operations:**

```dart
// Save data
Future<void> _saveFavorites(List<String> favorites) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(KEY_FAVORITE_WORDS, favorites);
}

// Load data
Future<List<String>> _loadFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(KEY_FAVORITE_WORDS) ?? [];
}
```

#### 3.3.3 Static Data

**Word Database:**

```dart
// data/word.dart
final List<Map<String, dynamic>> allWords = [
  {
    "english": "hello",
    "vietnamese": "xin chào",
    "phonetic": "/həˈloʊ/",
    "example": "Hello, how are you?",
    "type": "interjection"
  },
  // ... more words
];
```

### 3.4 Service Layer

#### 3.4.1 Text-to-Speech Service

```dart
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts tts = FlutterTts();

  Future<void> speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }

  Future<void> stop() async {
    await tts.stop();
  }
}
```

#### 3.4.2 Localization Service

```dart
import 'package:easy_localization/easy_localization.dart';

// Sử dụng trong app
void main() async {
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('vi')],
      path: 'lib/lang',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

// Sử dụng trong widget
Text('hello'.tr())  // Tự động dịch theo locale
```

#### 3.4.3 Theme Service

```dart
class ThemeService {
  static Color getThemeColor(String colorName) {
    switch (colorName) {
      case 'purple': return Colors.deepPurple;
      case 'blue': return Colors.blue;
      case 'green': return Colors.green;
      case 'orange': return Colors.orange;
      case 'pink': return Colors.pink;
      default: return Colors.deepPurple;
    }
  }

  static ThemeData buildTheme(Color color, bool isDark) {
    return ThemeData(
      primarySwatch: MaterialColor(color.value, {}),
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
  }
}
```

---

## 4. COMPONENT DIAGRAM

### 4.1 High-Level Components

```
┌──────────────────────────────────────────────────┐
│                   UI Layer                        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐ │
│  │  Screens   │  │  Widgets   │  │  Dialogs   │ │
│  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘ │
└────────┼────────────────┼────────────────┼────────┘
         │                │                │
         ▼                ▼                ▼
┌──────────────────────────────────────────────────┐
│              Business Logic Layer                 │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐ │
│  │   State    │  │Controllers │  │  Handlers  │ │
│  │ Management │  │            │  │            │ │
│  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘ │
└────────┼────────────────┼────────────────┼────────┘
         │                │                │
         ▼                ▼                ▼
┌──────────────────────────────────────────────────┐
│                 Data Layer                        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐ │
│  │   Models   │  │  Storage   │  │Static Data │ │
│  │            │  │  (Prefs)   │  │  (Assets)  │ │
│  └────────────┘  └────────────┘  └────────────┘ │
└──────────────────────────────────────────────────┘
         │                │                │
         ▼                ▼                ▼
┌──────────────────────────────────────────────────┐
│               Service Layer                       │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐ │
│  │    TTS     │  │    i18n    │  │   Theme    │ │
│  │  Service   │  │  Service   │  │  Service   │ │
│  └────────────┘  └────────────┘  └────────────┘ │
└──────────────────────────────────────────────────┘
```

### 4.2 Core Components

#### A. Authentication Component

```
┌─────────────────────────────────┐
│      AuthenticationComponent    │
├─────────────────────────────────┤
│ + login(email, password)        │
│ + register(email, password)     │
│ + forgotPassword(email)         │
│ + logout()                      │
└─────────────────────────────────┘
```

#### B. Dictionary Component

```
┌─────────────────────────────────┐
│      DictionaryComponent        │
├─────────────────────────────────┤
│ + searchWord(query)             │
│ + getWordDetail(word)           │
│ + speakWord(word)               │
│ + getSuggestions()              │
└─────────────────────────────────┘
```

#### C. Favorites Component

```
┌─────────────────────────────────┐
│      FavoritesComponent         │
├─────────────────────────────────┤
│ + addFavorite(word)             │
│ + removeFavorite(word)          │
│ + getFavorites()                │
│ + isFavorite(word)              │
└─────────────────────────────────┘
```

#### D. Flashcard Component

```
┌─────────────────────────────────┐
│      FlashcardComponent         │
├─────────────────────────────────┤
│ + startReview(words)            │
│ + nextCard()                    │
│ + previousCard()                │
│ + flipCard()                    │
│ + shuffleCards()                │
│ + completeReview()              │
└─────────────────────────────────┘
```

#### E. Profile Component

```
┌─────────────────────────────────┐
│      ProfileComponent           │
├─────────────────────────────────┤
│ + getProfile()                  │
│ + updateName(name)              │
│ + getStatistics()               │
│ + getFavoriteCount()            │
│ + getLearnedCount()             │
└─────────────────────────────────┘
```

#### F. Settings Component

```
┌─────────────────────────────────┐
│      SettingsComponent          │
├─────────────────────────────────┤
│ + changeLanguage(locale)        │
│ + toggleDarkMode(isOn)          │
│ + changeThemeColor(color)       │
│ + toggleAutoSound(isOn)         │
└─────────────────────────────────┘
```

---

## 5. SEQUENCE DIAGRAMS

### 5.1 Tra cứu từ và thêm vào yêu thích

```
User          TrangChu      ChiTiet       Storage       TTS
 │               │              │            │           │
 │──search("hello")→│           │            │           │
 │               │──filter()─→  │            │           │
 │               │←─results──   │            │           │
 │               │              │            │           │
 │──tap word────→│              │            │           │
 │               │──navigate──→ │            │           │
 │               │              │            │           │
 │               │              │──checkFavorite()──→    │
 │               │              │←─isFavorite───────     │
 │               │              │            │           │
 │──tap speak───→│              │            │           │
 │               │              │──speak("hello")───────→│
 │               │              │            │           │
 │──tap favorite→│              │            │           │
 │               │              │──saveFavorite()───→    │
 │               │              │←─success──────────     │
 │               │              │            │           │
 │←──snackbar────│              │            │           │
```

### 5.2 Ôn tập Flashcard

```
User        TuCuaBan    Flashcard    Storage    Confetti
 │              │           │           │           │
 │──tap review─→│           │           │           │
 │              │──navigate→│           │           │
 │              │           │           │           │
 │              │           │──loadWords()──→       │
 │              │           │←─words────────        │
 │              │           │──shuffle()            │
 │              │           │           │           │
 │──tap card────→           │           │           │
 │              │           │──flipCard()           │
 │              │           │           │           │
 │──tap next────→           │           │           │
 │              │           │──nextCard()           │
 │              │           │           │           │
 │──tap finish──→           │           │           │
 │              │           │──saveLearnedWords()──→│
 │              │           │←─success──────────────│
 │              │           │           │           │
 │              │           │──playConfetti()──────→│
 │              │           │           │           │
 │              │           │──showDialog()         │
 │←─dialog──────│           │           │           │
```

### 5.3 Cập nhật Profile

```
User        CaiDat      Profile     Storage
 │              │           │          │
 │──tap profile→│           │          │
 │              │──navigate→│          │
 │              │           │          │
 │              │           │──loadProfile()──→
 │              │           │←─data───────────
 │              │           │          │
 │              │           │──loadStats()────→
 │              │           │←─stats──────────
 │              │           │          │
 │──tap edit name→          │          │
 │              │           │──showDialog()
 │──enter name──→          │          │
 │              │           │──saveName()─────→
 │              │           │←─success────────
 │              │           │          │
 │←─snackbar────│           │          │
```

---

## 6. CLASS DIAGRAM

### 6.1 Core Classes

```
┌──────────────────────────┐
│      TrangChu            │
├──────────────────────────┤
│ - _currentIndex: int     │
│ - _searchQuery: String   │
│ - _favoriteWords: List   │
│ - _themeColor: Color     │
│ - _isDarkMode: bool      │
├──────────────────────────┤
│ + _searchWords()         │
│ + _loadFavorites()       │
│ + _toggleFavorite()      │
│ + _navigateToDetail()    │
└──────────────────────────┘
           │
           ├─────────────────────┐
           │                     │
           ▼                     ▼
┌──────────────────┐  ┌──────────────────┐
│  TuCuaBan        │  │  ChiTiet         │
├──────────────────┤  ├──────────────────┤
│ - favoritesList  │  │ - word: Map      │
│ - onSpeak()      │  │ - isFavorite     │
│ - onToggle()     │  │ - tts: FlutterTts│
├──────────────────┤  ├──────────────────┤
│ + build()        │  │ + _speak()       │
│                  │  │ + _toggleFav()   │
└──────────────────┘  └──────────────────┘
           │
           ▼
┌──────────────────────────┐
│  FlashcardScreen         │
├──────────────────────────┤
│ - _currentIndex: int     │
│ - _showVietnamese: bool  │
│ - _shuffledWords: List   │
│ - _confettiController    │
├──────────────────────────┤
│ + _nextCard()            │
│ + _previousCard()        │
│ + _flipCard()            │
│ + _saveLearnedWords()    │
│ + _showCompletionDialog()│
└──────────────────────────┘

┌──────────────────────────┐
│  ProfileScreen           │
├──────────────────────────┤
│ - _name: String          │
│ - _email: String         │
│ - _favoriteCount: int    │
│ - _learnedCount: int     │
├──────────────────────────┤
│ + _loadProfile()         │
│ + _loadStats()           │
│ + _editName()            │
└──────────────────────────┘

┌──────────────────────────┐
│  CaiDat                  │
├──────────────────────────┤
│ - _isDarkMode: bool      │
│ - _themeColor: String    │
│ - _autoPlaySound: bool   │
│ - _language: String      │
├──────────────────────────┤
│ + _toggleDarkMode()      │
│ + _changeThemeColor()    │
│ + _changeLanguage()      │
└──────────────────────────┘
```

### 6.2 Widget Classes

```
┌──────────────────────────┐
│      WordCard            │
├──────────────────────────┤
│ + word: Map              │
│ + isFavorite: bool       │
│ + onTap: Function        │
│ + onFavoriteToggle()     │
│ + onSpeak: Function      │
├──────────────────────────┤
│ + build()                │
└──────────────────────────┘

┌──────────────────────────┐
│    EmptyStateWidget      │
├──────────────────────────┤
│ + icon: IconData         │
│ + title: String          │
│ + iconColor: Color       │
│ + iconSize: double       │
├──────────────────────────┤
│ + build()                │
└──────────────────────────┘

┌──────────────────────────┐
│    PasswordField         │
├──────────────────────────┤
│ + controller: Controller │
│ + hintText: String       │
│ - _obscureText: bool     │
├──────────────────────────┤
│ + _toggleVisibility()    │
│ + build()                │
└──────────────────────────┘
```

---

## 7. DESIGN PATTERNS

### 7.1 Singleton Pattern

**Sử dụng cho Services:**

```dart
class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  final FlutterTts tts = FlutterTts();
}
```

### 7.2 Observer Pattern

**State Management với setState:**

```dart
// Widget observes state changes
setState(() {
  _favoriteWords.add(word);
}); // Notifies listeners → UI rebuilds
```

### 7.3 Builder Pattern

**Widget building:**

```dart
Widget _buildStatItem(IconData icon, String value, String label) {
  return Column(
    children: [
      Icon(icon),
      Text(value),
      Text(label),
    ],
  );
}
```

### 7.4 Strategy Pattern

**Theme switching:**

```dart
ThemeData _getTheme() {
  if (_isDarkMode) {
    return _buildDarkTheme(_themeColor);
  } else {
    return _buildLightTheme(_themeColor);
  }
}
```

### 7.5 Factory Pattern

**Creating widgets dynamically:**

```dart
Widget _createCard(String type) {
  switch (type) {
    case 'word':
      return WordCard(...);
    case 'empty':
      return EmptyStateWidget(...);
    default:
      return Container();
  }
}
```

---

## 8. DATA FLOW

### 8.1 Search Flow

```
User Input (TextField)
    ↓
onChanged event
    ↓
_searchQuery updated
    ↓
setState() called
    ↓
Widget rebuilt
    ↓
Filter allWords
    ↓
Display filtered results
```

### 8.2 Favorite Management Flow

```
User taps favorite icon
    ↓
Check current favorite status
    ↓
If favorite:
    Remove from list → Save to SharedPreferences
    Show "Removed" snackbar with Undo
Else:
    Add to list → Save to SharedPreferences
    Show "Added" snackbar
    ↓
Update UI with setState()
```

### 8.3 Flashcard Review Flow

```
Start Review
    ↓
Load favorite words
    ↓
Shuffle list
    ↓
Display first card
    ↓
User interactions:
    - Tap to flip (show/hide translation)
    - Previous button (index--)
    - Next button (index++)
    ↓
Reach last card
    ↓
Save learned words
    ↓
Play confetti animation
    ↓
Show completion dialog
    ↓
User choice:
    - Restart: Reset index, reshuffle
    - Exit: Navigate back
```

---

## 9. SECURITY ARCHITECTURE

### 9.1 Data Security

**Local Storage:**

- SharedPreferences encryption (platform default)
- No sensitive data stored
- Password demo (not production-ready)

**Best Practices:**

```dart
// Don't store sensitive data in plain text
// Use flutter_secure_storage for production
final storage = FlutterSecureStorage();
await storage.write(key: 'password', value: encryptedPassword);
```

### 9.2 Input Validation

```dart
bool _validateEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

bool _validatePassword(String password) {
  return password.length >= 6;
}
```

### 9.3 Error Handling

```dart
try {
  await _performOperation();
} catch (e) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
```

---

## 10. PERFORMANCE OPTIMIZATION

### 10.1 Widget Optimization

**Use const constructors:**

```dart
const Text('Hello')  // Better than Text('Hello')
```

**Avoid unnecessary rebuilds:**

```dart
// Extract widgets to const
static const _kTitle = Text('Title');

// Use keys for list items
ListView.builder(
  itemBuilder: (context, index) {
    return WordCard(
      key: ValueKey(words[index]['english']),
      word: words[index],
    );
  },
)
```

### 10.2 State Management Optimization

```dart
// Only rebuild what's necessary
setState(() {
  _currentIndex = newIndex;  // Only update affected state
});

// Use ValueNotifier for specific updates
final ValueNotifier<int> counter = ValueNotifier(0);

ValueListenableBuilder(
  valueListenable: counter,
  builder: (context, value, child) {
    return Text('$value');
  },
)
```

### 10.3 Asset Optimization

- Compress images
- Use appropriate image formats
- Lazy load data
- Cache frequently accessed data

---

## 11. DEPLOYMENT ARCHITECTURE

### 11.1 Build Process

```
Source Code (lib/)
    ↓
Flutter Compiler
    ↓
Platform-specific build
    ↓
    ├─→ Android: APK/AAB
    ├─→ iOS: IPA
    ├─→ Web: HTML/JS/WASM
    └─→ Desktop: EXE/DMG/AppImage
```

### 11.2 Release Pipeline

```
Development
    ↓
Code Review
    ↓
Testing
    ↓
Build Release
    ↓
Deploy to Store
    - Google Play Store
    - Apple App Store
    - Web Hosting
```

---

## 12. TESTING ARCHITECTURE

### 12.1 Test Levels

```
┌─────────────────────────────┐
│     Integration Tests       │
│   (Screen flow testing)     │
└─────────────┬───────────────┘
              │
┌─────────────┴───────────────┐
│      Widget Tests           │
│   (UI component testing)    │
└─────────────┬───────────────┘
              │
┌─────────────┴───────────────┐
│       Unit Tests            │
│  (Business logic testing)   │
└─────────────────────────────┘
```

### 12.2 Test Coverage

```dart
// Unit test example
test('Search filters words correctly', () {
  final words = getAllWords();
  final filtered = filterWords(words, 'hello');
  expect(filtered.length, greaterThan(0));
  expect(filtered[0]['english'], contains('hello'));
});

// Widget test example
testWidgets('WordCard displays correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: WordCard(word: testWord),
    ),
  );
  expect(find.text('hello'), findsOneWidget);
});
```

---

## 13. MAINTENANCE & EXTENSIBILITY

### 13.1 Code Organization

**Modular structure:**

```
lib/
├── screens/     # UI screens
├── widgets/     # Reusable components
├── services/    # Business services
├── data/        # Data models & sources
└── utils/       # Helper functions
```

### 13.2 Adding New Features

**Steps to add new feature:**

1. Define data model (if needed)
2. Create screen/widget
3. Add to navigation
4. Implement business logic
5. Add translations
6. Test functionality

**Example: Adding Quiz feature**

```dart
// 1. Create quiz.dart in screens/
// 2. Add navigation in trang_chu.dart
// 3. Add translations in lang/*.json
// 4. Implement quiz logic
// 5. Add to bottom navigation (if needed)
```

### 13.3 Scalability Considerations

**Future enhancements:**

- Backend API integration
- Cloud sync (Firebase)
- Social features (sharing, leaderboard)
- AI pronunciation feedback
- Offline-first architecture
- Multi-dictionary support

---

## 14. APPENDIX

### 14.1 Technology Stack Summary

| Layer            | Technology                   |
| ---------------- | ---------------------------- |
| Frontend         | Flutter, Dart                |
| UI Framework     | Material Design 3            |
| State Management | StatefulWidget + setState    |
| Local Storage    | SharedPreferences            |
| TTS              | flutter_tts                  |
| i18n             | easy_localization            |
| Animation        | confetti, Flutter Animations |

### 14.2 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_tts: ^4.2.3
  easy_localization: ^3.0.8
  shared_preferences: ^2.3.3
  confetti: ^0.7.0
```

### 14.3 Architecture Decisions

**Decision 1: Why Flutter?**

- Cross-platform (Android, iOS, Web, Desktop)
- Fast development with hot reload
- Rich UI components
- Strong community support

**Decision 2: Why SharedPreferences?**

- Simple key-value storage
- Sufficient for current requirements
- No need for complex database
- Fast access

**Decision 3: Why StatefulWidget?**

- Simple state management
- No additional dependencies
- Suitable for app size
- Easy to understand

**Decision 4: Local-first approach**

- Offline functionality
- Fast performance
- No backend costs
- Privacy-friendly

---

## 15. GLOSSARY

| Term              | Definition                                        |
| ----------------- | ------------------------------------------------- |
| Widget            | Basic building block of Flutter UI                |
| StatefulWidget    | Widget that can change its state                  |
| BuildContext      | Handle to the location of a widget in the tree    |
| setState          | Method to update widget state and trigger rebuild |
| Navigator         | Widget for managing screen navigation             |
| SharedPreferences | Key-value storage for simple data                 |
| Hot Reload        | Update code without restarting app                |
| Locale            | Language and region settings                      |

---

**Phiên bản**: 1.0  
**Ngày**: 07/11/2025  
**Người soạn**: Nhóm 04 - Lập trình thiết bị di động  
**Reviewer**: Giảng viên hướng dẫn
