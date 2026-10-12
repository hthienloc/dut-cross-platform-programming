# Hướng Dẫn Sử Dụng Template Slide Hàng Tuần (Typslides)

Thư mục này chứa khung slide mẫu chung (Boilerplate) viết bằng **Typst** kết hợp package `@preview/typslides:1.3.4`, được định dạng chuẩn theo mẫu [MauBaocaoTuan.pdf](file:///home/loccun/Downloads/MauBaocaoTuan.pdf).

---

## 1. Cách tạo slide cho tuần mới

Mỗi tuần mới, bạn chỉ cần sao chép thư mục template sang thư mục tuần tương ứng:

```bash
# Ví dụ tạo slide cho tuần 1:
cp -r template_slide week01_slide

# Hoặc cho tuần 2:
cp -r template_slide week02_slide
```

---

## 2. Các vị trí cần điền thông tin trong `main.typ`

Mỗi tuần chỉ cần mở `main.typ` và thay đổi các placeholder:
1. `title`: Tên chủ đề tuần đó (ví dụ: `Chủ đề 04: Kiến trúc Clean Architecture & DI`).
2. `authors`: Tên thành viên và MSSV.
3. Bảng WBS (`table`): Phân công công việc giữa 2 thành viên và tỷ lệ %.
4. `Phần I`: Đặt vấn đề, mục tiêu và nguyên lý của chủ đề tuần.
5. `Phần II`: Sơ đồ kiến trúc & luồng dữ liệu (Data Flow).
6. `Phần III`: Cấu trúc code, đoạn code then chốt và kết quả test/demo.
7. `Tài liệu tham khảo`: Link tài liệu chính thức liên quan.

---

## 3. Lệnh biên dịch PDF

```bash
# Biên dịch ra file PDF:
typst compile main.typ main.pdf

# Xem trực tiếp thay đổi trong khi gõ (Live Reload):
typst watch main.typ main.pdf
```
