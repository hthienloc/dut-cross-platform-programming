# Tuần 01 — Chủ Đề 04: Clean Architecture & Dependency Injection (DI)

- **Môn học**: Lập trình Đa nền tảng
- **Giảng viên hướng dẫn**: TS. Nguyễn Duy Nhật Viễn
- **Sinh viên thực hiện**: Huỳnh Thiện Lộc (MSSV: 106230052) — Tỷ lệ đóng góp: 100%

---

## 1. Đề Bài Nguyên Mẫu Từ Giảng Viên (Spec)

> **Chủ đề 04: Kiến trúc ứng dụng Flutter — Clean Architecture & Dependency Injection (DI)**
> 
> - **Nội dung:** Phân chia lớp theo Clean Architecture (Presentation / Domain / Data); nguyên lý đảo ngược phụ thuộc (Dependency Inversion Principle); Repository Pattern & UseCase (Interactor); Dependency Injection với get_it và injectable / Riverpod; cơ chế khởi tạo và liên kết phụ thuộc (WidgetsBinding, MultiBlocProvider).
> - **Yêu cầu demo:** Xây dựng ứng dụng đọc dữ liệu từ REST API theo kiến trúc 3 lớp rõ ràng; viết unit test cho tầng Domain với dependency được mock (abstract interface), chứng minh tầng Presentation không phụ thuộc trực tiếp vào Data Source.

---

## 2. Cấu Trúc Thư Mục Tuần 01

```text
week_01/
├── app/                        # Ứng dụng Flutter Demo REST API
│   ├── lib/
│   │   ├── core/               # Base UseCase, Error/Failure handling
│   │   ├── di/                 # Service Locator (get_it injection container)
│   │   ├── features/post/      # Feature đọc dữ liệu từ REST API
│   │   │   ├── data/           # Models, DataSources, Repo Implementations
│   │   │   ├── domain/         # Entities, Repo Interfaces, UseCases
│   │   │   └── presentation/   # BLoC, Pages, Widgets
│   │   └── main.dart           # Khởi tạo DI, WidgetsFlutterBinding & App Root
│   └── test/                   # Unit test tầng Domain với Mocktail
├── docs/                       # Tài liệu kỹ thuật chuyên sâu & lý thuyết
│   ├── 01_SLIDE_OUTLINE.md     # Đề cương slide
│   ├── 02_THEORY_CLEAN_ARCH.md # Lý thuyết 3 tầng & Nguyên lý DIP
│   ├── 03_DI_IMPLEMENTATION.md # Service locator get_it & MultiBlocProvider
│   └── 04_TESTING_SPEC.md      # Đặc tả kiểm thử tầng Domain
└── slide/                      # Slide báo cáo Typst (typslides:1.3.4)
    ├── main.typ
    └── main.pdf
```

---

## 3. Hướng Dẫn Chạy & Kiểm Thử

### 2.1. Slide thuyết trình
```bash
# Xem slide PDF đã biên dịch:
xdg-open slide/main.pdf

# Hoặc biên dịch lại khi sửa:
typst compile slide/main.typ slide/main.pdf
```

### 2.2. Chạy kiểm thử Unit Test (Domain Layer)
```bash
cd app
flutter test
```

### 2.3. Chạy ứng dụng Demo
```bash
cd app
flutter pub get
flutter run
```
