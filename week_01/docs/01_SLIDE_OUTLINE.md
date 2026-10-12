# Đề Cương Slide Báo Cáo Tuần — Chủ Đề 04
*Áp dụng theo định dạng `MauBaocaoTuan.pdf` (Đại học Bách Khoa - Khoa Điện tử & AI)*

---

## Slide 1: Trang tiêu đề
- **Tiêu đề**: TRƯỜNG ĐẠI HỌC BÁCH KHOA — KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO
- **Loại báo cáo**: Báo cáo Tuần — Môn: Lập trình Đa nền tảng
- **Tên chủ đề**: Chủ đề 04: Kiến trúc ứng dụng Flutter — Clean Architecture & Dependency Injection (DI)
- **SVTH**: Huỳnh Thiện Lộc - 106230052
- **GVHD**: TS. Nguyễn Duy Nhật Viễn
- **Địa điểm & Năm**: Đà Nẵng, 2026

---

## Slide 2: Nội dung báo cáo (Agenda)
1. **Tổng quan Clean Architecture trong Flutter** (Phân chia 3 tầng: Presentation, Domain, Data).
2. **Nguyên lý Đảo ngược Phụ thuộc (DIP)** & Hướng dòng điều khiển vs Dòng phụ thuộc.
3. **Repository Pattern & UseCase (Interactor)**.
4. **Dependency Injection (DI)**: Vai trò, cơ chế hoạt động của `get_it`, `WidgetsFlutterBinding` & `MultiBlocProvider`.
5. **Ứng dụng Demo & Unit Test tầng Domain**:
   - Kiến trúc mã nguồn thực tế.
   - Mock Abstract Interface để kiểm thử độc lập.
   - Bằng chứng tầng Presentation không phụ thuộc tầng Data.
6. **Tài liệu tham khảo**.

---

## Slide 3: Phân công công việc (Task Allocation)
| TT | Họ và tên | Nội dung đảm nhận | Tỷ lệ đóng góp |
|---|---|---|---|
| 1 | Huỳnh Thiện Lộc (106230052) | Nghiên cứu Clean Architecture, thiết kế kiến trúc 3 tầng, cấu hình DI (`get_it`), lập trình BLoC và Unit test tầng Domain | 100% |

---

## Slide 4: Tổng quan Clean Architecture
- **Mục tiêu**: Tách biệt mối bận tâm (Separation of Concerns), tăng khả năng bảo trì, mở rộng và kiểm thử độc lập mà không phụ thuộc vào framework giao diện hay nguồn dữ liệu.
- **Quy tắc phụ thuộc (The Dependency Rule)**: Tầng bên trong không được biết bất kỳ điều gì về tầng bên ngoài.
  - `Domain` (Trung tâm): Hoàn toàn độc lập, chứa Business Logic và Entities. Thuần Dart.
  - `Data` (Tầng ngoài): Triển khai repository, tương tác REST API, Local DB.
  - `Presentation` (Tầng ngoài): Giao diện người dùng (Widgets, Screens) và Quản lý trạng thái (BLoC/Cubit).

---

## Slide 5: Nguyên lý Đảo ngược Phụ thuộc (DIP)
- **Định nghĩa**:
  1. Các module cấp cao không nên phụ thuộc vào module cấp thấp. Cả hai nên phụ thuộc vào trừu tượng (Abstractions / Interfaces).
  2. Sự trừu tượng không phụ thuộc vào chi tiết; chi tiết phải phụ thuộc vào sự trừu tượng.
- **Áp dụng trong Flutter**:
  - `Domain` định nghĩa abstract interface: `abstract class PostRepository`.
  - `Data` kế thừa và hiện thực: `class PostRepositoryImpl implements PostRepository`.
  - `Presentation` (BLoC) chỉ gọi `GetPostsUseCase`, usecase chỉ gọi `PostRepository`, không hề import `PostRemoteDataSource` hay `Dio`.

---

## Slide 6: Repository Pattern & UseCase (Interactor)
- **UseCase (Interactor)**:
  - Đại diện cho một hành động nghiệp vụ duy nhất (Single Responsibility Principle), ví dụ: `GetPostsUseCase`, `GetPostDetailUseCase`.
  - Giúp tái sử dụng logic ở nhiều màn hình khác nhau mà không lặp lại code.
- **Repository Pattern**:
  - Đóng vai trò là cầu nối trừu tượng giữa tầng nghiệp vụ và nguồn dữ liệu thực tế (REST API, Cache, SQLite).
  - Ẩn giấu chi tiết lưu trữ hoặc truy vấn HTTP phía sau các hàm nghiệp vụ (`Future<Either<Failure, List<Post>>> getPosts()`).

---

## Slide 7: Dependency Injection (DI) & Cơ chế Khởi tạo
- **Khái niệm DI**: Cung cấp dependency từ bên ngoài vào đối tượng thay vì để đối tượng tự khởi tạo `new`.
- **Cơ chế triển khai**:
  - `WidgetsFlutterBinding.ensureInitialized()`: Đảm bảo Flutter Engine và kênh giao tiếp native sẵn sàng trước khi nạp service.
  - `get_it`: Service Locator đóng gói đăng ký Lazy Singleton / Factory cho DataSource, Repository, UseCase.
  - `MultiBlocProvider`: Cung cấp instance BLoC/Cubit được inject vào cây widget, kiểm soát vòng đời (dispose) tự động theo ngữ cảnh UI.

---

## Slide 8: Ứng dụng Demo (Kiến trúc & Luồng hoạt động)
- **REST API**: JSONPlaceholder (`https://jsonplaceholder.typicode.com/posts`).
- **Sơ đồ luồng**:
  `REST API` $\rightarrow$ `PostRemoteDataSource` $\rightarrow$ `PostModel` $\rightarrow$ `PostRepositoryImpl` $\rightarrow$ `PostEntity` $\rightarrow$ `GetPostsUseCase` $\rightarrow$ `PostBloc` $\rightarrow$ `PostPage (UI)`.
- Minh họa rõ ràng việc thay thế `PostRemoteDataSource` sang `PostLocalDataSource` hoặc `MockPostRepository` mà tầng Presentation không cần sửa đổi bất kỳ dòng mã nào.

---

## Slide 9: Unit Test tầng Domain với Mock Dependency
- **Kỹ thuật**: Sử dụng `mocktail` tạo `MockPostRepository extends Mock implements PostRepository`.
- **Kịch bản kiểm thử**:
  - Thành công: Mock trả về `Right(List<Post>)` $\rightarrow$ UseCase phát ra danh sách bài viết hợp lệ.
  - Thất bại: Mock trả về `Left(ServerFailure)` $\rightarrow$ UseCase xử lý ngoại lệ và trả về đúng failure tương ứng.
- **Kết luận**: Tầng Domain được kiểm thử cô lập 100% trong mili-giây, không cần mạng, không cần khởi chạy thiết bị giả lập/UI.

---

## Slide 10: Tài liệu tham khảo
1. Robert C. Martin (Uncle Bob), *Clean Architecture: A Craftsman's Guide to Software Structure and Design*, Prentice Hall.
2. Reso Coder, *Flutter Clean Architecture Proposal*.
3. Flutter Official Documentation: *Testing Flutter apps*, *State Management with BLoC*.
4. Package documentation: `get_it`, `flutter_bloc`, `mocktail`.
