# Lập Trình Đa Nền Tảng (Dart & Flutter)

- **Cơ sở đào tạo**: Khoa Điện tử và Trí tuệ Nhân tạo — Trường Đại học Bách Khoa, Đại học Đà Nẵng
- **Giảng viên hướng dẫn**: TS. Nguyễn Duy Nhật Viễn
- **Sinh viên thực hiện**: Huỳnh Thiện Lộc (MSSV: 106230052)
- **Mô hình quản lý**: Monorepo theo tuần (`week_XX/`)

---

## 1. Cấu Trúc Repository

```text
.
├── templates/
│   └── slide/              # Template slide dùng chung (@preview/typslides:1.3.4)
│
├── week_01/                # Tuần 01 — Chủ đề 04: Clean Architecture & DI
│   ├── app/                # Flutter source code độc lập
│   ├── docs/               # Tài liệu phân tích, kiến trúc & phản biện
│   ├── slide/              # Slide báo cáo (Typst -> PDF 16:9)
│   └── README.md           # Báo cáo tóm tắt & hướng dẫn chạy
│
└── week_XX/                # Các tuần tiếp theo
```

---

## 2. Bảng Theo Dõi Tiến Độ

| Tuần | Chủ đề | Công nghệ trọng tâm | Trạng thái | Thư mục |
|:---:|:---|:---|:---:|:---:|
| **01** | Chủ đề 04: Kiến trúc Clean Architecture & Dependency Injection | Clean Architecture, DIP, `get_it`, `flutter_bloc`, Mocktail Unit Test | Hoàn thành | [week_01/](week_01) |
| **02** | Chủ đề 02: Lập trình Bất đồng bộ với Future & Stream trong Flutter | Dart Event Loop, `async/await`, `StreamController`, `StreamBuilder`, Resource Clean-up, `emitsInOrder` Test | Hoàn thành | [week_02/](week_02) |

---

## 3. Quy Chuẩn Dự Án

- **Slide**: Soạn bằng Typst (`@preview/typslides:1.3.4`), xuất PDF 16:9 theo form mẫu của trường.
- **Mã nguồn**: Tuân thủ Clean Code, Dart Style Guide, xử lý ngoại lệ an toàn, commit Git rõ ràng.
- **Kiểm thử**: Đạt kiểm thử Unit Test độc lập cho tầng Domain với Mock Repository.
