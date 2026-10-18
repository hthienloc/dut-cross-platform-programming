#import "@preview/typslides:1.3.4": *

// =============================================================
// CẤU HÌNH GIAO DIỆN (ĐỘ LỚN CHỮ RÕ NÉT TRÊN MÁY CHIẾU)
// =============================================================
#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
  font: ("Arial", "DejaVu Sans"),
  font-size: 18pt,
  link-style: "color",
  show-progress: true,
)

// =============================================================
// 1. TRANG BÌA
// =============================================================
#front-slide(
  title: "Áp Dụng Clean Architecture & DI Trong Flutter",
  subtitle: [
    TRƯỜNG ĐẠI HỌC BÁCH KHOA — KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO \
    #text(size: 16pt)[*Chủ đề 04: Báo cáo Tuần 01 — Môn: Lập trình Đa nền tảng*]
  ],
  authors: [
    *SVTH:* Huỳnh Thiện Lộc -- *MSSV:* 106230052 \
    *GVHD:* TS. Nguyễn Duy Nhật Viễn
  ],
  info: [Đà Nẵng, 2026],
)

// =============================================================
// 2. MỤC LỤC BÁO CÁO
// =============================================================
#table-of-contents(
  title: "Nội dung báo cáo",
  text-size: 17pt,
)

// =============================================================
// 3. BẢNG PHÂN CÔNG WBS
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
      [1], [Huỳnh Thiện Lộc \ (106230052)], [Thiết kế 3 tầng Clean Arch, triển khai DI (`get_it`), lập trình BLoC và viết Unit Test Mocktail.], [100%],
    )
  ]
]

// =============================================================
// PHẦN I: BÀI TOÁN & THIẾT KẾ 3 TẦNG THỰC TẾ
// =============================================================
#title-slide[
  Phần I: Bài Toán Thực Tế & Thiết Kế 3 Tầng
]

#slide(title: "Bài toán thực tế & Vấn đề cách làm cũ", outlined: true)[
  - *Bài toán đặt ra:* Xây dựng ứng dụng đọc 100 bài viết từ REST API (`jsonplaceholder.typicode.com/posts`) và hiển thị mượt mà.
  #v(0.1em)
  #align(center)[
    #grid(
      columns: (1fr, 1.15fr),
      gutter: 0.7cm,
      [
        #rect(width: 100%, stroke: 1.2pt + rgb("#e53e3e"), inset: 8pt, radius: 4pt, fill: rgb("#fff5f5"))[
          *Cách viết cũ (Spaghetti / Naïve)* \
          #text(size: 13.5pt, fill: rgb("#742a2a"))[
            - Nhét `http.get` trực tiếp trong `initState()` của UI Widget. \
            - Lẫn lộn parse JSON và logic hiển thị. \
            - *Hệ quả:* Không thể Unit Test nếu không có mạng; đổi API là phải đập đi sửa lại UI.
          ]
        ]
      ],
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#2f855a"), inset: 8pt, radius: 4pt, fill: rgb("#f0fff4"))[
          *Giải pháp: Clean Architecture 3 Tầng* \
          #text(size: 13.5pt, fill: rgb("#22543d"))[
            - *Presentation:* `PostPage` + `PostBloc` (UI). \
            - *Domain:* `Post` + `GetPostsUseCase` (Nghiệp vụ thuần Dart). \
            - *Data:* `PostRemoteDataSource` + `PostRepoImpl` (Gọi HTTP REST API).
          ]
        ]
      ]
    )
  ]
]

#slide(title: "Áp dụng 3 tầng trong mã nguồn dự án", outlined: true)[
  #v(-0.3em)
  #align(center)[
    #grid(
      columns: (1.25fr, auto, 1.45fr, auto, 1.25fr),
      align: center + horizon,
      gutter: 0.35cm,
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#2b6cb0"), inset: 8pt, radius: 4pt, fill: rgb("#ebf8ff"))[
          *Presentation* \
          #text(size: 13.5pt)[`PostPage.dart` \ `PostBloc.dart` \ _(Chỉ quản lý UI/State)_]
        ]
      ],
      [#text(size: 18pt, weight: "bold", fill: rgb("#2b6cb0"))[$-->$]],
      [
        #rect(width: 100%, stroke: 2pt + rgb("#2f855a"), inset: 8pt, radius: 4pt, fill: rgb("#f0fff4"))[
          *Domain (Pure Dart)* \
          #text(size: 13.5pt)[`Post.dart` (Entity) \ `GetPostsUseCase.dart` \ `PostRepository.dart`]
        ]
      ],
      [#text(size: 18pt, weight: "bold", fill: rgb("#c53030"))[$<--$]],
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#c53030"), inset: 8pt, radius: 4pt, fill: rgb("#fff5f5"))[
          *Data Layer* \
          #text(size: 13.5pt)[`PostModel.dart` \ `RemoteDataSource.dart` \ `PostRepoImpl.dart`]
        ]
      ]
    )
  ]
  #v(0.2em)
  - `PostBloc` chỉ gọi `GetPostsUseCase` và nhận kết quả an toàn bằng `Either<Failure, List<Post>>`.
  - Toàn bộ tầng Presentation *không có bất kỳ dòng nào import thư mục `data/`*.
]

#slide(title: "Áp dụng nguyên lý DIP vào mã nguồn", outlined: true)[
  - *Vấn đề cần giải quyết:* Không để Presentation và UseCase phụ thuộc vào `http.Client` hay URL API cụ thể.
  #v(0.1em)
  #align(center)[
    #rect(width: 100%, stroke: 1.5pt + rgb("#2f855a"), inset: 10pt, radius: 4pt, fill: rgb("#f0fff4"))[
      #text(size: 14pt)[
        *Hợp đồng trừu tượng (Interface tại Domain):* \
        `abstract class PostRepository { Future<Either<Failure, List<Post>>> getPosts(); }` \
        #v(0.2em)
        *Hiện thực tại Data:* `class PostRepositoryImpl implements PostRepository { ... }` \
        *Sử dụng tại Presentation:* `PostBloc` nhận `GetPostsUseCase(repository: sl())`
      ]
    ]
  ]
  #v(0.2em)
  - *Ý nghĩa thực tế:* Khi chuyển từ REST API sang Mock test (hoặc Local Cache sau này), code của BLoC và giao diện `PostPage` giữ nguyên 100%, không cần sửa đổi.
]

// =============================================================
// PHẦN II: DEPENDENCY INJECTION VỚI GET_IT
// =============================================================
#title-slide[
  Phần II: Hiện Thực Dependency Injection với get_it
]

#slide(title: "Tổ chức Container trong injection_container.dart", outlined: true)[
  - Thay vì class tự khởi tạo phụ thuộc, toàn bộ chuỗi phụ thuộc được nối tại một file duy nhất:
  #v(0.1em)
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 0.7cm,
      [
        #rect(width: 100%, stroke: 1.2pt + rgb("#3182ce"), inset: 9pt, radius: 4pt, fill: rgb("#ebf8ff"))[
          *registerLazySingleton (Tạo 1 lần)* \
          #text(size: 13.5pt)[
            - `http.Client` (Client mạng) \
            - `PostRemoteDataSourceImpl(client: sl())` \
            - `PostRepositoryImpl(remoteDataSource: sl())` \
            - `GetPostsUseCase(sl())` \
            $->$ _Tiết kiệm bộ nhớ RAM cho các lớp Stateless._
          ]
        ]
      ],
      [
        #rect(width: 100%, stroke: 1.2pt + rgb("#805ad5"), inset: 9pt, radius: 4pt, fill: rgb("#faf5ff"))[
          *registerFactory (Tạo mới)* \
          #text(size: 13.5pt)[
            - `PostBloc(getPostsUseCase: sl())` \
            $->$ _Tạo instance BLoC mới cho màn hình._ \
            $->$ _Đảm bảo giải phóng tự động qua MultiBlocProvider._ \
            $->$ _Tránh rò rỉ trạng thái giữa các lần mở._
          ]
        ]
      ]
    )
  ]
]

#slide(title: "Khởi tạo hệ thống trong main.dart", outlined: true)[
  - *Khởi tạo liên kết (`WidgetsFlutterBinding`):*
    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized(); // Kết nối Native Engine
      await di.initDependencies();                // Nạp Service Locator
      runApp(const MyApp());
    }
    ```
  - *Liên kết phụ thuộc giao diện (`MultiBlocProvider`):*
    ```dart
    MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(create: (_) => di.sl<PostBloc>()..add(FetchPostsEvent())),
      ],
      child: const MaterialApp(home: PostPage()),
    )
    ```
]

// =============================================================
// PHẦN III: DEMO THỰC TẾ & UNIT TEST ĐA TẦNG
// =============================================================
#title-slide[
  Phần III: Demo Thực Tế & Kết Quả Kiểm Thử
]

#slide(title: "Luồng thực thi dữ liệu thực tế (Data Flow)", outlined: true)[
  #v(0.1em)
  #align(center)[
    #rect(width: 100%, stroke: 1.2pt + rgb("#cbd5e0"), inset: 9pt, radius: 4pt, fill: rgb("#f7fafc"))[
      #text(size: 13.5pt, weight: "bold")[
        `jsonplaceholder.typicode.com/posts` $-->$ `PostRemoteDataSourceImpl` \
        #v(0.2em)
        $-->$ `PostModel.fromJson` $-->$ `PostRepositoryImpl` $-->$ `Post (Entity)` \
        #v(0.2em)
        $-->$ `GetPostsUseCase` $-->$ `PostBloc` $-->$ `PostPage (UI Trắng Đen)`
      ]
    ]
  ]
  #v(0.2em)
  - *Giao diện tối giản trắng đen:* Tập trung chứng minh xử lý 3 trạng thái:
    1. Đang tải: `CircularProgressIndicator` (Màu đen).
    2. Thành công: `ListView.separated` hiển thị danh sách 100 bài viết (`#ID`, title, body).
    3. Mất mạng: Icon lỗi, thông báo lỗi tiếng Việt và nút *Thử lại* (`FetchPostsEvent`).
]

#slide(title: "Kiểm thử tự động tầng Domain với Mocktail", outlined: true)[
  - *Giải quyết bài toán kiểm thử độc lập:* Sử dụng `mocktail` tạo `MockPostRepository`:
  #v(0.1em)
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 0.7cm,
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#38a169"), inset: 9pt, radius: 4pt, fill: rgb("#f0fff4"))[
          *Kịch bản Thành công (Success)* \
          #text(size: 13.5pt)[
            Mock trả về `Right(List<Post>)` \
            $-->$ `UseCase` nhận đúng 2 bài viết mẫu \
            $-->$ `verify(repo.getPosts()).called(1)`
          ]
        ]
      ],
      [
        #rect(width: 100%, stroke: 1.5pt + rgb("#e53e3e"), inset: 9pt, radius: 4pt, fill: rgb("#fff5f5"))[
          *Kịch bản Lỗi máy chủ (Failure)* \
          #text(size: 13.5pt)[
            Mock trả về `Left(ServerFailure)` \
            $-->$ `UseCase` đóng gói lỗi an toàn \
            $-->$ Không crash ứng dụng
          ]
        ]
      ]
    )
  ]
  #v(0.1em)
  - Kết quả chạy lệnh `flutter test`: *5/5 tests pass 100% trong 0.1 giây*, hoàn toàn không cần kết nối mạng Internet.
]

// =============================================================
// TÀI LIỆU THAM KHẢO CỤ THỂ
// =============================================================
#slide(title: "Tài liệu tham khảo cụ thể", outlined: true)[
  #set text(size: 15pt)
  + *Robert C. Martin (2017)*, _Clean Architecture_, Prentice Hall:
    - *Chương 22 (The Clean Architecture)*: Quy tắc phân chia 3 tầng & Chiều phụ thuộc mã nguồn.
    - *Chương 11 (DIP)*: Nguyên tắc đảo ngược phụ thuộc giữa Module cấp cao và cấp thấp.
  + *Reso Coder (2019)*, _Flutter Clean Architecture Proposal_:
    - Thiết kế `UseCase` (Interactor) và xử lý lỗi Functional bằng kiểu `Either<Failure, T>`.
  + *Felix Angelov*, _Bloc Library Documentation_ (#link("https://bloclibrary.dev")):
    - Mô hình State Machine trong Flutter và cơ chế vòng đời `MultiBlocProvider`.
  + *Thomas Burkhart*, _get_it Service Locator_ (#link("https://pub.dev/packages/get_it")):
    - Cơ chế Service Locator & phân biệt vòng đời `registerLazySingleton` vs `registerFactory`.
]
