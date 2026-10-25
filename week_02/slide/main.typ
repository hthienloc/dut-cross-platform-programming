#import "@preview/typslides:1.3.4": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: diamond, pill, cylinder

// =============================================================
// CẤU HÌNH GIAO DIỆN (CHỮ RÕ NÉT TRÊN MÁY CHIẾU, SỐ NGUYÊN)
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
  title: "Bất Đồng Bộ Với Future & Stream Trong Flutter",
  subtitle: [
    TRƯỜNG ĐẠI HỌC BÁCH KHOA — KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO \
    #text(size: 16pt)[*Chủ đề 02: Báo cáo Tuần 02 — Môn: Lập trình Đa nền tảng*]
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
  text-size: 10pt,
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
      [1], [Huỳnh Thiện Lộc \ (106230052)], [Nghiên cứu Event Loop, lập trình StreamController, xây dựng StreamBuilder, xử lý vòng đời dispose và viết Unit Test.], [100%],
    )
  ]
]

// =============================================================
// PHẦN I: TỔNG QUAN YÊU CẦU & BÀI TOÁN KỸ THUẬT
// =============================================================
#title-slide[
  Phần I: Tổng Quan Yêu Cầu & Bài Toán Kỹ Thuật
]

#slide(title: "Yêu cầu kỹ thuật & Phạm vi đề tài (Spec)", outlined: true)[
  #v(-0.3em)
  #grid(
    columns: (1fr, 1.25fr),
    gutter: 0.5cm,
    [
      #rect(width: 100%, stroke: 2pt + rgb("#2b6cb0"), inset: 8pt, radius: 4pt, fill: rgb("#ebf8ff"))[
        #align(left)[
          #align(center)[*Yêu Cầu Cốt Lõi (Core Specs)*]
          #v(0.1em)
          #text(size: 14pt)[
            - *Bất đồng bộ:* Hiểu cơ chế chờ tác vụ với `Future` và `async/await`.
            - *Luồng thời gian thực:* Dùng `StreamController` phát dữ liệu và `StreamBuilder` cập nhật UI.
            - *Cơ chế dọn dẹp:* Bắt buộc hủy (`cancel/close`) chống rò rỉ RAM (Memory Leak).
          ]
        ]
      ]
    ],
    [
      #rect(width: 100%, stroke: 2pt + rgb("#2f855a"), inset: 8pt, radius: 4pt, fill: rgb("#f0fff4"))[
        #align(left)[
          #align(center)[*Yêu Cầu Demo & Tiêu Chí Đánh Giá*]
          #v(0.1em)
          #text(size: 14pt)[
            - *Giao diện động:* Hiển thị chỉ số biến đổi liên tục theo thời gian thực.
            - *3 Nút tương tác:* Bắt đầu (Start), Tạm dừng (Pause), Đặt lại (Reset).
            - *An toàn vòng đời:* Đảm bảo giải phóng sạch `Timer` và `Stream` khi thoát màn hình.
          ]
        ]
      ]
    ]
  )
  #v(0.2em)
  - *Mục tiêu giải pháp:* Không lạm dụng `setState()`, bảo đảm app đạt 60 FPS mượt mà và 0% Memory Leak.
]

// =============================================================
// PHẦN II: NỀN TẢNG BẤT ĐỒNG BỘ: DART EVENT LOOP & FUTURE
// =============================================================
#title-slide[
  Phần II: Nền Tảng Bất Đồng Bộ: Dart Event Loop & Future
]

#slide(title: "Cơ chế Event Loop & Hàng đợi trong Dart", outlined: true)[
  - *Bản chất:* Dart chạy đơn luồng (Single Thread). Event Loop liên tục quét hai hàng đợi:
  #v(0.1em)
  #align(center)[
    #text(size: 12pt)[
      #diagram(
        spacing: (45mm, 15mm),
        node-stroke: 1.2pt,
        node-corner-radius: 6pt,
        node-inset: 8pt,
        edge-stroke: 1.2pt + rgb("#4a5568"),

        node((0, 0), align(center)[
          #text(12pt, weight: "bold")[Microtask Queue (Ưu tiên 1)] \
          #text(10pt, fill: rgb("#2b6cb0"))[`scheduleMicrotask`, nội bộ]
        ], fill: rgb("#ebf8ff"), stroke: 1.2pt + rgb("#2b6cb0"), width: 52mm),

        node((0, 1.2), align(center)[
          #text(12pt, weight: "bold")[Event Queue (Ưu tiên 2)] \
          #text(10pt, fill: rgb("#2f855a"))[Timer, I/O, Network, Touch]
        ], fill: rgb("#f0fff4"), stroke: 1.2pt + rgb("#2f855a"), width: 52mm),

        node((1.1, 0.6), align(center)[
          #text(12pt, weight: "bold")[Dart Execution Thread] \
          #text(10pt, fill: rgb("#744210"))[Thực thi mã lệnh đồng bộ]
        ], fill: rgb("#fefcbf"), stroke: 1.5pt + rgb("#d69e2e"), width: 48mm),

        edge((0, 0), (1.1, 0.6), "-|>", [1. Chạy cạn trước], label-side: auto, label-size: 10pt, stroke: 1.2pt + rgb("#2b6cb0")),
        edge((0, 1.2), (1.1, 0.6), "-|>", [2. Lấy tuần tự], label-side: auto, label-size: 10pt, stroke: 1.2pt + rgb("#2f855a")),
      )
    ]
  ]
  #v(0.1em)
  - *Future:* Đưa tác vụ chờ vào Event Queue, chỉ sinh *1 giá trị kết quả duy nhất*.
]

#slide(title: "So sánh bản chất: Future vs Stream", outlined: true)[
  #v(-0.3em)
  #align(center)[
    #table(
      columns: (1.2fr, 1.8fr, 2fr),
      inset: (x: 8pt, y: 7pt),
      align: (center + horizon, left + horizon, left + horizon),
      fill: (x, y) => if y == 0 { rgb("#edf2f7") } else if calc.even(y) { rgb("#f8fafc") } else { none },
      stroke: 1pt + rgb("#cbd5e0"),
      [*Tiêu chí*], [*Future (Single Value)*], [*Stream (Continuous Values)*],
      [*Số lượng dữ liệu*], [1 giá trị duy nhất (hoặc 1 lỗi)], [Chuỗi nhiều giá trị phát theo thời gian],
      [*Mô hình trao đổi*], [Request - Response (Kéo dữ liệu)], [Publisher - Subscriber (Đẩy sự kiện)],
      [*Vòng đời luồng*], [Tự đóng ngay khi hoàn thành], [Mở liên tục, bắt buộc gọi `close()`],
      [*Widget UI tương ứng*], [`FutureBuilder`], [`StreamBuilder`],
      [*Ứng dụng thực tế*], [Gọi REST API, đọc file, nạp database], [Đồng hồ bấm giờ, cảm biến, WebSocket],
    )
  ]
  #v(0.1em)
  - *Điểm mấu chốt:* `Stream` mở liên tục cho đến khi gọi `close()`, nếu quên hủy sẽ gây rò rỉ RAM.
]

#slide(title: "Cơ chế xử lý tác vụ chờ với Future & async/await", outlined: true)[
  - *Bản chất của `await`:* Không khóa luồng UI (Non-blocking). Nó tạm dừng hàm hiện tại, nhường Dart Execution Thread cho các sự kiện khác trong Event Loop:
  #v(-0.2em)
  ```dart
  Future<String> fetchUserConfig() async {
    // 1. Gặp await: hàm tạm ngưng, giải phóng Thread cho khung hình 60 FPS
    final response = await http.get(Uri.parse('https://api.example.com/config'));
    // 2. Khi I/O hoàn tất, callback được đẩy vào Event Queue để chạy tiếp
    return response.body;
  }
  ```
  #v(-0.2em)
  #text(size: 14pt)[
    - *`async`:* Tự động đóng gói kiểu dữ liệu trả về thành một `Future<T>`.
    - *`await`:* Mở gói giá trị từ `Future` một cách tuần tự, loại bỏ hoàn toàn hiện tượng Callback Hell (`.then()`).
    - *Bắt lỗi (Error Handling):* Dùng `try-catch` đồng bộ quen thuộc để bắt lỗi mạng/timeout.
  ]
]

#slide(title: "Phân loại luồng: Single-subscription vs Broadcast Stream", outlined: true)[
  #v(-0.3em)
  #align(center)[
    #table(
      columns: (1.5fr, 2fr, 2fr),
      inset: (x: 8pt, y: 7pt),
      align: (center + horizon, left + horizon, left + horizon),
      fill: (x, y) => if y == 0 { rgb("#edf2f7") } else if calc.even(y) { rgb("#f8fafc") } else { none },
      stroke: 1pt + rgb("#cbd5e0"),
      [*Đặc điểm*], [*Single-subscription Stream*], [*Broadcast Stream*],
      [*Số Listener*], [Chỉ đúng *1 listener duy nhất*], [Nhiều listener nghe đồng thời],
      [*Đăng ký lại*], [Báo lỗi nếu listen lần 2], [Tự do `listen()` và hủy bất kỳ lúc nào],
      [*Buffer sự kiện*], [Giữ sự kiện trước khi có listener], [Không đệm (bỏ lỡ nếu chưa listen)],
      [*Khởi tạo Dart*], [`StreamController<T>()`], [`StreamController<T>.broadcast()`],
      [*Trường hợp dùng*], [Đọc file I/O, nạp tệp zip, HTTP body], [Đồng hồ real-time, cảm biến, WebSocket],
    )
  ]
  #v(0.1em)
  - *Ứng dụng trong bài:* Dùng `.broadcast()` để nhiều thành phần UI cùng nhận dữ liệu nhịp đếm mà không xung đột.
]

// =============================================================
// PHẦN III: KIẾN TRÚC STREAM & QUẢN LÝ VÒNG ĐỜI BỘ NHỚ
// =============================================================
#title-slide[
  Phần III: Kiến Trúc Stream & Quản Lý Vòng Đời Bộ Nhớ
]

#slide(title: "Cấu trúc luồng với StreamController", outlined: true)[
  #v(-0.3em)
  #align(center)[
    #text(size: 12pt)[
      #diagram(
        spacing: (32mm, 10mm),
        node-stroke: 1.2pt,
        node-corner-radius: 6pt,
        node-inset: 8pt,
        edge-stroke: 1.2pt + rgb("#2b6cb0"),

        node((0, 0), align(center)[
          #text(12pt, weight: "bold")[Data Source] \
          #text(10pt, fill: rgb("#c53030"))[`Timer.periodic`]
        ], fill: rgb("#fff5f5"), stroke: 1.2pt + rgb("#e53e3e"), width: 34mm),

        node((1, 0), align(center)[
          #text(12pt, weight: "bold")[Sink (Input)] \
          #text(10pt, fill: rgb("#2f855a"))[`sink.add(val)`]
        ], fill: rgb("#f0fff4"), stroke: 1.2pt + rgb("#38a169"), width: 32mm),

        node((2, 0), align(center)[
          #text(12pt, weight: "bold")[StreamController] \
          #text(10pt, fill: rgb("#2b6cb0"))[Buffer & Dispatch]
        ], fill: rgb("#ebf8ff"), stroke: 1.5pt + rgb("#3182ce"), width: 44mm),

        node((3, 0), align(center)[
          #text(12pt, weight: "bold")[Stream (Output)] \
          #text(10pt, fill: rgb("#6b46c1"))[`StreamBuilder` UI]
        ], fill: rgb("#faf5ff"), stroke: 1.2pt + rgb("#805ad5"), width: 38mm),

        edge((0, 0), (1, 0), "-|>", [bắn tick], label-side: left, label-size: 10pt),
        edge((1, 0), (2, 0), "-|>", [nạp], label-side: left, label-size: 10pt),
        edge((2, 0), (3, 0), "-|>", [lắng nghe], label-side: left, label-size: 10pt),
      )
    ]
  ]
  #v(-0.2em)
  ```dart
  final _controller = StreamController<int>.broadcast();
  Stream<int> get stream => _controller.stream; // Công khai Stream ra ngoài
  void emitTick(int tick) {
    if (!_controller.isClosed) _controller.sink.add(tick); // Nạp vào Sink
  }
  ```
  #v(-0.2em)
  #text(size: 14pt)[
    - `.broadcast()`: Cho phép nhiều UI widget cùng lắng nghe đồng thời 1 nguồn Stream.
    - `sink.add()`: Cổng nạp dữ liệu vào luồng; luôn kiểm tra `!isClosed` để tránh `Bad state`.
  ]
]

#slide(title: "Phản ứng giao diện: setState vs StreamBuilder", outlined: true)[
  - *Vấn đề của setState:* Mỗi nhịp Stream bắn về, `setState()` ép rebuild toàn bộ cây Widget gây drop FPS.
  - *Giải pháp StreamBuilder:* Lắng nghe Stream và rebuild *duy nhất widget con bên trong*:
  #v(0.1em)
  ```dart
  StreamBuilder<int>(
    stream: _service.stream,
    initialData: _service.currentCount,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      final value = snapshot.data ?? 0;
      return Text('$value', style: const TextStyle(fontSize: 48));
    },
  )
  ```
  #v(0.1em)
  - `snapshot.connectionState`: Quản lý 3 trạng thái chuẩn (`waiting`, `active`, `done`).
]

#slide(title: "Xử lý vòng đời & Chống Memory Leak", outlined: true)[
  - *Nguy cơ:* Khi rời màn hình, `Timer` và `Stream` không hủy sẽ tiếp tục chạy ngầm, ngốn CPU và rò rỉ RAM.
  - *Quy tắc dọn dẹp bắt buộc (Clean-up Pattern):* Override phương thức `dispose()`:
  #v(0.1em)
  ```dart
  @override
  void dispose() {
    _timer?.cancel();       // 1. Dừng ngay Timer phát sự kiện
    _controller.close();    // 2. Đóng hoàn toàn StreamController
    super.dispose();
  }
  ```
  #v(0.2em)
  - *Kiểm soát an toàn:* Luôn kiểm tra `!_controller.isClosed` trước khi gọi `sink.add()` để tránh crash lỗi `Bad state: Cannot add event after closing`.
]

#slide(title: "Cơ chế Garbage Collection & Khởi tạo an toàn", outlined: true)[
  - *Cơ chế GC Reachability:* Dart thu hồi bộ nhớ dựa trên đường dẫn tham chiếu (Root Reference):
  #v(-0.2em)
  #align(center)[
    #text(size: 11pt)[
      #diagram(
        spacing: (30mm, 10mm),
        node-stroke: 1.2pt,
        node-corner-radius: 6pt,
        node-inset: 7pt,

        node((0, 0), align(center)[
          #text(11pt, weight: "bold")[Root / Engine] \
          #text(9pt, fill: rgb("#2b6cb0"))[Event Loop Timer]
        ], fill: rgb("#ebf8ff"), stroke: 1.2pt + rgb("#2b6cb0"), width: 34mm),

        node((1, 0), align(center)[
          #text(11pt, weight: "bold")[Timer.periodic] \
          #text(9pt, fill: rgb("#c53030"))[Chạy ngầm liên tục]
        ], fill: rgb("#fff5f5"), stroke: 1.2pt + rgb("#e53e3e"), width: 34mm),

        node((2, 0), align(center)[
          #text(11pt, weight: "bold")[Widget State] \
          #text(9pt, fill: rgb("#744210"))[Bị giữ tham chiếu]
        ], fill: rgb("#fefcbf"), stroke: 1.5pt + rgb("#d69e2e"), width: 36mm),

        edge((0, 0), (1, 0), "-|>", [kích hoạt], label-side: left, label-size: 9pt),
        edge((1, 0), (2, 0), "-|>", [giữ callback `this`], label-side: left, label-size: 9pt, stroke: 1.5pt + rgb("#e53e3e")),
      )
    ]
  ]
  #v(-0.2em)
  #text(size: 14pt)[
    - *Hậu quả khi quên `cancel()`:* Widget đã thoát màn hình nhưng vẫn "sống" trong heap $-->$ Memory Leak.
    - *Giải pháp triệt để:* Khi `dispose()`, cắt đứt tham chiếu callback và đóng Controller lập tức.
  ]
]

// =============================================================
// PHẦN IV: HIỆN THỰC ỨNG DỤNG THỰC TẾ & KIỂM THỬ TỰ ĐỘNG
// =============================================================
#title-slide[
  Phần IV: Hiện Thực Ứng Dụng Thực Tế & Kiểm Thử Tự Động
]

#slide(title: "Sơ đồ luồng End-to-End từ Timer đến UI", outlined: true)[
  #v(-0.3em)
  #align(center)[
    #text(size: 12pt)[
      #diagram(
        spacing: (38mm, 18mm),
        node-stroke: 1.2pt,
        node-corner-radius: 6pt,
        node-inset: 9pt,

        // Hàng 1: Action & Emit Phase
        node((0, 0), align(center)[
          #text(12pt, weight: "bold")[User Tap 'Start'] \
          #text(10pt, fill: rgb("#2b6cb0"))[`controller.start()`]
        ], fill: rgb("#ebf8ff"), stroke: 1.2pt + rgb("#2b6cb0"), width: 44mm),

        node((1, 0), align(center)[
          #text(12pt, weight: "bold")[Timer.periodic] \
          #text(10pt, fill: rgb("#c53030"))[Đếm nhịp mỗi 1s]
        ], fill: rgb("#fff5f5"), stroke: 1.2pt + rgb("#e53e3e"), width: 42mm),

        node((2, 0), align(center)[
          #text(12pt, weight: "bold")[StreamController] \
          #text(10pt, fill: rgb("#2f855a"))[`sink.add(tickCount)`]
        ], fill: rgb("#f0fff4"), stroke: 1.5pt + rgb("#38a169"), width: 46mm),

        edge((0, 0), (1, 0), "-|>", [kích hoạt], label-side: left, label-size: 10pt, stroke: 1.2pt + rgb("#2b6cb0")),
        edge((1, 0), (2, 0), "-|>", [bắn tick], label-side: left, label-size: 10pt, stroke: 1.2pt + rgb("#e53e3e")),

        // Chuyển pha
        edge((2, 0), (2, 1), "-|>", [Broadcast], label-side: right, label-size: 10pt, stroke: 1.5pt + rgb("#38a169")),

        // Hàng 2: Listen & Render Phase
        node((2, 1), align(center)[
          #text(12pt, weight: "bold")[Stream.listen()] \
          #text(10pt, fill: rgb("#2f855a"))[Phát dữ liệu mở]
        ], fill: rgb("#f0fff4"), stroke: 1.2pt + rgb("#38a169"), width: 46mm),

        node((1, 1), align(center)[
          #text(12pt, weight: "bold")[StreamBuilder] \
          #text(10pt, fill: rgb("#2b6cb0"))[Nhận `AsyncSnapshot`]
        ], fill: rgb("#ebf8ff"), stroke: 1.2pt + rgb("#2b6cb0"), width: 42mm),

        node((0, 1), align(center)[
          #text(12pt, weight: "bold")[Text Widget (UI)] \
          #text(10pt, fill: rgb("#6b46c1"))[Rebuild cục bộ 60 FPS]
        ], fill: rgb("#faf5ff"), stroke: 1.5pt + rgb("#805ad5"), width: 44mm),

        edge((2, 1), (1, 1), "-|>", [snapshot], label-side: left, label-size: 10pt, stroke: 1.2pt + rgb("#2b6cb0")),
        edge((1, 1), (0, 1), "-|>", [render mới], label-side: left, label-size: 10pt, stroke: 1.2pt + rgb("#805ad5")),
      )
    ]
  ]
  #v(0.1em)
  - *Nguyên tắc cô lập UI:* Chỉ widget nằm trong builder của `StreamBuilder` mới bị vẽ lại khi có dữ liệu mới.
]

#slide(title: "Giao diện thực tế & 3 trạng thái điều khiển", outlined: true)[
  #v(-0.3em)
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 0.7cm,
    align: (left + horizon, center + horizon),
    [
      #rect(width: 100%, stroke: 1pt + rgb("#cbd5e0"), inset: 8pt, radius: 4pt, fill: rgb("#f7fafc"))[
        #text(size: 15pt, weight: "bold")[
          Xử lý 3 trạng thái tương tác:
        ]
      ]
      #v(0.2em)
      - *Bắt đầu (Start):* Kích hoạt Timer 1s, phát luồng nhịp đếm liên tục ra Stream.
      - *Tạm dừng (Pause):* Hủy Timer `cancel()`, đóng băng giá trị hiển thị hiện thời.
      - *Đặt lại (Reset):* Reset giá trị về 0 và phát sự kiện cập nhật giao diện ngay lập tức.
      - *Thoát màn hình:* `dispose()` tự động giải phóng sạch `Timer` và `StreamController`.
    ],
    [
      #image("demo_ui.png", height: 75%)
    ]
  )
]

#slide(title: "Kiểm thử tự động tầng Stream (Unit Test)", outlined: true)[
  - *Mục tiêu:* Kiểm tra luồng phát dữ liệu chuẩn xác theo thời gian bằng matcher `emitsInOrder`:
  #v(0.1em)
  ```dart
  test('Start phát đúng chuỗi giá trị tăng dần theo thời gian', () async {
    service.start();

    // Dùng emitsInOrder kiểm tra chuỗi 3 giá trị liên tiếp từ Stream
    await expectLater(
      service.stream.take(3),
      emitsInOrder([1, 2, 3]),
    );
  });
  ```
  #v(0.2em)
  - *Kết quả:* Chạy `flutter test` kiểm thử độc lập logic mà không phụ thuộc vào giao diện hay máy ảo.
]

// =============================================================
// TÀI LIỆU THAM KHẢO CỤ THỂ
// =============================================================
#slide(title: "Tài liệu tham khảo cụ thể", outlined: true)[
  #set text(size: 15pt)
  + *Google Flutter Documentation*, _Asynchronous Programming: Futures & Streams_:
    - Cơ chế Event Loop, Microtask Queue và cơ chế reactive của `StreamBuilder`.
    - #link("https://docs.flutter.dev/libraries/architecture/async-programming")
  + *Dart Language Specification*, _Stream & StreamController Library Guide_:
    - Phân biệt Single-subscription vs Broadcast Stream, quản lý `Sink` và `Stream`.
    - #link("https://api.dart.dev/stable/dart-async/StreamController-class.html")
  + *Effective Dart: Usage*, _Lifecycle Management & Cleaning Up Async Resources_:
    - Nguyên tắc bắt buộc giải phóng `Timer`, `cancel()` subscription và `close()` controller trong `dispose()`.
    - #link("https://dart.dev/effective-dart/usage")
]
