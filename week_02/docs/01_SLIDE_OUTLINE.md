# Đề Cương Chi Tiết Slide Báo Cáo Tuần 02 (Kèm Sơ Đồ Khối Trực Quan)
**Chủ đề 02**: Lập trình Bất đồng bộ với Future & Stream trong Flutter  
**Học phần**: Lập trình Đa nền tảng — Khoa Điện tử & AI, Trường Đại học Bách Khoa - ĐHĐN  
**GVHD**: TS. Nguyễn Duy Nhật Viễn  
**SVTH**: Huỳnh Thiện Lộc (MSSV: 106230052)  

---

## Slide 1: Trang Tiêu Đề (Front Slide)
- **Tiêu đề**: LẬP TRÌNH BẤT ĐỒNG BỘ VỚI FUTURE & STREAM TRONG FLUTTER
- **Phụ đề**: TRƯỜNG ĐẠI HỌC BÁCH KHOA — KHOA ĐIỆN TỬ VÀ TRÍ TUỆ NHÂN TẠO  
  *Chủ đề 02: Báo cáo Tuần 02 — Môn: Lập trình Đa nền tảng*
- **Tác giả**:  
  - Sinh viên thực hiện: Huỳnh Thiện Lộc — MSSV: 106230052  
  - Giảng viên hướng dẫn: TS. Nguyễn Duy Nhật Viễn  
- **Địa điểm & Thời gian**: Đà Nẵng, 2026

---

## Slide 2: Mục Lục Báo Cáo (Agenda)
1. **Phần I: Yêu Cầu Đề Bài & Bài Toán Thực Tế**
   - Yêu cầu kỹ thuật & Phạm vi đề tài (Spec)
2. **Phần II: Nền Tảng Bất Đồng Bộ & Vấn Đề Kỹ Thuật**
   - Cơ chế Event Loop & Hàng đợi trong Dart
   - So sánh bản chất Future vs Stream
3. **Phần III: Thiết Kế & Hiện Thực Luồng Dữ Liệu Stream**
   - Cấu trúc luồng với StreamController
   - Phản ứng giao diện: setState vs StreamBuilder
   - Xử lý vòng đời & Chống rò rỉ bộ nhớ (Memory Leak)
4. **Phần IV: Demo Thực Tế & Kiểm Thử Tự Động**
   - Sơ đồ tuần hoàn End-to-End từ Timer đến Màn hình
   - Giao diện ứng dụng thực tế với 3 trạng thái điều khiển
   - Kiểm thử luồng Stream tự động với `emitsInOrder`
   - Tài liệu tham khảo cụ thể

---

## Slide 3: Phân Công Công Việc (WBS)
- **Bảng phân công nhiệm vụ**:
  | TT | Họ và tên | Nội dung đảm nhận | Tỷ lệ |
  |:---:|:---|:---|:---:|
  | 1 | Huỳnh Thiện Lộc (106230052) | Nghiên cứu Event Loop, lập trình điều phối StreamController, xây dựng giao diện StreamBuilder, xử lý vòng đời chống rò rỉ bộ nhớ và viết Unit Test cho Stream. | 100% |

---

## Slide 4: Yêu Cầu Kỹ Thuật & Phạm Vi Đề Tài (Spec)
- **Bố cục 2 khối (Yêu cầu cốt lõi vs Yêu cầu Demo)**:
  - **Khối 1: Yêu Cầu Cốt Lõi (Core Specs)**:
    - *Bất đồng bộ:* Hiểu cơ chế chờ tác vụ với `Future` và `async/await`.
    - *Luồng thời gian thực:* Dùng `StreamController` phát dữ liệu và `StreamBuilder` cập nhật UI.
    - *Cơ chế dọn dẹp:* Bắt buộc hủy (`cancel/close`) chống rò rỉ RAM (Memory Leak).
  - **Khối 2: Yêu Cầu Demo & Tiêu Chí Đánh Giá**:
    - *Giao diện động:* Hiển thị chỉ số biến đổi liên tục theo thời gian thực.
    - *3 Nút tương tác:* Bắt đầu (Start), Tạm dừng (Pause), Đặt lại (Reset).
    - *An toàn vòng đời:* Đảm bảo giải phóng sạch `Timer` và `Stream` khi thoát màn hình.
- **Mục tiêu kỹ thuật**: Ứng dụng không lạm dụng `setState()`, bảo đảm app duy trì 60 FPS mượt mà và 0% Memory Leak.

---

## Slide 4: Cơ Chế Event Loop & Hàng Đợi Bất Đồng Bộ Trong Dart
- **Nguyên lý**: Dart chạy đơn luồng (Single Thread). Mọi tác vụ được điều phối qua vòng lặp Event Loop nhằm giữ giao diện mượt mà (60/120 FPS).
- **Sơ đồ cấu trúc Event Loop (Vẽ bằng Grid Box trên Slide)**:

```text
┌────────────────────────────────────────────────────────┐
│                   DART EVENT LOOP                      │
└────────────────────────────────────────────────────────┘
                           │
         ┌─────────────────┴─────────────────┐
         ▼                                   ▼
┌───────────────────────┐         ┌───────────────────────┐
│    Microtask Queue    │         │      Event Queue      │
│ (Ưu tiên số 1)        │         │ (Ưu tiên số 2)        │
│ • Schedule nội bộ     │         │ • I/O, Network        │
│ • Chạy hết trước      │         │ • Timer, User Gestures│
└───────────────────────┘         └───────────────────────┘
         │                                   │
         └─────────────────┬─────────────────┘
                           ▼
              ┌─────────────────────────┐
              │  Main Execution Thread  │
              │  (Thực thi không block) │
              └─────────────────────────┘
```

- **Đặc điểm kỹ thuật**:
  - `Future`: Đưa callback vào cuối **Event Queue**, trả về đúng 1 giá trị hoặc lỗi khi hoàn tất.
  - Cú pháp `async / await`: Bản chất là cú pháp rút gọn (syntax sugar) của `Future.then()`.

---

## Slide 5: So Sánh Trực Quan: Future vs Stream
- **Sơ đồ so sánh luồng thời gian (Timeline Diagram)**:

```text
[Future Timeline]
Request ─────(Chờ I/O / Network)─────► [ Trả 1 Giá Trị Duy Nhất ] ──► (Đóng luồng)

[Stream Timeline]
Start ───► [Giá Trị 1] ───► [Giá Trị 2] ───► [Giá Trị 3] ───► ... ──► [close() / Done]
             (Tick 1s)       (Tick 2s)       (Tick 3s)
```

- **Bảng tóm tắt kiến trúc**:
  | Tiêu chí | Future | Stream |
  |:---|:---|:---|
  | **Dữ liệu trả về** | 1 giá trị duy nhất (Single Value) | Chuỗi dữ liệu liên tục theo thời gian |
  | **Mô hình** | Request - Response (Kéo dữ liệu) | Publisher - Subscriber (Đẩy sự kiện) |
  | **Vòng đời** | Tự kết thúc sau khi hoàn thành | Mở liên tục cho đến khi gọi `close()` |
  | **Widget tương ứng** | `FutureBuilder` | `StreamBuilder` |

---

## Slide 6: Cấu Trúc Luồng Dữ Liệu StreamController
- **Sơ đồ khối luồng dữ liệu (Data Pipeline Box Diagram)**:

```text
┌────────────────┐          ┌─────────────────────────────────────────┐          ┌────────────────┐
│  Data Source   │  Data    │            StreamController             │  Stream  │   Listeners    │
│ (Timer/Sensor) │ ───────► │ ┌──────────────┐       ┌──────────────┐ │ ───────► │ (StreamBuilder/│
│                │          │ │  Input Sink  │ ────► │ Output Stream│ │          │  Subscription) │
└────────────────┘          │ └──────────────┘       └──────────────┘ │          └────────────────┘
                            └─────────────────────────────────────────┘
```

- **Mã nguồn thực tế (`ticker_stream_controller.dart`)**:
  ```dart
  final _controller = StreamController<int>.broadcast();
  Stream<int> get stream => _controller.stream;

  void emitTick(int tick) {
    if (!_controller.isClosed) {
      _controller.sink.add(tick); // Đẩy dữ liệu vào Sink
    }
  }
  ```
- **Phân loại**:
  - `Single-subscription`: Tối đa 1 listener (thích hợp với đọc file, download).
  - `Broadcast`: Cho phép nhiều listener đồng thời (thích hợp với sự kiện real-time, UI).

---

## Slide 7: Cơ Chế Phản Ứng Giao Diện: setState vs StreamBuilder
- **Sơ đồ so sánh phạm vi Rebuild Widget (Rebuild Scope)**:

```text
[Cách làm cũ: Stream.listen + setState]
Scaffold (Rebuild) ──► AppBar (Rebuild) ──► Body (Rebuild) ──► Text Counter (Rebuild)
=> Hạn chế: Lãng phí CPU, tốn pin, dễ drop FPS khi Stream bắn liên tục.

[Giải pháp chuẩn: StreamBuilder]
Scaffold (Giữ nguyên) ──► AppBar (Giữ nguyên) ──► Body (Giữ nguyên)
                                                     └──► StreamBuilder
                                                            └──► Text Counter (Chỉ Rebuild cục bộ)
```

- **Mã nguồn trích xuất từ dự án (`ticker_page.dart`)**:
  ```dart
  StreamBuilder<int>(
    stream: tickerController.stream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      return Text('${snapshot.data ?? 0}', style: AppStyles.counter);
    },
  )
  ```

---

## Slide 8: Xử Lý Vòng Đời & Ngăn Ngừa Rò Rỉ Bộ Nhớ (Memory Leak)
- **Vấn đề**: Khi người dùng thoát (pop) khỏi màn hình, nếu `Timer` và `StreamController` không được giải phóng:
  - Timer tiếp tục chạy ngầm trong Heap Memory $\rightarrow$ CPU bị chiếm dụng.
  - Listener vẫn bị giữ tham chiếu $\rightarrow$ Bộ thu gom rác (Garbage Collector) không thể dọn dẹp $\rightarrow$ **Rò rỉ RAM (Memory Leak)**.
- **Sơ đồ giải phóng tài nguyên (Lifecycle Cleanup Flow)**:

```text
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│ Widget unmount  │ ────► │ _timer?.cancel()│ ────► │ _controller     │ ────► [Bộ nhớ RAM]
│ (dispose())     │       │ (Dừng đếm)      │       │   .close()      │       [Được giải phóng]
└─────────────────┘       └─────────────────┘       └─────────────────┘
```

- **Mã nguồn giải phóng chuẩn (`ticker_stream_controller.dart`)**:
  ```dart
  void dispose() {
    _timer?.cancel();      // 1. Dừng Timer ngầm
    _controller.close();   // 2. Đóng hoàn toàn StreamController
  }
  ```

---

## Slide 9: Sơ Đồ Tuần Hoàn Dữ Liệu End-to-End
- **Sơ đồ chi tiết 2 chiều khép kín (Full Round-trip Pipeline)**:

```text
1. CHIỀU ĐIỀU KHIỂN (ACTION PHASE)
[User Tap 'Bắt đầu'] ──► [TickerController.start()] ──► [Timer.periodic(1s)]
                                                               │
                                                               ▼
2. CHIỀU PHÁT DỮ LIỆU (STREAM PIPELINE)
[Giá trị tick mới] ──► [controller.sink.add(tick)] ──► [Broadcast Stream]
                                                               │
                                                               ▼
3. CHIỀU PHẢN ỨNG GIAO DIỆN (RENDER PHASE)
[StreamBuilder bắt Snapshot] ──► [ConnectionState.active] ──► [Vẽ lại Text Widget trên UI]
```

---

## Slide 10: Xây Dựng Ứng Dụng Thực Tế: Bộ Đếm & Cảm Biến Real-Time
- **Bố cục 2 cột (So sánh logic & Giao diện)**:
  - **Cột trái (Logic điều khiển 3 trạng thái)**:
    - **Bắt đầu (Start)**: Kích hoạt `Timer.periodic(Duration(seconds: 1))` phát nhịp đếm liên tục.
    - **Tạm dừng (Pause)**: Dừng `_timer?.cancel()` nhưng giữ nguyên giá trị bộ đếm hiện tại.
    - **Đặt lại (Reset)**: Đưa giá trị về 0, dừng Timer và phát giá trị 0 cập nhật lên màn hình.
  - **Cột phải (Khung ảnh demo thực tế)**:
    - *(Chèn ảnh chụp màn hình ứng dụng chạy trên Desktop/Linux/Mobile)*.

---

## Slide 11: Kiểm Thử Tự Động Luồng Dữ Liệu Stream (Unit Test)
- **Vấn đề**: Làm sao kiểm chứng luồng dữ liệu phát sinh đúng trình tự thời gian mà không cần chạy máy ảo?
- **Giải pháp**: Dùng matcher `emitsInOrder` của package `test` để kiểm tra chuỗi giá trị bất đồng bộ.
- **Sơ đồ kiểm thử (Test Timeline Verification)**:

```text
Controller Start ─────► Phát 1 ─────► Phát 2 ─────► Phát 3
                          │             │             │
Matcher emitsInOrder([    1,            2,            3     ])  ===> PASS (100%)
```

- **Mã nguồn kiểm thử thực tế (`ticker_stream_test.dart`)**:
  ```dart
  test('Stream phát đúng chuỗi giá trị theo thời gian', () async {
    final controller = TickerStreamController();
    expectLater(controller.stream, emitsInOrder([1, 2, 3]));

    controller.start();
    await Future.delayed(const Duration(seconds: 3));
    controller.dispose();
  });
  ```

---

## Slide 12: Tài Liệu Tham Khảo Cụ Thể
1. **Google Flutter Documentation**, *Asynchronous Programming: Futures & Streams*:
   - Cơ chế Event Loop, Microtask Queue và kiến trúc reactive của `StreamBuilder`.
   - Link: https://docs.flutter.dev/libraries/architecture/async-programming
2. **Dart Language Specification**, *Stream & StreamController Library Guide*:
   - Quy chuẩn quản lý vòng đời Stream, phân biệt Single-subscription và Broadcast Stream.
   - Link: https://api.dart.dev/stable/dart-async/StreamController-class.html
3. **Effective Dart: Usage**, *Lifecycle Management & Cleaning Up Async Resources*:
   - Các nguyên tắc bắt buộc về việc hủy `Timer`, `cancel()` Subscription và `close()` Controller trong `dispose()`.
   - Link: https://dart.dev/effective-dart/usage
