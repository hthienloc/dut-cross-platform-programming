# Tuần 02 — Chủ Đề 02: Lập Trình Bất Đồng Bộ Với Future & Stream Trong Flutter

- **Môn học**: Lập trình Đa nền tảng
- **Giảng viên hướng dẫn**: TS. Nguyễn Duy Nhật Viễn
- **Sinh viên thực hiện**: Huỳnh Thiện Lộc (MSSV: 106230052) — Tỷ lệ đóng góp: 100%

---

## 1. Đề Bài Nguyên Mẫu Từ Giảng Viên (Spec)

> **Chủ đề 02: Lập trình Bất đồng bộ với Future & Stream trong Flutter**
> 
> - **Nội dung:**
>   - Cơ chế bất đồng bộ: Xử lý tác vụ chờ với `Future` và cú pháp `async/await`.
>   - Luồng dữ liệu liên tục (Stream): Sử dụng `StreamController` để phát dữ liệu, lắng nghe sự kiện và cập nhật giao diện bằng `StreamBuilder`.
>   - Cơ chế dọn dẹp: Hủy lắng nghe (`cancel`/`dispose`) để tránh rò rỉ bộ nhớ (memory leak).
> - **Yêu cầu demo:**
>   - Xây dựng ứng dụng hiển thị dữ liệu biến đổi liên tục (ví dụ: đồng hồ đếm ngược/bấm giờ hoặc giả lập chỉ số ngẫu nhiên nhảy theo thời gian thực) sử dụng `StreamBuilder`.
>   - Có nút Bắt đầu / Tạm dừng / Đặt lại và đảm bảo giải phóng (`close`/`cancel`) Stream an toàn khi người dùng thoát khỏi màn hình.

---

## 2. Cấu Trúc Thư Mục Tuần 02

```text
week_02/
├── app/                        # Ứng dụng Flutter Demo & Kiểm thử Unit Test
│   ├── lib/
│   │   ├── stream_service.dart # Dịch vụ quản lý luồng đếm, StreamController & lifecycle
│   │   └── main.dart           # Giao diện StreamBuilder, 3 nút Start/Pause/Reset
│   └── test/
│       ├── stream_service_test.dart       # Unit test tự động với matcher emitsInOrder (5/5 passed)
│       └── screenshot_goldens_test.dart   # Kiểm thử tự động giao diện
├── docs/                       # Tài liệu thiết kế & đề cương bài giảng
│   └── 01_SLIDE_OUTLINE.md     # Đề cương slide 4 phần logic
└── slide/                      # Slide báo cáo Typst (typslides + fletcher vector diagram)
    ├── main.typ                # Mã nguồn slide Typst
    ├── main.pdf                # Bản PDF hoàn chỉnh (18 trang chuẩn 16:9)
    └── demo_ui.png             # Ảnh chụp cửa sổ giao diện ứng dụng thực tế
```

---

## 3. Kiến Trúc Kỹ Thuật

```
[ User Interaction ] ---> [ StreamCounterService ] ---> [ StreamController.broadcast ]
(Start/Pause/Reset)       - Timer.periodic(1s)          - Sink.add(tick)
                          - pause() / reset()           - Stream.listen()
                          - dispose() -> clean-up                 |
                                                                  v
                                                        [ StreamBuilder<int> ]
                                                        - Rebuild cục bộ duy nhất Text widget
                                                        - Đạt chuẩn 60 FPS, 0% Memory Leak
```

- **Dart Event Loop:** Điều phối các tác vụ bất đồng bộ, ưu tiên Microtask Queue trước Event Queue.
- **Non-blocking `await`:** Tạm dừng hàm bất đồng bộ nhưng không block thread chính, nhường thread cho UI loop.
- **Tối ưu hóa UI:** `StreamBuilder` chỉ rebuild widget con trực thuộc bên trong `builder`, loại bỏ drop FPS do lạm dụng `setState()`.
- **An toàn vòng đời (Lifecycle Clean-up):** Luôn hủy `Timer.cancel()` và đóng `StreamController.close()` trong hàm `dispose()`.

---

## 4. Hướng Dẫn Chạy & Kiểm Thử

### 4.1. Xem & Biên dịch Slide
```bash
# Xem slide PDF đã biên dịch:
xdg-open slide/main.pdf

# Hoặc biên dịch lại:
typst compile slide/main.typ slide/main.pdf
```

### 4.2. Chạy kiểm thử tự động (Unit Test)
```bash
cd app
flutter test test/stream_service_test.dart
```

### 4.3. Chạy ứng dụng Demo
```bash
cd app
flutter pub get
flutter run
```
