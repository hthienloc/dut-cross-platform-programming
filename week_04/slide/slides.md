---
theme: default
background: '#f8fafc'
title: Animation & Cử Chỉ Nâng Cao
info: Báo cáo Tuần 04 - Môn Lập trình Đa nền tảng
highlighter: shiki
drawings:
  persist: false
transition: slide-left
layout: cover
---

# Animation & Cử Chỉ Nâng Cao
Chủ đề 08: Báo cáo Tuần 04 — Môn: Lập trình Đa nền tảng

**SVTH:** Huỳnh Thiện Lộc (MSSV: 106230052)  
**GVHD:** TS. Nguyễn Duy Nhật Viễn

<div class="pt-4 flex gap-2">
  <span class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs font-semibold">Flutter Motion</span>
  <span class="px-2 py-1 bg-green-100 text-green-800 rounded text-xs font-semibold">Gesture Arena</span>
  <span class="px-2 py-1 bg-purple-100 text-purple-800 rounded text-xs font-semibold">60/120 FPS VSync</span>
</div>

<!--
Chào Thầy và các bạn. Hôm nay em xin báo cáo Chủ đề 08: Animation và Cử chỉ nâng cao trong Flutter.
-->

---
layout: two-cols
---

# Nội dung báo cáo

### Phần 1: Nền tảng Lý thuyết
1. Animation & UX Roles
2. Requirements (Spec)
3. Flutter Animation Architecture
4. Implicit vs Explicit Matrix
5. Explicit Lifecycle & Memory Safety
6. Gesture Arena & Disambiguation
7. UX Motion Principles & Latency

::right::

<div class="pt-10">

### Phần 2: Thực thi & Minh chứng
8. Application Architecture
9. Implicit Motion: State Interpolation
10. Explicit & Gestures: Spring Physics
11. Automated Verification & Tests
12. Engineering Decision Tree
13. References & Verified Sources

</div>

<!--
Nội dung báo cáo gồm 2 phần lớn: Cơ chế cốt lõi (Kiến trúc Render, Lifecycle, Gesture Arena) và Ứng dụng demo thực tế kiểm thử 5/5 kịch bản.
-->

---

# 1. Animation & UX Roles

Ba trụ cột nền tảng giải quyết bài toán trải nghiệm người dùng:

| Trụ Cột | Trọng Tâm | Giá Trị Cốt Lõi |
| :--- | :--- | :--- |
| **1. Spatial Continuity** | Tính liên tục không gian | Giúp não bộ kết nối nguồn gốc biến đổi, triệt tiêu giật cục thị giác |
| **2. Focus Guidance** | Dẫn dắt sự chú ý | Hướng mắt người dùng đến vị trí dữ liệu mới vừa xuất hiện |
| **3. Touch Feedback** | Phản hồi xúc giác (< 100ms) | Xác nhận thao tác chạm tức thì, chống việc bấm đúp do tưởng lag |

<!--
Animation không phải để trang trí. Nó giải quyết 3 bài toán UX lớn: Tính liên tục không gian, Dẫn hướng mắt, và Phản hồi tức thì dưới 100ms.
-->

---
layout: two-cols
---

# 2. Requirements (Spec)

### 1. Theoretical Foundation
- **Implicit Animation:** Tự động nội suy Declarative.
- **Explicit Animation:** Điều khiển bằng `AnimationController`.
- **Gesture Arena:** Phân giải xung đột cử chỉ chạm.
- **Non-blocking UX:** Không khóa luồng tương tác.

::right::

<div class="pt-10">

### 2. Practice & Demo App
- **Implicit Card:** Biến đổi size, color, radius.
- **Draggable Spring Card:** Pan 2D + lực kéo lò xo.
- **Morphing Button:** Async animation mượt mà.
- **Automated Tests:** 5/5 test pass, 0 memory leak.

</div>

<!--
Đề bài yêu cầu nắm vững cả 2 trường phái Implicit & Explicit, phân giải xung đột Gesture, và chứng minh tính không cản trở thao tác.
-->

---

# 3. Flutter Animation Architecture

Kiến trúc 4 tầng phân tách trách nhiệm rõ ràng:

1. **Tầng Widgets (Khai báo):** `AnimatedContainer` (Implicit) hoặc `SlideTransition` (Explicit).
2. **Tầng Điều khiển & Nội suy:** `AnimationController` (0.0 → 1.0) kết hợp `Tween<T>` và `CurvedAnimation`.
3. **Tầng Làm tươi đồng bộ:** `Ticker` & `TickerProvider` khóa xung VSync hệ điều hành (60Hz / 120Hz).
4. **Tầng Phần cứng (GPU Render):** Cập nhật trực tiếp Transform Layer mà **không cần rebuild cây Widget**.

<!--
Kiến trúc phân tầng Flutter: Widget chỉ là bản khai báo. Ticker bắt nhịp VSync từ hệ điều hành, và GPU chỉ việc cập nhật Layer biến hình mà không phải rebuild lại cây widget.
-->

---

# 4. Implicit vs Explicit Matrix

| Tiêu Chí So Sánh | Implicit Animation | Explicit Animation |
| :--- | :--- | :--- |
| **Tư duy lập trình** | Declarative (Khai báo đích đến) | Imperative (Điều khiển luồng thời gian) |
| **Quản lý Controller** | **Tự động** (Được đóng gói trong State) | **Thủ công** (`AnimationController`) |
| **Rủi ro Memory Leak** | **0% (Zero Leak)** | **Cao** (Nếu quên `dispose()`) |
| **Lặp lại / Đảo chiều** | Không hỗ trợ | Hỗ trợ đầy đủ (`repeat`, `reverse`) |
| **Gắn kết cử chỉ Pan** | Không khả thi | Đồng bộ mượt mà theo tọa độ ngón tay |

<!--
Ma trận so sánh: Implicit cực kỳ an toàn vì không thể rò rỉ bộ nhớ, nhưng khi cần lặp vô hạn hoặc gắn với cử chỉ tay thì bắt buộc phải dùng Explicit.
-->

---

# 5. Explicit Lifecycle & Memory Safety

Quy trình quản lý vòng đời chặt chẽ chống rò rỉ bộ nhớ:

```text
[1. initState] --------> [2. Ticker Hook] --------> [3. Running Frame] --------> [4. dispose]
Tạo Controller           Đăng ký nhịp VSync          Nội suy giá trị             HỦY TICKER
vsync: this              vào Engine Scheduler        (0.0 -> 1.0)                CHỐNG MEMORY LEAK
```

> **Cảnh báo bẫy Giảng viên:**  
> Nếu quên gọi `controller.dispose()`, đối tượng `TickerProvider` sẽ bị giữ lại trong Engine Scheduler qua **Strong Reference**, khiến Garbage Collector không thể giải phóng màn hình dù widget đã bị unmount.

<!--
Vòng đời bắt đầu từ initState và kết thúc bắt buộc tại dispose. Quên dispose sẽ tạo Strong Reference khiến Garbage Collector không thể giải phóng màn hình.
-->

---

# 6. Gesture Arena & Disambiguation

Quy trình giải quyết tranh chấp cử chỉ chạm:

```text
PointerDown  --->  PointerMove (> 18dp slop)  --->  Arena Sweep  --->  PointerUp
Ghi danh           PanRecognizer tuyên bố          Hủy bỏ              SpringSimulation
mọi Recognizer     CHIẾN THẮNG                     TapRecognizer       kéo nảy về gốc (0,0)
```

- **Tọa độ Pan 2D:** Biến đổi độ lệch vị trí và tính toán góc nghiêng tự nhiên.
- **SpringSimulation:** Mô phỏng vật lý hồi phục đàn hồi theo vận tốc vung tay của người dùng.

<!--
Gesture Arena giải quyết xung đột: khi di chuyển vượt ngưỡng slop (18dp), PanRecognizer sẽ loại bỏ TapRecognizer để nhận toàn quyền cử chỉ.
-->

---

# 7. UX Motion Principles & Latency

Quy chuẩn thời gian theo tâm lý học nhận thức (Material Design 3):

| Ngưỡng Thời Gian | Phân Loại Cảm Nhận | Ứng Dụng Thực Tế |
| :--- | :--- | :--- |
| **< 100 ms** | Phản hồi tức thời (Instant) | Phản hồi chạm ngón tay (Touch Ripple, Pressed state) |
| **150 – 350 ms** | Chuyển cảnh chuẩn vàng (Natural) | Mở rộng thẻ, điều hướng màn hình, trượt menu |
| **> 500 ms** | Ngưỡng gây khó chịu (Sluggish) | Gây cảm giác chậm chạp, lề mề cho ứng dụng |

- **Non-Blocking UX:** Không khóa luồng cảm ứng khi hiệu ứng đang chạy.
- **Interruptible:** Cho phép người dùng ngắt chuyển động hoặc kéo đổi hướng tức thì.

<!--
Về mặt tâm lý học thời gian: Phản hồi chạm phải dưới 100ms, chuyển cảnh 150-350ms. Trên 500ms người dùng sẽ bắt đầu thấy khó chịu và bực bội.
-->

---
layout: two-cols
---

# 8. Application Architecture

Kiến trúc Demo App (`week_04/app`):

- **MotionTokens (Lưới 8dp):**  
  `space8`, `space16`, `space24`.
- **3 Phân hệ chuyển động độc lập:**
  1. `ImplicitMotionCard`: Tự nội suy Declarative.
  2. `DragSpringCard`: Gesture Arena + Lò xo.
  3. `MorphingActionButton`: Async không chặn UI.
- **Đồng bộ VSync:**  
  Tự động phát nhịp 60Hz / 120Hz.

::right::

<div class="flex justify-center pt-2">
  <img src="/images/app_overview_cropped.png" class="max-h-[360px] rounded-lg shadow border" />
</div>

<!--
Ứng dụng demo được thiết kế theo chuẩn Clean Architecture, tách biệt rõ 3 phân hệ chuyển động tương ứng với 3 yêu cầu của đề bài.
-->

---
layout: two-cols
---

# 9. Implicit Motion: State Interpolation

### 1. Trạng thái At Rest
<img src="/images/comp_implicit_rest.png" class="max-h-[220px] rounded border shadow-sm" />

::right::

### 2. Trạng thái Interpolated
<img src="/images/comp_implicit_expanded.png" class="max-h-[220px] rounded border shadow-sm" />

---

# 9. Implicit Motion (Chi tiết cơ chế)

- **AnimatedContainer:** Tự động so sánh giá trị cũ và mới của thuộc tính (`width`, `height`, `decoration`).
- **Nội suy mượt mà:** Tính toán giá trị trung gian qua từng khung hình mà không cần viết `AnimationController`.
- **Zero Memory Leak:** Vòng đời bộ nhớ được Flutter framework quản lý 100% tự động.

<!--
Khi bấm nút, AnimatedContainer tự so sánh kích thước cũ và mới rồi nội suy mượt mà qua từng frame. Hoàn toàn không phát sinh rò rỉ bộ nhớ.
-->

---
layout: two-cols
---

# 10. Explicit & Gestures: Spring Physics

### 1. Trạng thái tại Gốc (0, 0)
<img src="/images/comp_drag_rest.png" class="max-h-[220px] rounded border shadow-sm" />

::right::

### 2. Đang Kéo & Xoay Quán Tính
<img src="/images/comp_drag_active.png" class="max-h-[220px] rounded border shadow-sm" />

---

# 10. Explicit & Gestures (Chi tiết cơ chế)

- **GestureDetector:** Bắt trọn tọa độ kéo 2D `onPanUpdate` để xoay góc thẻ theo độ dời ngón tay.
- **SpringSimulation:** Khi buông tay (`onPanEnd`), khởi chạy hàm vật lý lò xo đưa thẻ nảy đàn hồi về gốc `(0, 0)` theo đúng quán tính vung tay.
- **Explicit Lifecycle:** Buộc phải giải phóng qua `controller.dispose()` để tránh rò rỉ bộ nhớ Ticker.

<!--
Sử dụng GestureDetector kết hợp SpringSimulation. Góc nghiêng tự tính theo độ dời pan. Buông tay ra là thẻ tự nảy đàn hồi về gốc theo đúng vận tốc tay người dùng.
-->

---

# 11. Automated Verification & Tests

Hệ thống kiểm thử tự động 5/5 kịch bản (Passed 100% ~ 2.5s):

1. **Launch M3:** Khởi chạy thành công giao diện và render đầy đủ 3 phân hệ.
2. **Implicit Interpolation:** Kích hoạt mở rộng thẻ, kiểm tra biến thiên từng khung hình.
3. **Gesture Drag & Recoil:** Vuốt dời 80px, kiểm tra trạng thái Dragging và nảy về gốc (0,0).
4. **Non-Blocking Async:** Nút Morphing Button chạy tác vụ ngầm mà không khóa UI pipeline.
5. **Memory Leak Teardown:** Unmount widget, xác nhận thu hồi 100% Ticker tài nguyên.

```text
✓ flutter test: All tests passed! (5/5 passed)
✓ dart analyze: No issues found!
```

<!--
Toàn bộ mã nguồn đã được kiểm thử tự động 5/5 kịch bản, xác thực không còn Ticker nào bị bỏ quên khi màn hình bị unmount.
-->

---
layout: two-cols
---

# 12. Engineering Decision Tree

### Implicit Animation (Mặc định)
- Chỉ cần đổi giao diện khi State thay đổi.
- Chuyển động 1 chiều từ trạng thái A → B.
- **Ưu điểm:** Zero Memory Leak, viết code nhanh, bảo trì đơn giản nhất.

::right::

<div class="pt-10">

### Explicit Animation (Nâng cao)
- Cần lặp vô hạn hoặc đảo chiều giữa chừng.
- Gắn kết trực tiếp với cử chỉ tay người dùng.
- **Lưu ý:** Bắt buộc quản lý vòng đời `dispose()` nghiêm ngặt.

</div>

<!--
Cây quyết định: Hãy luôn chọn Implicit làm mặc định để an toàn và tiết kiệm chi phí bảo trì. Chỉ dùng Explicit khi thực sự cần kiểm soát hướng chuyển động và cử chỉ phức tạp.
-->

---

# 13. References & Verified Sources

Tất cả tài liệu tham khảo chính thức (Đã xác minh kết nối HTTP 200 OK):

- **Flutter Animations Overview:** [docs.flutter.dev/ui/animations/overview](https://docs.flutter.dev/ui/animations/overview)
- **Implicit Animations Guide:** [docs.flutter.dev/ui/animations/implicit-animations](https://docs.flutter.dev/ui/animations/implicit-animations)
- **Gestures & Disambiguation Arena:** [docs.flutter.dev/ui/interactivity/gestures](https://docs.flutter.dev/ui/interactivity/gestures)
- **AnimationController Class:** [api.flutter.dev/flutter/animation/AnimationController-class.html](https://api.flutter.dev/flutter/animation/AnimationController-class.html)
- **GestureArenaManager Class:** [api.flutter.dev/flutter/gestures/GestureArenaManager-class.html](https://api.flutter.dev/flutter/gestures/GestureArenaManager-class.html)
- **Material Design 3 Motion:** [m3.material.io/styles/motion/overview/how-it-works](https://m3.material.io/styles/motion/overview/how-it-works)

<!--
Toàn bộ tài liệu tham khảo chính thức đều được kiểm tra mở và hoạt động bình thường. Em xin cảm ơn Thầy và các bạn đã theo dõi bài báo cáo.
-->
