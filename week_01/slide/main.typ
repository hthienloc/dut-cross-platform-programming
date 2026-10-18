#import "@preview/typslides:1.3.4": *

// =============================================================
// CẤU HÌNH GIAO DIỆN CHUNG (TĂNG SIZE DỄ ĐỌC TRÊN MÁY CHIẾU)
// =============================================================
#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
  font: ("Arial", "DejaVu Sans"),
  font-size: 18.5pt,
  link-style: "color",
  show-progress: true,
)

// =============================================================
// 1. TRANG BÌA (Chuẩn MauBaocaoTuan.pdf - Gói gọn 1 trang)
// =============================================================
#front-slide(
  title: "Chủ đề 04: Kiến trúc Clean Architecture & DI",
  subtitle: [
    TRƯỜNG ĐẠI HỌC BÁCH KHOA — KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO \
    #text(size: 17pt)[*Báo cáo Tuần 01 — Môn: Lập trình Đa nền tảng*]
  ],
  authors: [
    *SVTH:* Huỳnh Thiện Lộc -- *MSSV:* 106230052 \
    *GVHD:* TS. Nguyễn Duy Nhật Viễn
  ],
  info: [Đà Nẵng, 2026],
)

// =============================================================
// 2. MỤC LỤC TỔNG QUAN (Gói gọn 1 trang)
// =============================================================
#table-of-contents(
  title: "Nội dung báo cáo",
  text-size: 17pt,
)

// =============================================================
// 3. PHÂN CÔNG CÔNG VIỆC (BẢNG WBS)
// =============================================================
#slide(title: "Phân công công việc (WBS)", outlined: true)[
  #v(0.1em)
  #align(center)[
    #table(
      columns: (1fr, 3.2fr, 4.8fr, 2fr),
      inset: 10pt,
      align: (center + horizon, left + horizon, left + horizon, center + horizon),
      fill: (x, y) => if y == 0 { rgb("#edf2f7") } else { none },
      stroke: 0.8pt + rgb("#cbd5e0"),
      [*TT*], [*HỌ VÀ TÊN*], [*NỘI DUNG ĐẢM NHẬN*], [*TỶ LỆ*],
      [1], [Huỳnh Thiện Lộc \ (106230052)], [Thiết kế Clean Architecture 3 tầng, cấu hình DI (`get_it`), lập trình BLoC, viết Unit Test Mocktail.], [100%],
    )
  ]
]

// =============================================================
// PHẦN I: KIẾN TRÚC 3 TẦNG & NGUYÊN LÝ DIP
// =============================================================
#title-slide[
  Phần I: Kiến Trúc 3 Tầng & Nguyên Lý DIP
]

#slide(title: "Kiến trúc 3 tầng Clean Architecture", outlined: true)[
  #v(-0.3em)
  #align(center)[
    #grid(
      columns: (1.25fr, auto, 1.4fr, auto, 1.25fr),
      align: center + horizon,
      gutter: 0.4cm,
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#2b6cb0"), inset: 9pt, radius: 4pt, fill: rgb("#ebf8ff"))[
          *Presentation* \
          #text(size: 14pt)[UI Widgets (`PostPage`)\ BLoC (`PostBloc`)]
        ]
      ],
      [#text(size: 20pt, weight: "bold", fill: rgb("#2b6cb0"))[$-->$]],
      [
        #rect(width: 100%, stroke: 2pt + rgb("#2f855a"), inset: 9pt, radius: 4pt, fill: rgb("#f0fff4"))[
          *Domain (Pure Dart)* \
          #text(size: 14pt)[Entities (`Post`)\ UseCases (`GetPosts`)\ Contract (`PostRepo`)]
        ]
      ],
      [#text(size: 20pt, weight: "bold", fill: rgb("#c53030"))[$<--$]],
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#c53030"), inset: 9pt, radius: 4pt, fill: rgb("#fff5f5"))[
          *Data Layer* \
          #text(size: 14pt)[Repo Impl (`PostRepoImpl`)\ DataSource (REST API)\ Model (`PostModel`)]
        ]
      ]
    )
  ]
  #v(0.2em)
  - *Presentation*: Chỉ tương tác với UseCase & Entity, *không import Data*.
  - *Domain (Trọng tâm)*: Thuần Dart 100%, chạy Unit Test trong vài mili-giây.
  - *Data*: Triển khai truy xuất API và hiện thực Interface từ Domain.
]

#slide(title: "Nguyên lý Đảo ngược Phụ thuộc (DIP)", outlined: true)[
  #v(-0.3em)
  #align(center)[
    #grid(
      columns: (1fr, 1.15fr),
      gutter: 0.8cm,
      [
        #rect(width: 100%, stroke: 1.2pt + rgb("#e53e3e"), inset: 9pt, radius: 4pt, fill: rgb("#fff5f5"))[
          *Truyền thống (Khớp nối chặt)* \
          #v(0.1cm)
          `Presentation` $-->$ `RemoteDataSource` \
          #v(0.1cm)
          #text(size: 13.5pt, fill: rgb("#742a2a"))[
            UI phụ thuộc trực tiếp vào HTTP Client. \
            Đổi API / thư viện mạng $-->$ Vỡ toàn bộ UI.
          ]
        ]
      ],
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#2f855a"), inset: 9pt, radius: 4pt, fill: rgb("#f0fff4"))[
          *Áp dụng DIP (Khớp nối lỏng)* \
          #v(0.1cm)
          `Presentation` $-->$ `[PostRepository]` $<--$ `Data` \
          #v(0.1cm)
          #text(size: 13.5pt, fill: rgb("#22543d"))[
            Cả 2 tầng cùng phụ thuộc Interface ở Domain. \
            Đổi REST API sang SQLite/Mock $-->$ UI giữ nguyên.
          ]
        ]
      ]
    )
  ]
  #v(0.1em)
  - *Bản chất*: Chiều phụ thuộc mã nguồn *ngược lại* chiều luồng thực thi dữ liệu.
  - *Bằng chứng*: `post_page.dart` và `post_bloc.dart` không import bất kỳ file nào từ `data/`.
]

// =============================================================
// PHẦN II: DEPENDENCY INJECTION VỚI GET_IT
// =============================================================
#title-slide[
  Phần II: Dependency Injection (DI) & Khởi Tạo Phụ Thuộc
]

#slide(title: "Service Locator với get_it", outlined: true)[
  - *Vai trò DI*: Tập trung khởi tạo tại `injection_container.dart`, không để class tự `new`.
  #v(0.1em)
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 0.8cm,
      [
        #rect(width: 100%, stroke: 1.2pt + rgb("#3182ce"), inset: 9pt, radius: 4pt, fill: rgb("#ebf8ff"))[
          *registerLazySingleton* \
          #text(size: 14pt)[
            - `http.Client` (Client mạng) \
            - `PostRemoteDataSource` \
            - `PostRepository` \
            - `GetPostsUseCase` \
            $->$ _Dùng 1 instance duy nhất để tiết kiệm RAM._
          ]
        ]
      ],
      [
        #rect(width: 100%, stroke: 1.2pt + rgb("#805ad5"), inset: 9pt, radius: 4pt, fill: rgb("#faf5ff"))[
          *registerFactory* \
          #text(size: 14pt)[
            - `PostBloc` (Quản lý trạng thái) \
            $->$ _Tạo instance mới mỗi lần màn hình mở._ \
            $->$ _Tự động dispose qua MultiBlocProvider._ \
            $->$ _Tránh rò rỉ bộ nhớ (Memory Leak)._
          ]
        ]
      ]
    )
  ]
]

#slide(title: "Khởi tạo hệ thống & MultiBlocProvider", outlined: true)[
  - *`WidgetsFlutterBinding.ensureInitialized()`:*
    + Bắt buộc gọi trước khi thực thi `initDependencies()` trong `main.dart`.
    + Đảm bảo Flutter Engine & kênh BinaryMessenger native sẵn sàng trước `runApp()`.
  
  #v(0.3em)
  - *`MultiBlocProvider`:*
    + Nhúng instance `PostBloc` từ `get_it` vào Root Widget Tree.
    + Cung cấp State cho `PostPage` thông qua `BlocBuilder<PostBloc, PostState>`.
    + Tự động gọi `close()` giải phóng bộ nhớ khi widget bị đóng.
]

// =============================================================
// PHẦN III: DEMO THỰC TẾ & UNIT TEST ĐỘC LẬP
// =============================================================
#title-slide[
  Phần III: Demo Thực Tế & Unit Test Tầng Domain
]

#slide(title: "Luồng dữ liệu Demo (Data Flow)", outlined: true)[
  #v(0.1em)
  #align(center)[
    #rect(width: 100%, stroke: 1.2pt + rgb("#cbd5e0"), inset: 10pt, radius: 4pt, fill: rgb("#f7fafc"))[
      #text(size: 14pt, weight: "bold")[
        `JSONPlaceholder API` $-->$ `PostRemoteDataSource` $-->$ `PostModel` \
        #v(0.2em)
        $-->$ `PostRepositoryImpl` $-->$ `Post (Entity)` $-->$ `GetPostsUseCase` \
        #v(0.2em)
        $-->$ `PostBloc (State)` $-->$ `PostPage (UI Trắng Đen)`
      ]
    ]
  ]
  #v(0.2em)
  - *Giao diện tối giản*: Danh sách bài viết trắng đen (`ListTile` + `#ID`), không rườm rà.
  - *Xử lý trạng thái rõ ràng*: Đang tải (`Loading`), Danh sách bài viết (`Loaded`), Mất mạng (`Error` kèm nút Thử lại).
]

#slide(title: "Unit Test Tầng Domain với Mocktail", outlined: true)[
  #v(-0.3em)
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 0.8cm,
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#38a169"), inset: 9pt, radius: 4pt, fill: rgb("#f0fff4"))[
          *Kịch bản 1: Thành công (Success)* \
          #text(size: 14pt)[
            `MockPostRepo` trả về `Right(List<Post>)` \
            $-->$ `UseCase` nhận đúng danh sách \
            $-->$ Xác minh `getPosts()` gọi đúng 1 lần
          ]
        ]
      ],
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#e53e3e"), inset: 9pt, radius: 4pt, fill: rgb("#fff5f5"))[
          *Kịch bản 2: Lỗi máy chủ (Failure)* \
          #text(size: 14pt)[
            `MockPostRepo` trả về `Left(ServerFailure)` \
            $-->$ `UseCase` bắt lỗi an toàn qua `Either` \
            $-->$ Không throw Exception gây crash
          ]
        ]
      ]
    )
  ]
  #v(0.1em)
  - Dùng `mocktail` tạo `MockPostRepository extends Mock implements PostRepository`.
  - Kiểm thử cô lập 100%, không cần kết nối mạng. Kết quả: *5/5 tests pass*.
]

// =============================================================
// TÀI LIỆU THAM KHẢO CỤ THỂ
// =============================================================
#slide(title: "Tài liệu tham khảo chi tiết", outlined: true)[
  #set text(size: 15pt)
  + *Robert C. Martin (2017)*, _Clean Architecture_, Prentice Hall:
    - *Chương 22*: Cơ sở phân chia 3 tầng độc lập & Quy tắc phụ thuộc (Dependency Rule).
    - *Chương 11*: Nguyên lý Đảo ngược Phụ thuộc (DIP).
  + *Reso Coder (2019)*, _Flutter Clean Architecture Proposal_:
    - Kiến trúc phân thư mục, thiết kế `UseCase` & Functional Error với `Either`.
  + *Felix Angelov*, _Bloc Library Documentation_ (#link("https://bloclibrary.dev")):
    - Quản lý trạng thái hướng sự kiện & cơ chế `MultiBlocProvider`.
  + *Thomas Burkhart*, _get_it Service Locator_ (#link("https://pub.dev/packages/get_it")):
    - Vòng đời dịch vụ: `registerLazySingleton` vs `registerFactory`.
]
