# Lập Trình Đa Nền Tảng (Dart & Flutter)

- **Cơ sở đào tạo**: Khoa Điện tử và Trí tuệ Nhân tạo — Trường Đại học Bách Khoa, Đại học Đà Nẵng
- **Giảng viên hướng dẫn**: TS. Nguyễn Duy Nhật Viễn
- **Sinh viên thực hiện**: Huỳnh Thiện Lộc (MSSV: 106230052)
- **Mô hình quản lý**: Monorepo theo tuần (`week_XX/`)

---

## 1. Cấu Trúc Repository

```text
.
├── agents.md               # Quy định môn học, tiêu chí chấm điểm & nguyên tắc code
├── templates/
│   └── slide/              # Template slide dùng chung (@preview/typslides:1.3.4)
│       ├── main.typ
│       └── README.md
│
├── week_01/                # Tuần 01 — Chủ đề 04: Clean Architecture & DI
│   ├── app/                # Flutter source code độc lập
│   ├── docs/               # Tài liệu phân tích, đặc tả kiến trúc & unit test
│   ├── slide/              # Slide báo cáo tuần 1 (Typst)
│   └── README.md           # Hướng dẫn chạy & tổng kết tuần 1
│
└── week_XX/                # Các tuần tiếp theo
```

---

## 2. Bảng Theo Dõi Tiến Độ Hàng Tuần

| Tuần | Chủ đề | Công nghệ trọng tâm | Trạng thái | Thư mục |
|:---:|:---|:---|:---:|:---:|
| **01** | Chủ đề 04: Kiến trúc Clean Architecture & Dependency Injection | Clean Architecture, DIP, `get_it`, `flutter_bloc`, Mocktail Unit Test | 🔄 Đang triển khai | [week_01/](file:///home/loccun/Documents/Năm 4 - Kì 1/LT Đa nền tảng/Hell/week_01) |
| **02** | *Đang cập nhật theo tiến độ giảng viên* | — | ⏳ Chờ | — |

---

## 3. Tiêu Chuẩn Nộp Bài & Báo Cáo (Tham khảo `agents.md`)

- **Slide thuyết trình**: Biên dịch trực tiếp từ Typst sang PDF (tỷ lệ 16:9).
- **Mã nguồn**: Tuân thủ Clean Code, Dart Style Guide, xử lý ngoại lệ chặt chẽ, commit Git có ý nghĩa.
- **Demo**: Chạy ổn định trên Real Device / Emulator.
- **Unit Test**: Đạt kiểm thử độc lập cho tầng Domain với dependency được mock.
