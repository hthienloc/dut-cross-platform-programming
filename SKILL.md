---
name: slide-and-report-guide
description: Standard workflow and presentation guidelines for academic topics, Slidev presentations, and technical scripts.
---

# Quy Chuẩn Thực Hiện Bài Báo Cáo & Trình Chiếu (Presentation Workflow Guide)

Tài liệu này đóng vai trò kim chỉ nam (Skill / Guide) cho toàn bộ các tuần báo cáo học phần Lập trình Đa nền tảng và các dự án kỹ thuật từ nay về sau.

---

## 1. Cấu Trúc Thư Mục Chuẩn Từng Tuần (`week_xx/`)

Mỗi tuần báo cáo cần được cấu trúc độc lập và gọn gàng theo mô hình 3 phần:

```text
week_xx/
├── app/                  # Mã nguồn ứng dụng demo (Flutter / Multiplatform)
│   ├── lib/              # Clean Architecture, phân tách module rõ ràng
│   └── test/             # Automated Widget Tests (Đảm bảo 100% pass)
├── docs/                 # Tài liệu kỹ thuật & Kịch bản thuyết trình
│   ├── 01_THEORY_AND_UX_ANALYSIS.md   # Phân tích lý thuyết chuyên sâu
│   └── 02_SPEAKER_NOTES_AND_SCRIPT.md # Kịch bản nói khớp 100% từng slide
└── slide/                # Bộ slide trình chiếu Slidev
    ├── package.json      # Dependencies Slidev & Playwright
    ├── slides.md         # Nguồn slide Markdown tinh gọn
    ├── presentation.pdf  # File PDF kết xuất độc lập (16:9)
    └── public/
        └── images/       # Toàn bộ ảnh crop component & sơ đồ vector SVG
```

---

## 2. Quy Chuẩn Làm Slide Với Slidev

### 2.1. Tinh Gọn Cú Pháp (Built-in Layouts Over Raw HTML)
- **Ưu tiên built-in layout của Slidev**: Dùng `layout: cover`, `layout: two-cols` (chia cột bằng `::right::`).
- **Hạn chế lạm dụng thẻ `<div>` lồng nhau**: Giữ cú pháp Markdown tự nhiên, dễ đọc và dễ bảo trì.
- **Tập trung vào Visual**: Hạn chế slide toàn chữ (Wall of Text). Mọi slide lý thuyết cần đi kèm biểu đồ đồ họa hoặc ảnh thực tế của component.

### 2.2. Quy Ước Cỡ Chữ Tối Thiểu (Minimum Readable Typography)
Để đảm bảo người ngồi xa trong phòng học/hội trường vẫn đọc rõ:
- **Tiêu đề Slide (`h1`)**: Cỡ chữ lớn `2rem` – `2.5rem` (`text-2xl` đến `text-3xl`).
- **Tiêu đề Phân khối / Card**: Tối thiểu `text-base` ($16$px) in đậm màu phân cấp rõ ràng.
- **Nội dung diễn giải (Body text / Cards)**: **Tối thiểu `text-sm` ($14$px)**, không dùng `text-xs` ($12$px) cho các nội dung đọc chính. Khoảng cách dòng `leading-relaxed` ($1.6$).
- **Ghi chú phụ / Footer**: Được phép dùng `text-xs` ($12$px) cho metadata hoặc caption.

### 2.3. Quy Chuẩn Đồ Họa & Biểu Đồ (Mermaid & Images)
- **Không nhúng Mermaid động trực tiếp vào `slides.md` khi xuất PDF**:
  - Trình duyệt headless xuất PDF sẽ bị lỗi trắng trang (render race condition).
  - **Bắt buộc**: Dùng `@mermaid-js/mermaid-cli` kết xuất trước các sơ đồ Mermaid sang file **Vector SVG** lưu tại `public/images/diag_*.svg`.
  - Nhúng trực tiếp ảnh SVG vào slide: `<img src="/images/diag_*.svg" class="max-h-[360px]" />`.
- **Ảnh động & Khung hình**:
  - Do PDF không chạy được file GIF, phải trích xuất các khung hình đại diện (Rest State, In-motion/Tilt State, Expanded State) thành các file PNG tĩnh chất lượng cao.
  - Sắp xếp 2 ảnh so sánh cạnh nhau bằng CSS Grid đồng bộ (`<div class="grid grid-cols-2 gap-6 pt-4 text-center">`) để đảm bảo 2 ảnh **thẳng hàng $Y$ tuyệt đối ($\Delta Y \le 1$px)**.

---

## 3. Quy Chuẩn Kịch Bản Thuyết Trình (`docs/02_SPEAKER_NOTES_AND_SCRIPT.md`)

- **Định dạng trang nối tiếp**:
  ```markdown
  ### Slide X: [Tiêu đề Slide]
  [Nội dung nói chuyên sâu mang tính kỹ thuật, giải thích bản chất kiến trúc và bối cảnh bên ngoài].
  *(Chuyển slide)* [Câu dẫn nhập nối tiếp tự nhiên sang slide tiếp theo].
  ```
- **Không đưa Q&A vào kịch bản chính**: Giữ tài liệu đọc trơn tru từ đầu đến cuối để diễn giả tập trung luyện nói.
- **Văn phong**: Chuyên nghiệp, tự tin, súc tích (30–45s/slide), không dùng các câu chào hỏi hay xin phép rườm rà.

---

## 4. Quy Chuẩn Kiểm Thử & Xuất Bản (Verification & Git Safety)

1. **Kiểm thử tự động trước khi xuất slide**:
   - `flutter test` phải pass 100%.
   - `dart analyze` không còn warning/error.
2. **Kiểm tra độ phủ mép đáy slide PDF (Bottom Margin Audit)**:
   - Dùng `pdftoppm` kết xuất các trang PDF ra PNG để kiểm tra chiều cao vùng vẽ.
   - Vùng nội dung chỉ được chiếm **$\le 90\%$** chiều cao trang ($Y \le 1010$px trên chuẩn 1125p), đảm bảo không cấn mép hoặc đè lên footer.
3. **Quy tắc Git**:
   - Chỉ commit local trong suốt quá trình người dùng tinh chỉnh.
   - Chỉ chạy `git push origin main` khi có lệnh trực tiếp từ người dùng.
