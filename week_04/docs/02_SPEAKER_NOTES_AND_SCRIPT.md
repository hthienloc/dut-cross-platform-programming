# Bảng Hướng Dẫn Thuyết Trình Cô Đọng: Animation & Gesture Nâng Cao

> **Tiêu chí**: Cực kỳ tinh gọn, không rườm rà. Tập trung thẳng vào thông điệp kỹ thuật cốt lõi của từng slide và câu hỏi phản biện gài bẫy của Giảng viên.

---

## Ma Trận Điều Hướng Nhanh (15 Slide)

| # | Slide Title | Trọng tâm thị giác | Lời nói cốt lõi (Core Script) | Điểm Giảng viên sẽ hỏi (Q&A Trap) |
| :---: | :--- | :--- | :--- | :--- |
| **01** | Bìa | Thông tin đề tài 08 | Giới thiệu Chủ đề 08: Animation và Cử chỉ nâng cao trong Flutter. | |
| **02** | Mục lục | 2 cột lộ trình 13 mục | Báo cáo gồm 3 phần: Vai trò & Cơ sở lý thuyết, Đấu trường cử chỉ, Thực hành & Demo. | |
| **03** | Animation & UX Roles | Sơ đồ: Static UI $\to$ Motion $\to$ UX | Animation không phải trang trí, mà để tạo tính liên tục thị giác (State Continuity), dẫn dắt tập trung (Guided Focus), và phản hồi chạm $<100$ms. | Tại sao app không có animation lại bị đánh giá thấp? (Gây đứt gãy nhận thức khi layout thay đổi đột ngột). |
| **04** | Requirements (Spec) | 2 khối Lý thuyết & Thực hành | Đề bài yêu cầu phân tích Implicit vs Explicit, quản lý tài nguyên Controller, cơ chế Gesture, và bảo đảm chuyển động Non-blocking. | |
| **05** | Animation Architecture | Sơ đồ 4 tầng Flutter | Tầng Widgets nhận khai báo $\to$ Controller/Tween điều khiển $\to$ Ticker bắt nhịp Vsync $\to$ GPU chỉ vẽ lại Transform Layer mà không rebuild widget con. | Animation trong Flutter hoạt động ở tầng nào? (Chạy ở Render/Layer tree, phát nhịp bởi Ticker của hệ điều hành). |
| **06** | Implicit vs Explicit | Ma trận so sánh 2 nhánh | Implicit (Declarative): Tự nội suy khi đổi Target Value, Zero Boilerplate, không thể rò rỉ bộ nhớ. Explicit: Dùng Controller, kiểm soát toàn diện hướng chạy và vòng lặp. | Khi nào bắt buộc phải dùng Explicit? (Khi cần lặp lại, đảo chiều, hoặc gắn kết theo tay người dùng kéo thả). |
| **07** | Explicit Lifecycle | Sơ đồ tham chiếu & Safe Dispose | `AnimationController` giữ tham chiếu mạnh tới `Ticker`. Bắt buộc gọi `controller.dispose()` TRƯỚC `super.dispose()` để tránh Memory Leak trên Heap. | Tại sao không được gọi `super.dispose()` trước? (Sẽ hủy TickerProvider khi Ticker đang chạy $\to$ Framework ném assertion crash). |
| **08** | Gesture Arena | Quy trình PointerDown $\to$ Winner | Khi nhiều gesture cùng bắt chạm, chúng vào Đấu trường. Vượt qua ngưỡng Touch Slop ($18$dp), Recognizer theo hướng ngón tay sẽ Declare Win hoặc đối thủ tự rút lui. | Nếu cha và con cùng nhận Tap, ai thắng? (Con thắng vì widget con được thêm vào Arena trước - First-come First-served). |
| **09** | UX Motion Principles | Thang thời lượng $<100$ms $\to$ $>500$ms | 3 nguyên tắc sống còn: Phản hồi chạm $<100$ms, chuyển cảnh $150-350$ms. Tuyệt đối không dùng animation dài $>500$ms gây cản trở thao tác. | Làm sao chuyển động không cản trở thao tác? (Non-blocking, cho phép Interrupt/đảo chiều, hỗ trợ Reduced Motion). |
| **10** | App Architecture | Sơ đồ cấu trúc app & Codebase | App xây dựng trên Design Tokens chuẩn lưới 8dp, tách biệt 3 phân hệ: Implicit Card, Drag Spring Card, Morphing Action Button. | Tại sao dùng lưới 8dp? (Khớp mật độ điểm ảnh 1x/2x/3x, triệt tiêu lỗi lệch subpixel). |
| **11** | Implicit Motion | Ảnh so sánh 2 trạng thái thật | `AnimatedContainer` tự động biến đổi mượt mà chiều cao, màu nền, đường viền khi người dùng bấm nút, không dùng bất kỳ Controller nào. | Tại sao `AnimatedContainer` không bao giờ leak memory? (Framework tự động dọn dẹp controller nội bộ khi unmount). |
| **12** | Explicit & Spring | Ảnh thẻ kéo nghiêng & nảy về | `GestureDetector` theo dõi tọa độ 2D pan. Khi buông tay, `SpringSimulation` lấy vector vận tốc `velocity` để kéo thẻ nảy về gốc $(0,0)$ tự nhiên. | Ưu điểm của SpringSimulation so với Curve thông thường? (Tự động thích ứng với lực và tốc độ vung tay của người dùng). |
| **13** | Automated Tests | 5 kịch bản test passed 100% | Đạt 5/5 bài kiểm thử tự động: kiểm tra nội suy từng frame, tính toán nảy lò xo, async không khóa UI, và xác minh không còn Ticker nào rò rỉ. | |
| **14** | Decision Tree | Cây quyết định kỹ thuật | Cần lặp/kéo thả? $\to$ Dùng Explicit (nhớ dispose). Chỉ đổi giao diện theo state? $\to$ Luôn ưu tiên Implicit để mã nguồn tối giản và an toàn. | |
| **15** | References | Danh mục link chính thức | Toàn bộ kiến trúc và số liệu được đối chiếu trực tiếp từ docs.flutter.dev và m3.material.io (đều kiểm tra HTTP 200 OK). | |
