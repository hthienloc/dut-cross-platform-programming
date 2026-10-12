#import "@preview/typslides:1.3.4": *

// =============================================================
// CẤU HÌNH GIAO DIỆN CHUNG
// =============================================================
#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
  font: ("Arial", "DejaVu Sans"),
  font-size: 19pt,
  link-style: "color",
  show-progress: true,
)

// =============================================================
// 1. TRANG BÌA (Theo MauBaocaoTuan.pdf)
// =============================================================
#front-slide(
  title: "Chủ đề 04: Kiến trúc Clean Architecture & Dependency Injection",
  subtitle: [
    TRƯỜNG ĐẠI HỌC BÁCH KHOA — ĐẠI HỌC ĐÀ NẴNG \
    KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO \
    #v(0.3em)
    *Báo cáo Tuần 01 — Môn: Lập trình Đa nền tảng*
  ],
  authors: [
    *SVTH:* Huỳnh Thiện Lộc -- *MSSV:* 106230052 \
    #v(0.2em)
    *GVHD:* TS. Nguyễn Duy Nhật Viễn
  ],
  info: [Đà Nẵng, 2026],
)

// =============================================================
// 2. MỤC LỤC
// =============================================================
#table-of-contents(title: "Nội dung báo cáo")

// =============================================================
// 3. PHÂN CÔNG CÔNG VIỆC (BẢNG WBS)
// =============================================================
#slide(title: "Phân công công việc (WBS)", outlined: true)[
  #v(0.3em)
  #align(center)[
    #table(
      columns: (1fr, 3fr, 5fr, 2fr),
      inset: 11pt,
      align: (center + horizon, left + horizon, left + horizon, center + horizon),
      fill: (x, y) => if y == 0 { rgb("#edf2f7") } else { none },
      stroke: 0.8pt + rgb("#cbd5e0"),
      [*TT*], [*HỌ VÀ TÊN*], [*NỘI DUNG ĐẢM NHẬN*], [*TỶ LỆ*],
      [1], [Huỳnh Thiện Lộc \ (106230052)], [Nghiên cứu Clean Architecture, thiết kế tầng Domain, cấu hình DI (get_it), triển khai tầng Data & Presentation (BLoC), viết Unit Test], [100%],
    )
  ]
]

// =============================================================
// PHẦN I: CƠ SỞ LÝ THUYẾT & NGUYÊN LÝ
// =============================================================
#title-slide[
  Phần I: Cơ Sở Lý Thuyết & Nguyên Lý Cốt Lõi
]

#slide(title: "Tổng quan Clean Architecture trong Flutter", outlined: true)[
  - *Mục tiêu cốt lõi:* Tách biệt các mối bận tâm (*Separation of Concerns*).
  - *3 Tầng kiến trúc tiêu chuẩn:*
    1. *Presentation Layer:* Quản lý giao diện (Widgets) và trạng thái (BLoC / Cubit).
    2. *Domain Layer (Trung tâm):* Chứa thực thể nghiệp vụ (Entities), hành động nghiệp vụ (UseCases) và hợp đồng trừu tượng (Repository Contracts). Thuần Dart, độc lập 100%.
    3. *Data Layer:* Triển khai truy xuất dữ liệu thực tế (REST API, SQLite, Cache) và hiện thực Repository từ Domain.
  
  #v(0.3em)
  #framed(title: "Quy tắc phụ thuộc (The Dependency Rule)")[
    Tầng ngoài phụ thuộc vào tầng trong. Tầng trong *tuyệt đối không biết gì* về tầng ngoài.
  ]
]

#slide(title: "Nguyên lý Đảo ngược Phụ thuộc (DIP)", outlined: true)[
  - *Phát biểu (SOLID - 'D'):*
    + Module cấp cao không phụ thuộc vào module cấp thấp. Cả hai cùng phụ thuộc vào *trừu tượng (Interface)*.
    + Giao diện trừu tượng không phụ thuộc chi tiết; chi tiết phụ thuộc vào trừu tượng.

  #v(0.3em)
  #cols(columns: (1fr, 1fr), gutter: 1em)[
    *Truyền thống (Tight Coupling):* \
    `Presentation` $-->$ `RemoteDataSource` \
    #stress[Hệ quả:] Thay đổi API hoặc client mạng sẽ làm vỡ giao diện.
  ][
    *Áp dụng DIP (Loose Coupling):* \
    `Presentation` $-->$ `PostRepository` (Interface) \
    `PostRepositoryImpl` $-->$ `PostRepository` \
    #stress[Kết quả:] Chiều phụ thuộc mã nguồn đảo ngược so với chiều thực thi.
  ]
]

#slide(title: "Repository Pattern & UseCase (Interactor)", outlined: true)[
  #cols(columns: (1fr, 1fr), gutter: 1.2em)[
    *UseCase (Interactor):*
    - Đại diện cho một hành động nghiệp vụ duy nhất (`Single Responsibility`).
    - Thực thi qua callable class: `useCase(params)`.
    - Trả về kết quả an toàn bằng `Either<Failure, T>` (Functional Error Handling).
  ][
    *Repository Pattern:*
    - Là cầu nối trừu tượng giữa Domain và Data.
    - Che giấu toàn bộ chi tiết kết nối mạng, parsing JSON hay lưu cache.
    - Giúp tầng Presentation hoàn toàn độc lập với nguồn gốc dữ liệu.
  ]
]

// =============================================================
// PHẦN II: DEPENDENCY INJECTION & LIÊN KẾT PHỤ THUỘC
// =============================================================
#title-slide[
  Phần II: Dependency Injection & Khởi Tạo Phụ Thuộc
]

#slide(title: "Service Locator với get_it", outlined: true)[
  - *Bản chất của DI:* Cung cấp đối tượng phụ thuộc từ bên ngoài vào class thay vì để class tự `new`.
  - *Các vòng đời đăng ký trong `get_it`:*
    + `registerLazySingleton`: Chỉ tạo instance 1 lần khi được gọi lần đầu (dùng cho `HttpClient`, `DataSource`, `Repository`, `UseCase`).
    + `registerFactory`: Mỗi lần gọi tạo mới 1 instance (dùng cho `BLoC/Cubit` gắn theo widget).

  #v(0.3em)
  #framed(title: "WidgetsFlutterBinding.ensureInitialized()")[
    Bắt buộc gọi trước khi cấu hình DI bất đồng bộ hoặc nạp dịch vụ native trước `runApp()`.
  ]
]

#slide(title: "Liên kết với MultiBlocProvider", outlined: true)[
  - *Cơ chế hoạt động:*
    1. `main()` nạp cấu hình `initDependencies()` qua `get_it`.
    2. `MultiBlocProvider` inject instance BLoC vào cây widget của Flutter.
    3. UI Widget lắng nghe qua `BlocBuilder` hoặc `context.read<PostBloc>()`.
  
  #v(0.3em)
  - *Lợi ích:* BLoC được tự động giải phóng (`close()`) theo vòng đời của Widget Tree, tránh rò rỉ bộ nhớ (Memory Leak).
]

// =============================================================
// PHẦN III: DEMO THỰC TẾ & UNIT TEST TẦNG DOMAIN
// =============================================================
#title-slide[
  Phần III: Demo Thực Tế & Unit Test Tầng Domain
]

#slide(title: "Kiến trúc ứng dụng Demo REST API", outlined: true)[
  - *Bài toán:* Ứng dụng đọc danh sách bài viết từ REST API (`jsonplaceholder.typicode.com/posts`).
  
  #v(0.2em)
  - *Luồng thực thi dữ liệu:*
    `REST API` $-->$ `PostRemoteDataSource` $-->$ `PostModel` $-->$ `PostRepositoryImpl` $-->$ `PostEntity` $-->$ `GetPostsUseCase` $-->$ `PostBloc` $-->$ `PostPage (UI)`.

  #v(0.3em)
  #framed(title: "Bằng chứng Presentation không phụ thuộc Data Source")[
    Tầng Presentation chỉ import `domain/`. Khi đổi DataSource sang Mock hoặc Local Cache, không một dòng code nào trong `presentation/` bị thay đổi.
  ]
]

#slide(title: "Kịch bản Unit Test Tầng Domain với Mocktail", outlined: true)[
  - *Kỹ thuật Mocking:* Tạo `MockPostRepository extends Mock implements PostRepository`.
  - *Đặc điểm:* Kiểm thử độc lập 100% trong mili-giây, không gọi mạng thật, không dựng widget.

  #v(0.3em)
  #framed(title: "Kịch bản kiểm thử (flutter test)")[
    - *Test 1 (Success):* Mock trả về `Right(List<Post>)` $-->$ UseCase trả về đúng danh sách bài viết, xác minh repository được gọi đúng 1 lần.
    - *Test 2 (Failure):* Mock trả về `Left(ServerFailure)` $-->$ UseCase chuyển tiếp failure an toàn, không gây unhandled exception.
  ]
]

// =============================================================
// TÀI LIỆU THAM KHẢO
// =============================================================
#slide(title: "Tài liệu tham khảo", outlined: true)[
  + Robert C. Martin (2017), _Clean Architecture: A Craftsman's Guide to Software Structure and Design_.
  + Flutter Official Documentation: #link("https://docs.flutter.dev")
  + Reso Coder, _Flutter Clean Architecture Proposal_.
  + BLoC State Management: #link("https://bloclibrary.dev")
  + Mã nguồn Tuần 1: Thư mục `week_01/app` trong repository.
]
