# Tài Liệu Kỹ Thuật: Dependency Injection (DI) & Cơ Chế Khởi Tạo Trong Flutter

---

## 1. Khái niệm Dependency Injection (DI) và Service Locator

- **Vấn đề**: Khi một class tự khởi tạo các đối tượng phụ thuộc của nó (`final repo = PostRepositoryImpl(remoteDataSource: PostRemoteDataSourceImpl())`), nó bị gắn chặt (tight coupling) với triển khai cụ thể, gây khó khăn cho việc thay thế và viết Unit Test.
- **Giải pháp**: Áp dụng Inversion of Control (IoC) thông qua Service Locator pattern bằng thư viện `get_it`.

---

## 2. Các vòng đời đăng ký trong `get_it`

| Phương thức | Đặc điểm | Trường hợp sử dụng |
|---|---|---|
| `registerFactory<T>()` | Mỗi lần yêu cầu `sl<T>()` sẽ tạo ra một instance mới hoàn toàn | Sử dụng cho `BLoC` / `Cubit` (nếu cần quản lý instance theo widget scope) |
| `registerLazySingleton<T>()` | Chỉ tạo instance một lần duy nhất khi được gọi lần đầu tiên | Sử dụng cho `UseCase`, `Repository`, `DataSource`, `HttpClient` |
| `registerSingleton<T>()` | Tạo instance ngay thời điểm khởi tạo service locator | Dùng cho các dịch vụ cần nạp sẵn ngay khi mở app |

---

## 3. Khởi tạo phụ thuộc trong `main.dart`

### 3.1. Vai trò của `WidgetsFlutterBinding.ensureInitialized()`
- Flutter Engine cần khởi tạo các binding hệ thống (render tree, window dispatch, platform channels) trước khi gọi bất kỳ hàm native hoặc khởi tạo bất đồng bộ nào (như SharedPreferences, SQLite, Firebase, Network initialization).
- Nếu thiếu dòng này, việc gọi các API bất đồng bộ trước `runApp()` sẽ gây lỗi `Binding has not yet been initialized`.

### 3.2. Cấu hình Container (`injection_container.dart`)
```dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> initDependencies() async {
  //! Presentation Layer - BLoC
  sl.registerFactory(() => PostBloc(getPostsUseCase: sl()));

  //! Domain Layer - UseCases
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));

  //! Domain/Data Layer - Repositories
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  //! Data Layer - DataSources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(client: sl()),
  );

  //! Core / External
  sl.registerLazySingleton(() => http.Client());
}
```

### 3.3. Tích hợp với `MultiBlocProvider`
Trong Clean Architecture, DI cấp thấp (`get_it`) cung cấp instance BLoC chứa đầy đủ usecases. `MultiBlocProvider` của `flutter_bloc` nhận instance này và gắn vào cây widget của Flutter, cho phép các widget con truy xuất trạng thái qua `BlocBuilder` hoặc `context.read<PostBloc>()` mà không cần biết cách thức khởi tạo:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (_) => sl<PostBloc>()..add(FetchPostsEvent()),
        ),
      ],
      child: const MaterialApp(
        title: 'Clean Architecture Demo',
        home: PostPage(),
      ),
    );
  }
}
```
