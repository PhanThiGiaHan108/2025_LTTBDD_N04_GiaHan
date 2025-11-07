# SRS - Software Requirements Specification

## Ứng dụng Từ điển Anh - Việt (Chicktionary)

---

## 1. GIỚI THIỆU

### 1.1 Mục đích

Tài liệu này mô tả đầy đủ các yêu cầu chức năng và phi chức năng của ứng dụng Từ điển Anh - Việt (Chicktionary). Tài liệu này được sử dụng làm cơ sở để thiết kế, phát triển và kiểm thử ứng dụng.

### 1.2 Phạm vi dự án

Chicktionary là ứng dụng di động từ điển Anh - Việt được phát triển bằng Flutter, hỗ trợ người dùng tra cứu từ vựng, lưu từ yêu thích, ôn tập flashcard và quản lý hồ sơ cá nhân.

### 1.3 Đối tượng sử dụng

- Học sinh, sinh viên học tiếng Anh
- Người đi làm cần tra cứu từ vựng tiếng Anh
- Người tự học tiếng Anh

### 1.4 Định nghĩa và từ viết tắt

- **SRS**: Software Requirements Specification - Tài liệu đặc tả yêu cầu phần mềm
- **UI**: User Interface - Giao diện người dùng
- **TTS**: Text-to-Speech - Chuyển văn bản thành giọng nói
- **Flashcard**: Thẻ ghi nhớ dùng để ôn tập từ vựng

---

## 2. MÔ TẢ TỔNG QUAN

### 2.1 Quan điểm sản phẩm

Chicktionary là ứng dụng từ điển độc lập, không phụ thuộc vào hệ thống bên ngoài, với dữ liệu từ vựng được tích hợp sẵn và lưu trữ cục bộ.

### 2.2 Chức năng chính

1. **Tra cứu từ vựng**: Tìm kiếm và xem nghĩa từ tiếng Anh
2. **Phát âm**: Nghe phát âm chuẩn của từ vựng
3. **Quản lý từ yêu thích**: Lưu và quản lý danh sách từ yêu thích
4. **Ôn tập Flashcard**: Ôn tập từ vựng qua hình thức flashcard
5. **Quản lý hồ sơ**: Xem thống kê và quản lý thông tin cá nhân
6. **Đa ngôn ngữ**: Hỗ trợ tiếng Anh và tiếng Việt
7. **Cài đặt giao diện**: Tùy chỉnh theme và chế độ tối

### 2.3 Người dùng

- **Người học**: Tra cứu từ, lưu từ yêu thích, ôn tập flashcard
- **Người quản trị (tương lai)**: Quản lý dữ liệu từ vựng

### 2.4 Môi trường vận hành

- **Platform**: Android, iOS, Web, Windows, macOS, Linux
- **Framework**: Flutter 3.9+
- **Ngôn ngữ**: Dart
- **Storage**: SharedPreferences (lưu trữ cục bộ)

---

## 3. YÊU CẦU CHỨC NĂNG

### 3.1 Chức năng đăng nhập/đăng ký

#### FR-1.1: Đăng nhập

**Mô tả**: Người dùng có thể đăng nhập vào hệ thống

**Input**:

- Email
- Mật khẩu

**Process**:

- Kiểm tra định dạng email hợp lệ
- Kiểm tra mật khẩu không để trống
- So sánh với dữ liệu đã lưu

**Output**:

- Đăng nhập thành công → Chuyển đến màn hình chính
- Đăng nhập thất bại → Hiển thị thông báo lỗi

**Priority**: High

#### FR-1.2: Đăng ký

**Mô tả**: Người dùng mới có thể tạo tài khoản

**Input**:

- Email
- Mật khẩu
- Xác nhận mật khẩu

**Process**:

- Kiểm tra email hợp lệ
- Kiểm tra mật khẩu khớp
- Lưu thông tin vào SharedPreferences

**Output**:

- Đăng ký thành công → Chuyển đến màn hình đăng nhập
- Đăng ký thất bại → Hiển thị thông báo lỗi

**Priority**: High

#### FR-1.3: Quên mật khẩu

**Mô tả**: Người dùng có thể khôi phục mật khẩu

**Input**: Email

**Output**: Thông báo đã gửi email khôi phục (mock)

**Priority**: Medium

---

### 3.2 Chức năng tra cứu từ vựng

#### FR-2.1: Tìm kiếm từ

**Mô tả**: Người dùng có thể tìm kiếm từ vựng tiếng Anh

**Input**: Từ khóa tìm kiếm (tiếng Anh)

**Process**:

- Tìm kiếm trong database local
- Hiển thị kết quả phù hợp

**Output**:

- Danh sách các từ khớp với từ khóa
- Hiển thị "Không tìm thấy" nếu không có kết quả

**Priority**: High

#### FR-2.2: Xem chi tiết từ

**Mô tả**: Người dùng xem thông tin chi tiết của từ

**Output**:

- Từ tiếng Anh
- Phiên âm (IPA)
- Nghĩa tiếng Việt
- Ví dụ (nếu có)
- Loại từ (noun, verb, adj, adv)

**Priority**: High

#### FR-2.3: Phát âm từ

**Mô tả**: Người dùng nghe phát âm chuẩn của từ

**Input**: Từ tiếng Anh

**Process**: Sử dụng Flutter TTS để phát âm

**Output**: Âm thanh phát âm

**Priority**: High

#### FR-2.4: Gợi ý từ phổ biến

**Mô tả**: Hiển thị danh sách từ phổ biến khi chưa tìm kiếm

**Output**: Danh sách các từ phổ biến (suggestion chips)

**Priority**: Medium

---

### 3.3 Chức năng quản lý từ yêu thích

#### FR-3.1: Thêm từ yêu thích

**Mô tả**: Người dùng thêm từ vào danh sách yêu thích

**Input**: Từ tiếng Anh

**Process**:

- Lưu vào `favorite_words` trong SharedPreferences
- Hiển thị thông báo thành công

**Output**: Từ được thêm vào danh sách yêu thích

**Priority**: High

#### FR-3.2: Xóa từ yêu thích

**Mô tả**: Người dùng xóa từ khỏi danh sách yêu thích

**Input**: Từ tiếng Anh

**Process**:

- Hiển thị dialog xác nhận
- Xóa khỏi `favorite_words`
- Hiển thị snackbar với nút "Hoàn tác"

**Output**: Từ bị xóa khỏi danh sách

**Priority**: High

#### FR-3.3: Xem danh sách từ yêu thích

**Mô tả**: Hiển thị tất cả từ đã lưu

**Output**:

- Danh sách từ yêu thích dạng card
- Hiển thị "Chưa có từ yêu thích" nếu danh sách rỗng

**Priority**: High

#### FR-3.4: Hoàn tác xóa

**Mô tả**: Người dùng có thể hoàn tác thao tác xóa từ

**Process**: Thêm lại từ vừa xóa vào danh sách

**Priority**: Medium

---

### 3.4 Chức năng ôn tập Flashcard

#### FR-4.1: Bắt đầu ôn tập

**Mô tả**: Người dùng ôn tập các từ yêu thích bằng flashcard

**Input**: Danh sách từ yêu thích

**Process**:

- Xáo trộn ngẫu nhiên các từ
- Hiển thị từng thẻ một

**Output**: Màn hình flashcard

**Priority**: High

#### FR-4.2: Lật thẻ

**Mô tả**: Người dùng lật thẻ để xem nghĩa

**Input**: Tap vào thẻ

**Process**:

- Mặt trước: Từ tiếng Anh
- Mặt sau: Nghĩa tiếng Việt

**Output**: Thẻ được lật với animation

**Priority**: High

#### FR-4.3: Điều hướng thẻ

**Mô tả**: Người dùng có thể chuyển giữa các thẻ

**Input**:

- Nút "Trước"
- Nút "Tiếp" / "Hoàn thành"

**Process**:

- Di chuyển giữa các thẻ
- Hiển thị progress bar

**Output**: Chuyển đến thẻ trước/sau

**Priority**: High

#### FR-4.4: Xáo trộn thẻ

**Mô tả**: Người dùng có thể xáo trộn lại thứ tự các thẻ

**Input**: Tap vào icon shuffle

**Process**: Xáo trộn ngẫu nhiên danh sách

**Output**: Thẻ được sắp xếp lại ngẫu nhiên

**Priority**: Medium

#### FR-4.5: Hoàn thành ôn tập

**Mô tả**: Khi hoàn thành tất cả thẻ

**Process**:

- Lưu từ đã học vào `learned_words`
- Hiển thị hiệu ứng confetti (pháo hoa)
- Hiển thị dialog chúc mừng

**Output**:

- Dialog với 2 lựa chọn: "Thoát" hoặc "Bắt đầu lại"
- Cập nhật số từ đã học trong profile

**Priority**: High

---

### 3.5 Chức năng quản lý hồ sơ

#### FR-5.1: Xem hồ sơ

**Mô tả**: Người dùng xem thông tin cá nhân

**Output**:

- Avatar với chữ cái tên
- Tên hiển thị
- Email
- Số từ yêu thích
- Số từ đã học

**Priority**: High

#### FR-5.2: Chỉnh sửa tên

**Mô tả**: Người dùng có thể đổi tên hiển thị

**Input**: Tên mới

**Process**:

- Hiển thị dialog nhập tên
- Lưu vào `profile_name`

**Output**:

- Tên được cập nhật
- Hiển thị snackbar thành công

**Priority**: Medium

#### FR-5.3: Xem thống kê

**Mô tả**: Hiển thị số liệu học tập

**Output**:

- Card "Thống kê" với:
  - Số từ yêu thích
  - Số từ đã học

**Priority**: Medium

---

### 3.6 Chức năng cài đặt

#### FR-6.1: Đổi ngôn ngữ

**Mô tả**: Người dùng có thể chuyển đổi giữa tiếng Anh và tiếng Việt

**Input**: Lựa chọn ngôn ngữ

**Process**: Sử dụng easy_localization để đổi locale

**Output**: Toàn bộ UI được dịch sang ngôn ngữ đã chọn

**Priority**: High

#### FR-6.2: Chế độ tối

**Mô tả**: Người dùng có thể bật/tắt chế độ tối

**Input**: Switch toggle

**Process**: Thay đổi theme colors

**Output**: Giao diện chuyển sang dark mode / light mode

**Priority**: Medium

#### FR-6.3: Đổi màu chủ đạo

**Mô tả**: Người dùng chọn màu theme

**Options**:

- Tím (Purple)
- Xanh dương (Blue)
- Xanh lá (Green)
- Cam (Orange)
- Hồng (Pink)

**Output**: Toàn bộ UI sử dụng màu đã chọn

**Priority**: Low

#### FR-6.4: Cài đặt âm thanh

**Mô tả**: Bật/tắt tự động phát âm

**Input**: Switch toggle

**Output**: Tự động phát âm khi mở chi tiết từ

**Priority**: Low

---

### 3.7 Chức năng thông tin nhóm

#### FR-7.1: Xem thông tin nhóm

**Mô tả**: Hiển thị thông tin về nhóm phát triển

**Output**:

- Tên môn học
- Danh sách thành viên
- Mã số sinh viên
- Lớp
- Email liên hệ

**Priority**: Low

---

## 4. YÊU CẦU PHI CHỨC NĂNG

### 4.1 Yêu cầu về hiệu năng

#### NFR-1.1: Thời gian phản hồi

- Tìm kiếm từ: < 1 giây
- Load màn hình: < 2 giây
- Animation: 60 FPS

#### NFR-1.2: Dung lượng

- Kích thước app: < 50 MB
- Dữ liệu cache: < 10 MB

### 4.2 Yêu cầu về khả năng sử dụng

#### NFR-2.1: Giao diện người dùng

- Thiết kế Material Design
- Responsive trên nhiều kích thước màn hình
- Animation mượt mà
- Màu sắc hài hòa

#### NFR-2.2: Trải nghiệm người dùng

- Dễ sử dụng, trực quan
- Feedback rõ ràng cho mọi hành động
- Xử lý lỗi graceful

### 4.3 Yêu cầu về tính bảo mật

#### NFR-3.1: Dữ liệu người dùng

- Lưu trữ cục bộ an toàn với SharedPreferences
- Không thu thập dữ liệu cá nhân
- Mật khẩu được lưu trong môi trường local (demo)

### 4.4 Yêu cầu về độ tin cậy

#### NFR-4.1: Ổn định

- Không crash khi sử dụng bình thường
- Xử lý exception đúng cách
- Backup dữ liệu tự động

### 4.5 Yêu cầu về khả năng bảo trì

#### NFR-5.1: Code quality

- Code được tổ chức theo mô hình MVC/MVVM
- Comment đầy đủ
- Tuân thủ Dart style guide

#### NFR-5.2: Documentation

- Có tài liệu SRS, SAD
- README đầy đủ
- Comment trong code

### 4.6 Yêu cầu về tính di động

#### NFR-6.1: Cross-platform

- Chạy được trên Android, iOS, Web
- UI consistent trên các nền tảng
- Tận dụng native features khi có

### 4.7 Yêu cầu về khả năng mở rộng

#### NFR-7.1: Scalability

- Dễ dàng thêm từ vựng mới
- Có thể tích hợp API bên ngoài
- Có thể thêm tính năng mới (quiz, games)

---

## 5. RÀNG BUỘC

### 5.1 Công nghệ

- Framework: Flutter 3.9+
- Ngôn ngữ: Dart
- Platform: Cross-platform

### 5.2 Thời gian

- Thời gian phát triển: 1 học kỳ
- Deadline: Theo lịch môn học

### 5.3 Ngân sách

- Dự án học tập, không có ngân sách

### 5.4 Nhân sự

- Nhóm sinh viên 4 người
- Giảng viên hướng dẫn

---

## 6. PHỤ LỤC

### 6.1 Packages sử dụng

- `flutter_tts: ^4.2.3` - Text to speech
- `easy_localization: ^3.0.8` - Đa ngôn ngữ
- `shared_preferences: ^2.3.3` - Lưu trữ local
- `confetti: ^0.7.0` - Hiệu ứng confetti

### 6.2 Cấu trúc thư mục

```
lib/
├── main.dart
├── data/
│   └── word.dart
├── lang/
│   ├── en.json
│   └── vi.json
├── screens/
│   ├── logo.dart
│   ├── dang_nhap.dart
│   ├── dang_ky.dart
│   ├── trang_chu.dart
│   ├── tu_cua_ban.dart
│   ├── chi_tiet.dart
│   ├── flashcard.dart
│   ├── cai_dat.dart
│   ├── ho_so.dart
│   └── ve_chung_toi.dart
├── widgets/
│   ├── word_card.dart
│   ├── empty_state.dart
│   ├── password_field.dart
│   ├── custom_button.dart
│   └── suggestion_chip.dart
└── services/
```

### 6.3 Dữ liệu mẫu

- 50+ từ vựng tiếng Anh cơ bản
- Phân loại theo nhóm chủ đề
- Có phiên âm, nghĩa, ví dụ

---

**Phiên bản**: 1.0  
**Ngày**: 07/11/2025  
**Người soạn**: Nhóm 04 - Lập trình thiết bị di động
