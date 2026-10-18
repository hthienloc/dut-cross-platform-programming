#import "@preview/typslides:1.3.4": *

// =============================================================
// CẤU HÌNH GIAO DIỆN
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
  title: "Chủ đề 04: Kiến trúc Clean Architecture & Dependency Injection (DI)",
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
      columns: (1fr, 3.5fr, 4.5fr, 2fr),
      inset: 12pt,
      align: (center + horizon, left + horizon, left + horizon, center + horizon),
      fill: (x, y) => if y == 0 { rgb("#edf2f7") } else { none },
      stroke: 0.8pt + rgb("#cbd5e0"),
      [*TT*], [*HỌ VÀ TÊN*], [*NỘI DUNG ĐẢM NHẬN*], [*TỶ LỆ*],
      [1], [Huỳnh Thiện Lộc \ (106230052)], [Nghiên cứu kiến trúc 3 tầng, thiết kế Domain, cấu hình DI (get_it), viết UI BLoC và Unit Test], [100%],
    )
  ]
]

// =============================================================
// PHẦN I: KIẾN TRÚC 3 TẦNG & NGUYÊN LÝ DIP
// =============================================================
#title-slide[
  Phần I: Kiến Trúc 3 Tầng & Nguyên Lý DIP
]

#slide(title: "Phân chia 3 tầng theo Clean Architecture", outlined: true)[
  - *Presentation (Giao diện):*
    + `PostPage` (UI hiển thị trắng đen tối giản) & `PostBloc` (quản lý trạng thái).
    + Chỉ nhận dữ liệu từ Domain, *không biết dữ liệu lấy từ đâu*.
  
  - *Domain (Nghiệp vụ - Pure Dart 100%):*
    + `Post` (Entity), `GetPostsUseCase` (hành động nghiệp vụ), `PostRepository` (Hợp đồng Interface).
    + Không dính líu Flutter hay HTTP, giúp chạy Unit Test độc lập tính bằng mili-giây.

  - *Data (Nguồn dữ liệu):*
    + `PostRemoteDataSource` (gọi REST API), `PostModel` (parse JSON), `PostRepositoryImpl` (thực hiện hợp đồng).
]

#slide(title: "Nguyên lý Đảo ngược Phụ thuộc (DIP)", outlined: true)[
  - *Bản chất của DIP:*
    + Module cấp cao (`Presentation`) và module cấp thấp (`Data`) cùng phụ thuộc vào *Interface trừu tượng* ở giữa (`Domain`).

  #v(0.4em)
  #framed(title: "Minh chứng trong mã nguồn dự án")[
    1. Tầng `Domain` đặt ra hợp đồng: `abstract class PostRepository`.
    2. Tầng `Data` hiện thực hợp đồng: `class PostRepositoryImpl implements PostRepository`.
    3. Tầng `Presentation` (BLoC) chỉ gọi `GetPostsUseCase`, không bao giờ import tầng Data.
    $->$ Khi đổi nguồn dữ liệu (REST API $-->$ SQLite hoặc Mock), tầng UI giữ nguyên 100%.
  ]
]

// =============================================================
// PHẦN II: DEPENDENCY INJECTION VỚI GET_IT
// =============================================================
#title-slide[
  Phần II: Dependency Injection (DI) & Khởi Tạo Phụ Thuộc
]

#slide(title: "Service Locator với get_it", outlined: true)[
  - *Tại sao cần DI?*
    + Không để các lớp tự khởi tạo (`new`) lẫn nhau, giúp code lỏng lẻo (loose coupling) và dễ test.
  
  #v(0.3em)
  - *Hai cơ chế đăng ký trong file `injection_container.dart`:*
    + `registerLazySingleton`: Tạo duy nhất 1 bản thể khi được gọi lần đầu (tiết kiệm bộ nhớ cho `HttpClient`, `DataSource`, `Repository`, `UseCase`).
    + `registerFactory`: Tạo mới 1 bản thể mỗi lần yêu cầu (dùng cho `PostBloc` gắn theo vòng đời màn hình).
]

#slide(title: "Khởi tạo hệ thống & MultiBlocProvider", outlined: true)[
  - *`WidgetsFlutterBinding.ensureInitialized()`:*
    + Đảm bảo Flutter Engine và kênh giao tiếp nền tảng sẵn sàng trước khi nạp service bất đồng bộ (`async`) trong `main()`.

  #v(0.3em)
  - *`MultiBlocProvider`:*
    + Lấy instance `PostBloc` từ `get_it` và đưa vào cây widget của Flutter.
    + Tự động gọi `close()` giải phóng bộ nhớ khi màn hình bị hủy, chống rò rỉ RAM (Memory Leak).
]

// =============================================================
// PHẦN III: DEMO THỰC TẾ & UNIT TEST ĐỘC LẬP
// =============================================================
#title-slide[
  Phần III: Demo Thực Tế & Unit Test Tầng Domain
]

#slide(title: "Ứng dụng Demo REST API tối giản", outlined: true)[
  - *Nguồn dữ liệu:* JSONPlaceholder (`https://jsonplaceholder.typicode.com/posts`).
  - *Giao diện:* Phong cách trắng đen tối giản, tập trung hoàn toàn vào việc thể hiện luồng dữ liệu 3 tầng:
    + Đang tải $-->$ Vòng xoay tiến trình (`Loading`).
    + Tải xong $-->$ Danh sách bài viết bài bản (`Loaded`).
    + Mất mạng $-->$ Thông báo lỗi & nút Thử lại (`Error`).
  - *Bằng chứng tách biệt:* File `post_page.dart` tuyệt đối không có dòng import `data/`.
]

#slide(title: "Unit Test Tầng Domain với Mocktail", outlined: true)[
  - *Kỹ thuật Mocking:*
    + Dùng thư viện `mocktail` tạo `MockPostRepository extends Mock implements PostRepository`.
    + Đóng vai "người cung cấp dữ liệu giả", test độc lập UseCase không cần mạng Internet.

  #v(0.3em)
  #framed(title: "Kết quả kiểm thử tự động (flutter test)")[
    - Test Case 1: Lấy dữ liệu thành công $-->$ UseCase trả về `Right(List<Post>)`.
    - Test Case 2: Máy chủ phản hồi lỗi $-->$ UseCase trả về `Left(ServerFailure)`.
    - *Kết quả thực tế:* 5/5 test cases pass 100% trong thời gian $< 1$ giây.
  ]
]

// =============================================================
// TÀI LIỆU THAM KHẢO
// =============================================================
#slide(title: "Tài liệu tham khảo", outlined: true)[
  + Robert C. Martin (2017), _Clean Architecture: A Craftsman's Guide to Software Structure and Design_.
  + Flutter Official Documentation: Architectural Overview & Testing.
  + BLoC Library Documentation: #link("https://bloclibrary.dev")
  + Mã nguồn hoàn chỉnh: #link("https://github.com/hthienloc/dut-cross-platform-programming")
]
