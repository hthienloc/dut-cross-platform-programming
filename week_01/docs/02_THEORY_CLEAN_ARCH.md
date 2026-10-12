# Tài Liệu Kỹ Thuật: Clean Architecture & Nguyên Lý Đảo Ngược Phụ Thuộc (DIP)

---

## 1. Bản chất Clean Architecture trong Flutter

Clean Architecture do Robert C. Martin (Uncle Bob) đề xướng, tập trung vào nguyên lý **tách biệt các mối quan tâm (Separation of Concerns)** và đặt quy tắc phụ thuộc theo hình tròn đồng tâm.

```
       +---------------------------------------------+
       |             Presentation Layer              |
       |     (Widgets, Screens, BLoC / Cubits)       |
       +---------------------------------------------+
                              | phụ thuộc vào (calls)
                              v
       +---------------------------------------------+
       |                Domain Layer                 |
       |  (Entities, UseCases, Repository Contracts) |
       +---------------------------------------------+
                              ^ hiện thực (implements)
                              |
       +---------------------------------------------+
       |                 Data Layer                  |
       |    (Models, DataSources, Repo Impls)        |
       +---------------------------------------------+
```

### 1.1. Tầng Domain (Domain Layer) — Trung tâm nghiệp vụ
- **Đặc điểm**: Độc lập tuyệt đối với mọi framework và thư viện bên thứ ba (chỉ dùng Dart thuần).
- **Thành phần**:
  - `Entities`: Các đối tượng dữ liệu lõi của ứng dụng (ví dụ: `Post`).
  - `Repository Interfaces`: Hợp đồng trừu tượng (abstract class) quy định các thao tác cần thiết mà không quan tâm dữ liệu lấy từ đâu (`abstract class PostRepository`).
  - `UseCases (Interactors)`: Đại diện cho một quy trình nghiệp vụ cụ thể (ví dụ: `GetPostsUseCase`).

### 1.2. Tầng Data (Data Layer) — Cung cấp dữ liệu
- **Đặc điểm**: Phụ thuộc vào `Domain Layer` thông qua việc hiện thực interface.
- **Thành phần**:
  - `Models`: Kế thừa hoặc chuyển đổi thành Entity, chứa logic serialize/deserialize JSON (`PostModel.fromJson`, `toJson`).
  - `DataSources`: Tương tác trực tiếp với tầng I/O (RemoteDataSource qua HTTP/REST API, LocalDataSource qua SQLite/Hive/Cache).
  - `Repository Implementation`: Lớp hiện thực hợp đồng từ `Domain Layer`. Chịu trách nhiệm điều phối dữ liệu giữa Remote và Local, xử lý lỗi (Exception -> Failure).

### 1.3. Tầng Presentation (Presentation Layer) — Hiển thị & Tương tác
- **Đặc điểm**: Phụ thuộc vào `Domain Layer` (UseCases), hoàn toàn không được import trực tiếp bất kỳ class nào từ `Data Layer`.
- **Thành phần**:
  - `State Management (BLoC / Cubit / Riverpod)`: Tiếp nhận sự kiện từ UI, gọi UseCase, nhận kết quả và phát ra State tương ứng.
  - `Widgets / Pages`: Hiển thị giao diện người dùng dựa trên State và gửi Event khi người dùng tương tác.

---

## 2. Nguyên lý Đảo ngược Phụ thuộc (Dependency Inversion Principle - DIP)

### 2.1. Vấn đề của kiến trúc truyền thống
Trong kiến trúc phân tầng truyền thống (Data-Driven):
```
Presentation ---> Data Layer (HttpClient / Database)
```
Tầng giao diện phụ thuộc trực tiếp vào tầng dữ liệu. Nếu đổi thư viện mạng (ví dụ từ `http` sang `dio`) hoặc đổi cấu trúc API, toàn bộ Presentation và Logic đều bị ảnh hưởng.

### 2.2. Giải pháp với DIP
DIP phát biểu rằng:
1. Module cấp cao không được phụ thuộc vào module cấp thấp. Cả hai phải phụ thuộc vào abstraction (giao diện trừu tượng).
2. Abstraction không được phụ thuộc vào chi tiết. Chi tiết phải phụ thuộc vào abstraction.

Trong Clean Architecture:
- `Presentation` (cấp cao) phụ thuộc vào `UseCase` (Domain).
- `UseCase` (cấp cao) phụ thuộc vào `PostRepository` interface (Domain).
- `PostRepositoryImpl` (cấp thấp - Data) phụ thuộc và implements `PostRepository` interface (Domain).

**Kết quả**: Chiều của dòng phụ thuộc mã nguồn (Source Code Dependency) đi ngược lại với chiều của dòng thực thi (Flow of Control).

```
Flow of Control:
UI (Presentation) ---> UseCase (Domain) ---> PostRepositoryImpl (Data) ---> API Client

Source Code Dependency:
UI (Presentation) ---> UseCase (Domain)
PostRepositoryImpl (Data) ---> PostRepository (Domain)
UseCase (Domain) ---> PostRepository (Domain)
```

Không có bất kỳ mũi tên phụ thuộc mã nguồn nào trỏ từ `Presentation` hay `Domain` sang `Data`.

---

## 3. Repository Pattern & UseCase (Interactor)

### 3.1. UseCase (Interactor)
- Mỗi UseCase chỉ thực hiện một nhiệm vụ duy nhất (`Single Responsibility Principle`).
- Cú pháp triển khai chuẩn:
```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class GetPostsUseCase implements UseCase<List<Post>, NoParams> {
  final PostRepository repository;
  GetPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) {
    return repository.getPosts();
  }
}
```

### 3.2. Repository Contract (Domain)
```dart
abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}
```

### 3.3. Repository Implementation (Data)
```dart
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      final remotePosts = await remoteDataSource.getPosts();
      return Right(remotePosts);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```
