#import "@preview/typslides:1.3.4": *

// =============================================================
// CẤU HÌNH GIAO DIỆN CHUNG (TYPSLIDES BOILERPLATE)
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
// 1. TRANG BÌA (Theo mẫu MauBaocaoTuan.pdf)
// =============================================================
#front-slide(
  title: "TÊN CHỦ ĐỀ BÁO CÁO",
  subtitle: [
    TRƯỜNG ĐẠI HỌC BÁCH KHOA — ĐẠI HỌC ĐÀ NẴNG \
    KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO \
    #v(0.3em)
    *Báo cáo Tuần — Môn: Lập trình Đa nền tảng*
  ],
  authors: [
    1. Nguyễn Văn A -- MSSV: xxxxxxxxxx \
    2. Trần Thị B -- MSSV: xxxxxxxxxx \
    #v(0.2em)
    *GVHD:* TS. Nguyễn Duy Nhật Viễn
  ],
  info: [Đà Nẵng, 2026],
)

// =============================================================
// 2. MỤC LỤC TỔNG QUAN
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
      [1], [Nguyễn Văn A], [Nghiên cứu lý thuyết, thiết kế kiến trúc, viết UseCase & Unit Test], [50%],
      [2], [Trần Thị B], [Thiết lập DI, hiện thực tầng Data/API, xây dựng giao diện UI & BLoC], [50%],
    )
  ]
]

// =============================================================
// PHẦN I: CƠ SỞ LÝ THUYẾT & BẢN CHẤT CÔNG NGHỆ
// =============================================================
#title-slide[
  Phần I: Cơ Sở Lý Thuyết & Bản Chất Công Nghệ
]

#slide(title: "Đặt vấn đề & Mục tiêu", outlined: true)[
  - *Vấn đề thực tế:*
    - Nêu ngắn gọn bài toán kỹ thuật cần giải quyết trong tuần.
    - Hạn chế của cách làm truyền thống nếu không áp dụng kiến trúc / kỹ thuật này.
  
  #v(0.4em)
  - *Mục tiêu kỹ thuật:*
    - Nắm vững nguyên lý và cơ chế hoạt động ngầm (under-the-hood).
    - Phân tách rõ ràng trách nhiệm giữa các module.
    - Đảm bảo khả năng bảo trì, mở rộng và viết Unit Test độc lập.
]

#slide(title: "Nguyên lý & Cơ chế hoạt động", outlined: true)[
  #cols(columns: (1fr, 1.2fr), gutter: 1.5em)[
    *Khái niệm cốt lõi:*
    - Giải thích khái niệm 1.
    - Giải thích khái niệm 2.
    - Cơ chế vòng đời / luồng điều khiển.

    #v(0.3em)
    #stress[Điểm mấu chốt:]
    Nhấn mạnh bản chất kỹ thuật để phục vụ phần hỏi đáp phản biện (Q&A).
  ][
    #framed(title: "Sơ đồ nguyên lý")[
      #align(center + horizon)[
        _Chèn sơ đồ / hình minh họa kiến trúc tại đây_ \
        `#image("path/to/diagram.png", width: 90%)`
      ]
    ]
  ]
]

// =============================================================
// PHẦN II: KIẾN TRÚC GIẢI PHÁP & LUỒNG DỮ LIỆU
// =============================================================
#title-slide[
  Phần II: Kiến Trúc Giải Pháp & Luồng Dữ Liệu
]

#slide(title: "Sơ đồ kiến trúc & Phân tầng", outlined: true)[
  - *Tầng 1 (Cấp cao / UI):* Mô tả vai trò và các component chính.
  - *Tầng 2 (Trung gian / Nghiệp vụ):* Mô tả luồng xử lý và abstraction.
  - *Tầng 3 (Cấp thấp / Dữ liệu):* Mô tả tích hợp API, Database, Local Storage.

  #v(0.4em)
  #framed(title: "Quy tắc phụ thuộc (Dependency Rule)")[
    Tầng bên ngoài phụ thuộc vào tầng bên trong. Tầng bên trong độc lập tuyệt đối với framework và nguồn dữ liệu bên ngoài.
  ]
]

#slide(title: "Luồng dữ liệu (Data Flow)", outlined: true)[
  1. *Bước 1 (User Action):* Người dùng tương tác trên Widget / UI.
  2. *Bước 2 (State Management):* UI gửi Event đến State Manager (BLoC / Riverpod).
  3. *Bước 3 (Domain Execution):* Gọi UseCase xử lý nghiệp vụ độc lập.
  4. *Bước 4 (Data Retrieval):* Repository điều phối gọi DataSource (API / Local DB).
  5. *Bước 5 (State Emission):* Trả kết quả (Data/Failure), UI cập nhật lại giao diện.
]

// =============================================================
// PHẦN III: DEMO & ĐÁNH GIÁ MÃ NGUỒN THEN CHỐT
// =============================================================
#title-slide[
  Phần III: Demo Thực Tế & Mã Nguồn Then Chốt
]

#slide(title: "Cấu trúc thư mục & Mã nguồn then chốt", outlined: true)[
  #cols(columns: (1fr, 1.2fr), gutter: 1.2em)[
    *Cấu trúc dự án:*
    ```text
    lib/
    ├── core/
    ├── di/
    ├── features/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── main.dart
    ```
  ][
    *Đoạn mã then chốt (Dependency Injection / Logic):*
    ```dart
    // Đoạn mã khởi tạo hoặc UseCase chính
    final sl = GetIt.instance;
    void setupLocator() {
      sl.registerLazySingleton<Repository>(
        () => RepositoryImpl(dataSource: sl()),
      );
    }
    ```
  ]
]

#slide(title: "Kịch bản Unit Test & Kết quả", outlined: true)[
  - *Chiến lược kiểm thử:*
    - Sử dụng Mock Object để cô lập module cần kiểm thử.
    - Không phụ thuộc mạng thật (No real network calls), không dựng widget nặng.

  #v(0.3em)
  #framed(title: "Các ca kiểm thử chính (Test Cases)")[
    - *Case 1 (Success):* Mock trả về kết quả hợp lệ $-->$ Output khớp kỳ vọng.
    - *Case 2 (Failure):* Mock ném ngoại lệ $-->$ Xử lý lỗi an toàn, không crash app.
    - *Kết quả:* Chạy lệnh `flutter test` -- 100% test cases pass.
  ]
]

// =============================================================
// TÀI LIỆU THAM KHẢO
// =============================================================
#slide(title: "Tài liệu tham khảo", outlined: true)[
  + Flutter Official Documentation: #link("https://docs.flutter.dev")
  + Robert C. Martin, _Clean Architecture: A Craftsman's Guide to Software Structure and Design_.
  + Dart Language Tour & Asynchronous Programming Guide: #link("https://dart.dev/guides")
  + Mã nguồn dự án và hướng dẫn chạy: #link("https://github.com/your-username/your-repo")
]
