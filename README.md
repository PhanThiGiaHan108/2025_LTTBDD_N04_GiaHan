# 📘 ỨNG DỤNG TỪ ĐIỂN ANH – VIỆT  
### 🐥 Chicktionary – English - Vietnamese Dictionary App  



## 🎯 Giới thiệu  

Ứng dụng **“Chicktionary – Từ điển Anh – Việt”** được phát triển với mục tiêu giúp người dùng **tra cứu, ghi nhớ và học từ vựng tiếng Anh một cách dễ dàng, trực quan và hiệu quả**.  
Ứng dụng hướng tới đối tượng là **học sinh, sinh viên và người đi làm** muốn trau dồi vốn từ vựng nhanh chóng, mọi lúc, mọi nơi.  

Ứng dụng được xây dựng bằng **Flutter**, hoạt động **hoàn toàn offline**, dữ liệu từ được lưu trong **file cục bộ (`word.dart`)**, giúp giảm phụ thuộc vào mạng Internet và cơ sở dữ liệu ngoài.  



## 💡 Mục tiêu của dự án  

- Xây dựng ứng dụng từ điển Anh – Việt có khả năng **tra cứu và học từ hiệu quả**.  
- Cung cấp **flashcard tương tác** giúp người học ghi nhớ từ vựng lâu hơn.  
- Hỗ trợ **đăng nhập mô phỏng** để quản lý từ yêu thích.  
- Cho phép người dùng **tùy chỉnh giao diện, ngôn ngữ và chế độ tối/sáng**.  
- Mang lại trải nghiệm thân thiện, dễ sử dụng trên mọi thiết bị.  



## 🧩 Chức năng chính  

| STT | Tên chức năng | Mô tả ngắn gọn |
|-----|----------------|----------------|
| 1 | 🔑 **Đăng nhập / Đăng ký** | Người dùng đăng nhập, đăng ký để sử dụng ứng dụng (mô phỏng UI). |
| 2 | 🏠 **Trang chủ (Home)** | Hiển thị danh sách từ vựng Anh – Việt, cho phép tìm kiếm nhanh. |
| 3 | 📖 **Tra cứu từ vựng** | Hiển thị nghĩa, loại từ, phiên âm, ví dụ và từ đồng nghĩa. |
| 4 | ❤️ **Từ của bạn (Favorites)** | Lưu danh sách các từ người dùng đã đánh dấu yêu thích. |
| 5 | 🧠 **Flashcard học từ vựng** | Cho phép người dùng học từ thông qua thẻ lật (hiện/ẩn nghĩa tiếng Việt). |
| 6 | ⚙️ **Cài đặt (Settings)** | Thay đổi theme, ngôn ngữ, xem hồ sơ, thông tin nhóm và đăng xuất. |
| 7 | 👥 **Thông tin nhóm** | Hiển thị thông tin dự án, giảng viên hướng dẫn và thành viên. |



## 📚 Cấu trúc dữ liệu:
Dữ liệu từ vựng được lưu trong **file `word.dart`** dưới dạng danh sách tĩnh (`List<Map<String, dynamic>>`) bao gồm:
- Từ tiếng Anh  
- Phiên âm  
- Loại từ  
- Nghĩa tiếng Việt  
- Ví dụ sử dụng  
- Thành ngữ và từ đồng nghĩa 
