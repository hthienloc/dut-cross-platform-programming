# Kịch Bản Thuyết Trình: Animation & Cử Chỉ Nâng Cao

---

### Slide 1: Advanced Animations & Gestures in Flutter
Em xin báo cáo Chủ đề 08: Animation và Cử chỉ nâng cao trong Flutter được Thầy phân công.

---

### Slide 2: Agenda
Nội dung gồm 2 phần: Cơ chế kiến trúc cốt lõi và Triển khai thực tế trên Demo App.

---

### Slide 3: 1. Animation & UX Roles
Animation giải quyết 3 bài toán UX lớn: duy trì liên tục không gian chuyển cảnh, dẫn hướng mắt đến dữ liệu mới, và phản hồi xúc giác tức thời dưới 100ms.

---

### Slide 4: 2. Technical Requirements
Đề bài yêu cầu phân tích 2 trường phái Implicit - Explicit, cơ chế phân giải Gesture Arena, và bảo đảm chuyển động Non-blocking không cản trở thao tác.

---

### Slide 5: 3. Flutter Motion Architecture
Kiến trúc 4 tầng: Ticker khóa xung VSync phần cứng màn hình, GPU chỉ cập nhật trực tiếp Transform Layer mà không rebuild lại cây Widget con.

---

### Slide 6: 4. Implicit vs Explicit Matrix
Implicit là Declarative, tự quản lý vòng đời nên đạt Zero Memory Leak. Explicit là Imperative, cho phép lặp, đảo chiều và gắn cử chỉ kéo thả, nhưng buộc phải giải phóng thủ công.

---

### Slide 7: 5. Explicit Lifecycle & Memory Safety
`AnimationController` giữ tham chiếu mạnh tới `TickerProvider`. Quên gọi `controller.dispose()` sẽ khiến Engine Scheduler giữ rò rỉ bộ nhớ vĩnh viễn dù màn hình đã unmount.

---

### Slide 8: 6. Gesture Arena & Disambiguation
Mọi cử chỉ chạm đều vào Đấu trường Arena. Chỉ cần ngón tay trượt quá ngưỡng 18dp, PanRecognizer lập tức thắng cuộc và hủy TapRecognizer để nhận toàn quyền cử chỉ.

---

### Slide 9: 7. UX Latency Thresholds
Chuẩn thời gian M3: Phản hồi chạm phải dưới 100ms, chuyển cảnh 150 đến 350ms. Chuyển động trên 500ms sẽ gây cảm giác chậm chạp và ức chế.

---

### Slide 10: 8. Architecture & Motion Tokens
Ứng dụng Demo xây dựng trên hệ thống MotionTokens chuẩn lưới 8dp, tách biệt 3 phân hệ chuyển động độc lập và đồng bộ nhịp VSync 60/120Hz.

---

### Slide 11: 9. Implicit Motion: State Interpolation
Với `AnimatedContainer`, chỉ cần thay đổi biến State; framework tự động nội suy mượt mà kích thước, màu nền và bo góc mà không cần Controller.

---

### Slide 12: 9. Implicit Motion: Mechanics
Cơ chế tự tính toán delta và cập nhật RenderObject bên dưới giúp code gọn nhất và triệt tiêu hoàn toàn nguy cơ rò rỉ bộ nhớ.

---

### Slide 13: 10. Explicit Gestures: Spring Physics
Sử dụng `GestureDetector` đồng bộ tọa độ kéo 2D và góc nghiêng; khi buông tay, `SpringSimulation` lấy vận tốc vung tay để kéo thẻ nảy đàn hồi về gốc.

---

### Slide 14: 10. Explicit Gestures: Mechanics
Liên kết trực tiếp giữa sự kiện `onPanUpdate` với hàm mô phỏng vật lý trong `onPanEnd`, kết thúc an toàn bằng lệnh hủy trong `dispose()`.

---

### Slide 15: 11. Automated Test Suite
Mã nguồn được kiểm thử tự động 5 kịch bản: render layout, biến thiên frame, bám tọa độ kéo thả, async không chặn UI, và xác minh giải phóng 100% Ticker.

---

### Slide 16: 12. Decision Matrix
Quy tắc lựa chọn: Luôn ưu tiên dùng Implicit làm mặc định để an toàn; chỉ dùng Explicit khi bài toán thực sự cần lặp vô hạn hoặc gắn với cử chỉ tay.

---

### Slide 17: 13. References
Toàn bộ tài liệu tham khảo chính thức được đối chiếu trực tiếp từ trang tài liệu gốc của Flutter và Material Design 3. Em xin kết thúc phần báo cáo.
