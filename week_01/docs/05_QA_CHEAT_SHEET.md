# Bộ Câu Hỏi & Câu Trả Lời Phản Biện (Q&A Cheat Sheet)
*Chủ đề 04: Clean Architecture & Dependency Injection (DI) trong Flutter*
*Dành cho sinh viên Huỳnh Thiện Lộc (106230052) bảo vệ trước giảng viên*

---

### Câu 1: Tại sao tầng Domain phải là "Pure Dart" mà không được import Flutter hay thư viện HTTP/Dio?
- **Trả lời**: Tầng Domain là trái tim nghiệp vụ của ứng dụng (Entities, UseCases, Repository Contracts).
  - Nếu import `flutter/material.dart` hoặc `http`/`dio`, tầng Domain sẽ bị gắn chặt (tight coupling) vào framework hoặc thư viện bên ngoài.
  - Việc giữ Domain thuần Dart 100% giúp:
    1. Kiểm thử Unit Test độc lập hoàn toàn mà không cần khởi tạo Flutter engine hay widget tree, tốc độ chạy test tính bằng mili-giây.
    2. Nếu sau này dự án chuyển sang nền tảng khác (ví dụ: Dart CLI, AngularDart, Dart Shelf backend), toàn bộ nghiệp vụ trong Domain được tái sử dụng nguyên vẹn.

---

### Câu 2: Nguyên lý Đảo ngược Phụ thuộc (DIP) được thể hiện cụ thể ở đâu trong code của bạn?
- **Trả lời**: Thể hiện trực tiếp tại 2 vị trí:
  1. **Nơi định nghĩa trừu tượng**: Tầng `domain/` định nghĩa `abstract class PostRepository`. Cả tầng Presentation (thông qua `GetPostsUseCase`) đều chỉ biết đến Interface này.
  2. **Nơi hiện thực chi tiết**: Tầng `data/` định nghĩa `class PostRepositoryImpl implements PostRepository`. Chi tiết dữ liệu (`data`) phải phụ thuộc vào hợp đồng trừu tượng (`domain`).
- **Điểm mấu chốt**: Chiều thực thi luồng dữ liệu (Flow of Control) là từ `UI -> UseCase -> RepoImpl -> REST API`. Nhưng chiều phụ thuộc mã nguồn (Source Code Dependency) là `Data -> Domain <- Presentation`. Cả hai tầng ngoài cùng đều hướng vào trừu tượng ở trung tâm.

---

### Câu 3: Làm sao bạn chứng minh được tầng Presentation hoàn toàn không phụ thuộc trực tiếp vào Data Source?
- **Trả lời**: Bằng 2 bằng chứng cụ thể:
  1. **Bằng chứng tĩnh (Static Analysis)**: Trong `post_page.dart` và `post_bloc.dart`, toàn bộ các lệnh `import` chỉ trỏ tới `domain/entities/post.dart`, `domain/usecases/get_posts.dart` và `core/`. Tuyệt đối không có bất kỳ dòng nào import `data/models` hay `data/datasources`.
  2. **Bằng chứng động (Runtime)**: Trong file `injection_container.dart`, nếu thay thế `PostRemoteDataSourceImpl` bằng một `PostLocalDataSourceImpl` (đọc từ SQLite) hoặc `PostMockDataSource`, toàn bộ code của Presentation và BLoC không cần sửa đổi dù chỉ một ký tự.

---

### Câu 4: Tại sao trong `main.dart` phải gọi `WidgetsFlutterBinding.ensureInitialized()` trước khi gọi `initDependencies()`?
- **Trả lời**: 
  - `WidgetsFlutterBinding` là lớp cầu nối trung gian giữa Flutter Framework và Flutter Engine (C++ Engine bên dưới).
  - Thông thường, hàm `runApp()` sẽ tự động gọi khởi tạo binding này.
  - Tuy nhiên, trong dự án của chúng ta, hàm `initDependencies()` được gọi trước `runApp()`. Khi cần cấu hình các dịch vụ bất đồng bộ hoặc nạp dịch vụ native trước khi chạy app, bắt buộc phải gọi `WidgetsFlutterBinding.ensureInitialized()` trước để đảm bảo kênh giao tiếp BinaryMessenger và Engine đã sẵn sàng, tránh bị crash ứng dụng.

---

### Câu 5: Trong `get_it`, tại sao `PostBloc` lại đăng ký bằng `registerFactory`, trong khi `GetPostsUseCase` và `PostRepository` lại đăng ký bằng `registerLazySingleton`?
- **Trả lời**:
  - `GetPostsUseCase` và `PostRepository` là các lớp logic không lưu giữ trạng thái thay đổi theo giao diện (stateless). Ta chỉ cần duy nhất một instance trong suốt vòng đời ứng dụng để tiết kiệm tài nguyên bộ nhớ -> dùng `registerLazySingleton` (chỉ khởi tạo khi có nơi đầu tiên gọi tới).
  - Ngược lại, `PostBloc` nắm giữ trạng thái giao diện và gắn liền với vòng đời của màn hình (`PostPage`). Sử dụng `registerFactory` để mỗi lần màn hình được mở ra hoặc tái tạo, một instance BLoC mới sẽ được cung cấp độc lập, và khi thoát màn hình `MultiBlocProvider` sẽ tự động giải phóng (close/dispose) instance đó mà không làm ảnh hưởng đến các màn hình khác.

---

### Câu 6: Làm thế nào bạn test được tầng Domain mà không cần gọi API thật từ Internet?
- **Trả lời**:
  - Em sử dụng package `mocktail` để tạo lớp giả lập: `class MockPostRepository extends Mock implements PostRepository`.
  - Trong test case, dùng `when(() => mock.getPosts()).thenAnswer(...)` để định nghĩa trước dữ liệu giả lập trả về (`Right` cho thành công, `Left` cho thất bại).
  - Nhờ vậy, Unit Test kiểm tra tính đúng đắn của UseCase một cách cô lập 100%, không phụ thuộc vào tốc độ mạng hay tính khả dụng của server JSONPlaceholder.
