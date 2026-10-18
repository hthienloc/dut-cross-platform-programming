# Giải Thích Đơn Giản: Dependency Injection (DI) & get_it

---

## 1. Dependency Injection (DI) Là Gì?

- **Hiểu đơn giản:** Thay vì một class tự dùng lệnh `new` để tạo đối tượng nó cần, ta chuẩn bị sẵn các đối tượng từ bên ngoài rồi truyền (inject) vào cho nó.
- **Tại sao cần DI?**
  - Giúp các phần tách rời nhau, dễ thay thế (ví dụ: thay API thật bằng API giả khi test).
  - Quản lý tập trung toàn bộ các dịch vụ tại một file duy nhất: `lib/di/injection_container.dart`.

---

## 2. Thư Viện `get_it` Hoạt Động Thế Nào?

`get_it` giống như một **"Hộp chứa đồ dùng chung" (Service Locator)**:

1. **`registerLazySingleton`**: Tạo ra đúng 1 bản thể duy nhất khi có người gọi lần đầu tiên.
   - Dùng cho: `http.Client`, `PostRemoteDataSource`, `PostRepository`, `GetPostsUseCase` (vì các lớp này chỉ xử lý logic, không cần tạo nhiều lần gây tốn RAM).
2. **`registerFactory`**: Mỗi lần gọi sẽ tạo ra 1 bản thể mới.
   - Dùng cho: `PostBloc` (để gắn theo vòng đời của màn hình, khi thoát màn hình sẽ giải phóng bộ nhớ).

---

## 3. `WidgetsFlutterBinding.ensureInitialized()` Là Gì?

Trong `lib/main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MyApp());
}
```
- **Ý nghĩa:** Đảm bảo hệ thống nền tảng của Flutter (giao tiếp với hệ điều hành Android/iOS/Linux) đã sẵn sàng trước khi nạp các cấu hình bất đồng bộ (`async`) trong `initDependencies()`.
- Nếu không có dòng này, việc gọi các hàm `async` trước `runApp()` có thể gây lỗi treo ứng dụng.
