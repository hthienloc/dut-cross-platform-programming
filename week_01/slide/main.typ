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

// Khối code snippet có nền và viền nổi bật
#show raw.where(block: true): block.with(
  fill: rgb("#f8fafc"),
  stroke: 1pt + rgb("#cbd5e0"),
  inset: (x: 10pt, y: 7pt),
  radius: 4pt,
  width: 100%,
)
#show raw.where(block: false): box.with(
  fill: rgb("#edf2f7"),
  inset: (x: 4pt, y: 1pt),
  radius: 3pt,
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
      stroke: 1pt + rgb("#cbd5e0"),
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

#slide(title: "Bài toán & Tiếp cận kiến trúc", outlined: true)[
  - *Yêu cầu:* Đọc và hiển thị danh sách bài viết từ REST API (`jsonplaceholder.typicode.com/posts`).
  #v(0.2em)
  #align(center)[
    #grid(
      columns: (1fr, 1.15fr),
      gutter: 0.7cm,
      [
        #rect(width: 100%, stroke: 1pt + rgb("#e53e3e"), inset: 9pt, radius: 4pt, fill: rgb("#fff5f5"))[
          #align(left)[
            #align(center)[*Tight Coupling*]
            #v(0.2em)
            #text(size: 15pt, fill: rgb("#742a2a"))[
              - Gọi HTTP trực tiếp trong Widget (`initState`). \
              - Logic mạng gắn chặt vào UI. \
              - *Hạn chế:* Không thể Unit Test; đổi API ảnh hưởng trực tiếp đến UI.
            ]
          ]
        ]
      ],
      [
        #rect(width: 100%, stroke: 2pt + rgb("#2f855a"), inset: 9pt, radius: 4pt, fill: rgb("#f0fff4"))[
          #align(left)[
            #align(center)[*Clean Architecture*]
            #v(0.2em)
            #text(size: 15pt, fill: rgb("#22543d"))[
              - *Presentation:* `PostPage` + `PostBloc` \
              - *Domain:* `Post` + `GetPostsUseCase` \
              - *Data:* `RemoteDataSource` + `PostRepoImpl`
            ]
          ]
        ]
      ]
    )
  ]
]

#slide(title: "Trách nhiệm của 3 tầng kiến trúc", outlined: true)[
  #v(-0.3em)
  #align(center)[
    #grid(
      columns: (1fr, 1.05fr, 1fr),
      gutter: 0.45cm,
      [
        #rect(width: 100%, stroke: 2pt + rgb("#2b6cb0"), inset: 8pt, radius: 4pt, fill: rgb("#ebf8ff"))[
          #align(left)[
            #align(center)[*Presentation*]
            #v(0.1em)
            #text(size: 15pt)[
              - *Vai trò:* Hiển thị UI và quản lý trạng thái màn hình.
              - *Thành phần:* `PostPage` (Widget), `PostBloc` (State).
            ]
          ]
        ]
      ],
      [
        #rect(width: 100%, stroke: 2pt + rgb("#2f855a"), inset: 8pt, radius: 4pt, fill: rgb("#f0fff4"))[
          #align(left)[
            #align(center)[*Domain (Core)*]
            #v(0.1em)
            #text(size: 15pt)[
              - *Vai trò:* Nghiệp vụ thuần Dart, độc lập 100% bên ngoài.
              - *Thành phần:* `Post` (Entity), `UseCase`, `Repo Interface`.
            ]
          ]
        ]
      ],
      [
        #rect(width: 100%, stroke: 2pt + rgb("#c53030"), inset: 8pt, radius: 4pt, fill: rgb("#fff5f5"))[
          #align(left)[
            #align(center)[*Data*]
            #v(0.1em)
            #text(size: 15pt)[
              - *Vai trò:* Gọi REST API và parse dữ liệu sang Model.
              - *Thành phần:* `RemoteDataSource`, `PostModel`, `RepoImpl`.
            ]
          ]
        ]
      ]
    )
  ]
  #v(0.1em)
  ```dart
  // PostBloc (Presentation) chỉ gọi UseCase (Domain), nhận Either và emit State:
  final result = await getPostsUseCase();
  result.fold((failure) => emit(PostError(message: 'Lỗi tải dữ liệu')),
              (posts) => emit(PostLoaded(posts: posts)));
  ```
]

#slide(title: "Nguyên lý Dependency Inversion (DIP)", outlined: true)[
  - *Vấn đề:* Nếu UseCase gọi trực tiếp API/Data thì Domain bị phụ thuộc thư viện mạng.
  - *Giải pháp:* Domain định nghĩa Interface hợp đồng, Data triển khai, Presentation sử dụng:
  #v(0.1em)
  ```dart
  // 1. Interface tại Domain (Hợp đồng trừu tượng)
  abstract class PostRepository {
    Future<Either<Failure, List<Post>>> getPosts();
  }
  // 2. Data Layer hiện thực Interface
  class PostRepositoryImpl implements PostRepository { ... }

  // 3. Domain UseCase chỉ nhận Interface qua Constructor Injection
  class GetPostsUseCase {
    final PostRepository repository;
    GetPostsUseCase(this.repository);
    Future<Either<Failure, List<Post>>> call() => repository.getPosts();
  }
  ```
]

// =============================================================
// PHẦN II: DEPENDENCY INJECTION VỚI GET_IT
// =============================================================
#title-slide[
  Phần II: Dependency Injection với get_it
]

#slide(title: "Đăng ký phụ thuộc trong injection_container.dart", outlined: true)[
  - *Vấn đề:* Tự `new` phụ thuộc trong class gây gắn kết chặt và khó kiểm thử, dễ rò rỉ RAM.
  - *Giải pháp:* Đăng ký tập trung bằng `get_it`, phân biệt rõ vòng đời đối tượng:
  #v(0.1em)
  ```dart
  // Stateless: Khởi tạo 1 lần duy nhất trong toàn bộ vòng đời app (tiết kiệm RAM)
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));

  // UI State: Khởi tạo mới theo màn hình, MultiBlocProvider tự close() khi unmount
  sl.registerFactory(() => PostBloc(getPostsUseCase: sl()));
  ```
]

#slide(title: "Khởi tạo hệ thống trong main.dart", outlined: true)[
  - *Khởi tạo WidgetsFlutterBinding:*
    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized(); // Native Engine
      await di.initDependencies();                // Service Locator
      runApp(const MyApp());
    }
    ```
  - *Quản lý BLoC qua MultiBlocProvider:*
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

#slide(title: "Data Flow & Giao diện thực tế", outlined: true)[
  #v(-0.3em)
  #grid(
    columns: (1.25fr, 0.95fr),
    gutter: 0.7cm,
    align: (left + horizon, center + horizon),
    [
      #rect(width: 100%, stroke: 1pt + rgb("#cbd5e0"), inset: 8pt, radius: 4pt, fill: rgb("#f7fafc"))[
        #text(size: 15pt, weight: "bold")[
          REST API $-->$ `RemoteDataSource` \
          $-->$ `PostModel` $-->$ `PostRepoImpl` \
          $-->$ `GetPostsUseCase` $-->$ `PostBloc`
        ]
      ]
      #v(0.3em)
      - *Xử lý 3 trạng thái BLoC:*
        - *Loading:* `CircularProgressIndicator`
        - *Loaded:* `ListView.separated` (`List<Post>`)
        - *Error:* Báo lỗi & nút *Thử lại*
    ],
    [
      #rect(stroke: 1pt + rgb("#cbd5e0"), radius: 4pt, inset: 0pt)[
        #image("demo_ui.png", height: 11cm, fit: "contain")
      ]
    ]
  )
]

#slide(title: "Kiểm thử tự động tầng Domain với Mocktail", outlined: true)[
  - *Vấn đề:* Test phụ thuộc mạng sẽ chậm, thiếu ổn định và không chủ động tạo lỗi server.
  - *Giải pháp:* Mock interface `PostRepository` bằng `mocktail` để kiểm thử biệt lập:
  #v(0.1em)
  ```dart
  // Success Case: Mock trả về dữ liệu mẫu, kiểm tra UseCase nhận đúng dữ liệu
  when(() => mockRepo.getPosts()).thenAnswer((_) async => const Right(tPosts));
  final result = await useCase();
  expect(result, const Right(tPosts));
  verify(() => mockRepo.getPosts()).called(1);

  // Failure Case: Mock trả về lỗi server, kiểm tra UseCase đóng gói lỗi an toàn
  when(() => mockRepo.getPosts()).thenAnswer((_) async => const Left(ServerFailure()));
  final failureResult = await useCase();
  expect(failureResult, const Left(ServerFailure()));
  ```
  #v(0.1em)
  - *Kết quả:* Chạy `flutter test` đạt *5/5 tests pass trong 0.1s*, độc lập 100% với mạng.
]

// =============================================================
// TÀI LIỆU THAM KHẢO CỤ THỂ
// =============================================================
#slide(title: "Tài liệu tham khảo cụ thể", outlined: true)[
  #set text(size: 15pt)
  + *Robert C. Martin (2017)*, _Clean Architecture_, Prentice Hall:
    - *Chương 22 (The Clean Architecture)*: Phân chia 3 tầng và Dependency Rule.
    - *Chương 11 (DIP)*: Nguyên tắc đảo ngược phụ thuộc giữa module cấp cao và cấp thấp.
  + *Reso Coder (2019)*, _Flutter Clean Architecture Proposal_:
    - Thiết kế UseCase và xử lý lỗi Functional với kiểu `Either<Failure, T>`.
  + *Felix Angelov*, _Bloc Library Documentation_ (#link("https://bloclibrary.dev")):
    - Mô hình State Machine trong Flutter và vòng đời `MultiBlocProvider`.
  + *Thomas Burkhart*, _get_it Service Locator_ (#link("https://pub.dev/packages/get_it")):
    - Cơ chế Service Locator, phân biệt `registerLazySingleton` và `registerFactory`.
]
