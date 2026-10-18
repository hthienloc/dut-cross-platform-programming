# Giải Thích Đơn Giản: Kiến Trúc 3 Tầng & Nguyên Lý DIP

---

## 1. Kiến Trúc 3 Tầng Là Gì? (Hình Tượng Dễ Nhớ)

Thay vì viết tất cả mã nguồn (gọi mạng, lưu dữ liệu, vẽ giao diện) vào một file duy nhất, ta chia ứng dụng làm **3 tầng riêng biệt**:

```text
[ Giao Diện (Presentation) ]  ---> Hiển thị dữ liệu, nhận thao tác bấm của người dùng
             │
             ▼ phụ thuộc vào
[ Nghiệp Vụ (Domain) ]        ---> Trái tim ứng dụng (Thuần Dart, không dính dáng UI hay mạng)
             ▲
             │ hiện thực (implements)
[ Dữ Liệu (Data) ]            ---> Chịu trách nhiệm gọi REST API qua Internet
```

### Chi tiết 3 tầng trong bài làm:

1. **Tầng Presentation (Giao diện):**
   - File: `post_page.dart` (vẽ danh sách bài viết) và `post_bloc.dart` (quản lý trạng thái: đang tải, tải xong, lỗi).
   - **Quy tắc vàng:** Tầng này chỉ biết đến tầng Domain, **tuyệt đối không import tầng Data**.

2. **Tầng Domain (Nghiệp vụ cốt lõi - Thuần Dart):**
   - File: `post.dart` (đối tượng bài viết), `get_posts.dart` (hành động lấy bài viết), `post_repository.dart` (hợp đồng quy định cần những hàm gì).
   - **Đặc điểm:** Hoàn toàn là code Dart cơ bản, không có Flutter Widget, không có HTTP client. Nhờ vậy có thể chạy Unit Test siêu nhanh trong vài mili-giây.

3. **Tầng Data (Nguồn dữ liệu):**
   - File: `post_remote_data_source.dart` (gọi HTTP đến `jsonplaceholder.typicode.com`), `post_model.dart` (chuyển JSON thành Object), `post_repository_impl.dart` (thực hiện hợp đồng từ Domain).

---

## 2. Nguyên Lý Đảo Ngược Phụ Thuộc (DIP) Là Gì?

- **Hiểu đơn giản:** Tầng hiển thị (`Presentation`) không được phụ thuộc trực tiếp vào thư viện gọi mạng (`Data`).
- **Cách làm:**
  - Tầng `Domain` đặt ra một **hợp đồng trừu tượng (Interface)**:
    ```dart
    abstract class PostRepository {
      Future<Either<Failure, List<Post>>> getPosts();
    }
    ```
  - Tầng `Data` phải tuân thủ và làm theo hợp đồng đó:
    ```dart
    class PostRepositoryImpl implements PostRepository { ... }
    ```
  - Tầng `Presentation` chỉ cần gọi hợp đồng đó thông qua UseCase.
- **Ý nghĩa thực tế:** Sau này nếu muốn đổi nguồn dữ liệu từ REST API sang Database SQLite hoặc dùng Mock để test, ta chỉ cần thay đổi ở tầng Data; tầng giao diện giữ nguyên 100%, không cần sửa bất kỳ dòng mã nào.
