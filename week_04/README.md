# Tuần 04 — Chủ Đề 08: Animation và Cử Chỉ Nâng Cao Trong Flutter

- **Môn học**: Lập trình Đa nền tảng (Cross-Platform Programming)
- **Cơ sở đào tạo**: Khoa Điện tử và Trí tuệ Nhân tạo — Trường Đại học Bách Khoa, Đại học Đà Nẵng
- **Giảng viên hướng dẫn**: TS. Nguyễn Duy Nhật Viễn
- **Sinh viên thực hiện**: Huỳnh Thiện Lộc (MSSV: 106230052)
- **Mã nguồn**: [`week_04/app/`](app/)
- **Báo cáo Slide (Typst 16:9)**: [`week_04/slide/`](slide/)

---

## 1. Cấu Trúc Dự Án Tuần 04

```text
week_04/
├── docs/
│   ├── 01_THEORY_AND_UX_ANALYSIS.md   # Phân tích lý thuyết chuyên sâu, Gesture Arena & Memory Leak
│   └── 02_SPEAKER_NOTES_AND_SCRIPT.md # Kịch bản nói chi tiết cho từng slide (Minimal text slide)
│
├── slide/
│   ├── diagrams/                      # Sơ đồ kiến trúc vector SVG
│   ├── main.typ                       # Slide Typst định dạng 16:9 (Visual-first, minimal text)
│   └── main.pdf                       # Bản xuất PDF hoàn chỉnh
│
├── app/
│   ├── lib/
│   │   ├── main.dart                  # Hub điều hướng ứng dụng demo
│   │   ├── animations/                # Implicit & Explicit controllers
│   │   └── gestures/                  # Đấu trường cử chỉ & Spring physics
│   └── test/
│       └── widget_test.dart           # Kiểm thử tự động vòng đời animation & memory leak
│
└── README.md                          # Tổng quan báo cáo & hướng dẫn chạy demo
```

---

## 2. Trọng Tâm Kiến Thức Đạt Được

### 2.1. Cơ Sở Lý Thuyết Cốt Lõi
1. **Implicit Animation**:
   - Khai báo Declarative: Sử dụng `AnimatedContainer`, `AnimatedOpacity`, `TweenAnimationBuilder`.
   - Cơ chế tự động nội suy trạng thái từ $A \to B$ khi biến đổi giá trị mục tiêu (Target Value).
   - Bảo đảm an toàn 100% không rò rỉ bộ nhớ (Zero Memory Leak) do framework tự quản lý `Ticker`.
2. **Explicit Animation & Quản Lý Tài Nguyên**:
   - `AnimationController`: Kiểm soát chủ động (`forward`, `reverse`, `stop`, `repeat`, `animateWith`).
   - `SingleTickerProviderStateMixin`: Khóa nhịp `Ticker` với xung nhịp Vsync của hệ điều hành, tự động dừng khi màn hình bị che khuất để tiết kiệm GPU/Pin.
   - **Kỷ luật giải phóng bộ nhớ**: Bắt buộc gọi `controller.dispose()` trước `super.dispose()` để tránh rò rỉ tham chiếu mạnh (Strong Reference Leak).
   - Tối ưu hiệu năng: Sử dụng Transition Widgets (`SlideTransition`, `ScaleTransition`) để cập nhật Transform Layer trên GPU mà không rebuild widget tree.
3. **Đấu Trường Cử Chỉ (Gesture Arena & Disambiguation)**:
   - Cơ chế giải quyết tranh chấp cử chỉ khi nhiều Recognizer cùng bắt sự kiện `PointerDown`.
   - Các quy tắc phân định thắng cuộc: `Self-elimination`, `Declare Win` qua ngưỡng `Touch Slop` ($18\text{dp}$), và `Last-man-standing`.
   - Nguyên tắc ưu tiên phân cấp: Widget con được nạp vào Arena trước widget cha (First-Come, First-Served).
4. **Nguyên Tắc UX Trong Chuyển Động (Motion UX Principles)**:
   - **Non-blocking**: Chuyển động không bao giờ được khóa tương tác người dùng.
   - **Interruptible**: Cử chỉ có thể đổi hướng hoặc buông tay giữa chừng và lập tức phản hồi tự nhiên qua mô phỏng vật lý lò xo (`SpringSimulation`).
   - **Tâm lý học thời lượng**: Phản hồi xúc giác ($100\text{ms} - 150\text{ms}$), Dẫn hướng chú ý ($250\text{ms} - 350\text{ms}$), Tránh kéo dài quá $500\text{ms}$.

---

## 3. Cách Thức Thuyết Trình & Tiếp Cận Mới (Visual-First Presentation)

- **Slide Trình Chiếu (`slide/main.pdf`)**:
  - Thiết kế theo tiêu chuẩn công nghệ cao: **Cực kỳ ít chữ, tối đa hóa sơ đồ khối, biểu đồ phân tích và ảnh chụp thực tế**.
  - Không đọc chữ trên slide; mọi thông tin đều được biểu diễn trực quan.
- **Kịch Bản Nói Cầm Tay (`docs/02_SPEAKER_NOTES_AND_SCRIPT.md`)**:
  - Chứa toàn bộ kịch bản nói chi tiết từng câu chữ cho 14 slide.
  - Cung cấp sẵn các phương án trả lời các câu hỏi phản biện gài bẫy của Giảng viên (Memory leak, Vsync, Paint vs Rebuild, Gesture Arena).

---

## 4. Hướng Dẫn Chạy Ứng Dụng Demo

### Yêu cầu môi trường
- Flutter SDK $\ge 3.22.0$
- Dart SDK $\ge 3.4.0$

### Khởi chạy ứng dụng
```bash
cd week_04/app
flutter pub get
flutter run -d chrome # Hoặc thiết bị Android / iOS / Linux desktop
```

### Chạy bộ kiểm thử tự động
```bash
cd week_04/app
flutter test
```
Bộ kiểm thử tự động xác minh:
1. `Implicit Container Animation`: Kiểm tra giá trị kích thước và màu sắc biến thiên mượt mà qua các khung hình (`tester.pump()`).
2. `Explicit Controller Lifecycle`: Xác minh `AnimationController` được khởi tạo và hủy (`dispose`) an toàn, không còn active Ticker nào rò rỉ.
3. `Gesture Drag & Velocity`: Mô phỏng cử chỉ vuốt kéo thả và xác thực phản hồi không cản trở tương tác người dùng.
