# Phao Cứu Sinh Phản Biện (Q&A Cheat Sheet)
*Tóm tắt ngắn gọn nhất để trả lời trực tiếp khi thầy hỏi*

---

### Câu 1: Em hãy giải thích Clean Architecture trong bài của mình gồm những gì?
- **Trả lời ngắn gọn:**
  - Dạ thưa thầy, ứng dụng của em chia làm 3 tầng độc lập:
    1. **Tầng Presentation (Giao diện):** Gồm `PostPage` hiển thị danh sách trắng đen cơ bản và `PostBloc` quản lý 3 trạng thái: Đang tải (`Loading`), Tải xong (`Loaded`), Báo lỗi (`Error`).
    2. **Tầng Domain (Nghiệp vụ - Thuần Dart):** Gồm thực thể `Post`, hành động `GetPostsUseCase` và Interface hợp đồng `PostRepository`. Tầng này hoàn toàn không dính líu đến Flutter hay thư viện HTTP.
    3. **Tầng Data (Dữ liệu):** Gọi API từ `jsonplaceholder.typicode.com`, chuyển JSON thành `PostModel` và nộp dữ liệu về cho Domain thông qua `PostRepositoryImpl`.

---

### Câu 2: Nguyên lý Đảo ngược phụ thuộc (DIP) nằm ở đâu trong code của em?
- **Trả lời ngắn gọn:**
  - Dạ thưa thầy, DIP thể hiện ở chỗ: **Tầng Presentation không gọi thẳng vào tầng Data, mà cả hai cùng nhìn vào tầng Domain ở giữa**:
    - Tầng `Domain` đặt ra hợp đồng: `abstract class PostRepository`.
    - Tầng `Data` phải hiện thực hợp đồng đó: `class PostRepositoryImpl implements PostRepository`.
    - Tầng `Presentation` (BLoC) chỉ gọi UseCase, UseCase chỉ gọi hợp đồng `PostRepository`.
  - **Chứng minh:** File `post_page.dart` và `post_bloc.dart` hoàn toàn **không có bất kỳ dòng import nào từ thư mục `data/`**.

---

### Câu 3: Tại sao tầng Domain lại không import Flutter hay thư viện mạng nào mà phải là "Pure Dart"?
- **Trả lời ngắn gọn:**
  - Dạ thưa thầy, vì Domain là logic nghiệp vụ cốt lõi:
    1. Giúp chạy Unit Test độc lập cực nhanh (dưới 1 giây) mà không cần bật máy ảo hay khởi động Flutter engine.
    2. Không bị phụ thuộc vào framework, sau này đổi thư viện mạng hay đổi giao diện thì nghiệp vụ vẫn giữ nguyên vẹn.

---

### Câu 4: Dependency Injection (`get_it`) trong bài dùng để làm gì? Phân biệt `LazySingleton` và `Factory`?
- **Trả lời ngắn gọn:**
  - Dạ thưa thầy, `get_it` đóng vai trò là Service Locator tập trung quản lý khởi tạo ở file `injection_container.dart`:
    - **`registerLazySingleton`**: Tạo đúng 1 đối tượng duy nhất khi được gọi lần đầu. Em dùng cho `http.Client`, `PostRemoteDataSource`, `PostRepository`, `GetPostsUseCase` để tiết kiệm bộ nhớ RAM.
    - **`registerFactory`**: Mỗi lần gọi tạo ra 1 đối tượng mới. Em dùng cho `PostBloc` để gắn liền với vòng đời của màn hình, khi thoát màn hình `MultiBlocProvider` sẽ tự đóng giải phóng tài nguyên.

---

### Câu 5: Dòng `WidgetsFlutterBinding.ensureInitialized()` trong `main.dart` có tác dụng gì?
- **Trả lời ngắn gọn:**
  - Dạ thưa thầy, vì hàm `initDependencies()` của em chạy bất đồng bộ (`async`) trước khi gọi `runApp()`. Bắt buộc phải có dòng này để Flutter Engine sẵn sàng kết nối kênh giao tiếp với hệ điều hành trước khi nạp service, tránh bị crash app.

---

### Câu 6: Làm sao em viết Unit Test cho tầng Domain mà không cần có mạng Internet?
- **Trả lời ngắn gọn:**
  - Dạ thưa thầy, em dùng thư viện `mocktail` để tạo lớp giả lập `MockPostRepository extends Mock implements PostRepository`.
  - Em giả lập sẵn dữ liệu trả về để kiểm tra UseCase xử lý đúng khi thành công và đúng khi gặp lỗi, hoàn toàn không cần gọi mạng thật.
  - Khi chạy lệnh `flutter test`, toàn bộ 5 test cases đều pass 100%.
