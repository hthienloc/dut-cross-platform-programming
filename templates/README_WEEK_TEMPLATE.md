# Tuần XX — <<Tên Chủ Đề Theo Spec>>

- **Môn học**: Lập trình Đa nền tảng
- **Giảng viên hướng dẫn**: TS. Nguyễn Duy Nhật Viễn
- **Sinh viên thực hiện**: Huỳnh Thiện Lộc (MSSV: 106230052) — Tỷ lệ đóng góp: 100%

---

## 1. Đề Bài Nguyên Mẫu Từ Giảng Viên (Spec)

> **Chủ đề XX: <<Tên chủ đề đầy đủ>>**
> 
> - **Nội dung:** <<Trích dẫn nguyên văn phần nội dung từ Chude_LaptrinhDanentang.pdf>>
> - **Yêu cầu demo:** <<Trích dẫn nguyên văn phần yêu cầu demo từ Chude_LaptrinhDanentang.pdf>>

---

## 2. Cấu Trúc Thư Mục Tuần XX

```text
week_XX/
├── app/                        # Ứng dụng Flutter Demo độc lập
│   ├── lib/
│   └── test/
├── docs/                       # Tài liệu kỹ thuật chuyên sâu & lý thuyết
└── slide/                      # Slide báo cáo Typst (typslides:1.3.4)
    ├── main.typ
    └── main.pdf
```

---

## 3. Hướng Dẫn Chạy & Kiểm Thử

### 3.1. Slide thuyết trình
```bash
typst compile slide/main.typ slide/main.pdf
```

### 3.2. Chạy kiểm thử Unit Test
```bash
cd app
flutter test
```

### 3.3. Chạy ứng dụng Demo
```bash
cd app
flutter pub get
flutter run
```
