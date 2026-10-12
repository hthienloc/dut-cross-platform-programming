# Đặc Tả Kiểm Thử (Unit Test) Tầng Domain & Chứng Minh Tính Độc Lập

---

## 1. Mục tiêu kiểm thử

1. **Kiểm thử độc lập (Isolation)**: Tầng `Domain` chứa logic nghiệp vụ thuần túy (`UseCase`). Khi chạy test cho tầng này:
   - Không được gọi HTTP request thật đến REST API.
   - Không cần khởi chạy simulator / thiết bị thật hoặc Flutter widget.
   - Sử dụng Mock Object để giả lập hành vi của `PostRepository`.
2. **Chứng minh tầng Presentation không phụ thuộc vào Data Source**:
   - `PostBloc` chỉ phụ thuộc vào `GetPostsUseCase`.
   - `GetPostsUseCase` chỉ phụ thuộc vào trừu tượng `PostRepository`.
   - Có thể thay đổi nguồn dữ liệu từ REST API sang Mock, InMemory hoặc Local Cache mà không làm thay đổi kiểm thử hay code của Presentation.

---

## 2. Kỹ thuật Mocking với `mocktail`

### 2.1. Định nghĩa Mock Repository
```dart
import 'package:mocktail/mocktail.dart';
// Chỉ import interface từ domain, tuyệt đối KHÔNG import Data Layer
import 'package:clean_architecture_demo/features/post/domain/repositories/post_repository.dart';

class MockPostRepository extends Mock implements PostRepository {}
```

### 2.2. Kịch bản 1: UseCase lấy dữ liệu thành công
- **Arrange**: Thiết lập `mockPostRepository.getPosts()` trả về `Right(tPostsList)`.
- **Act**: Gọi `useCase(NoParams())`.
- **Assert**:
  - Kết quả trả về đúng danh sách `tPostsList`.
  - Phương thức `getPosts()` của repository được gọi đúng 1 lần duy nhất (`verify(() => mockPostRepository.getPosts()).called(1)`).
  - Không có lời gọi phương thức thừa nào khác (`verifyNoMoreInteractions(mockPostRepository)`).

### 2.3. Kịch bản 2: Xử lý lỗi khi Server gặp sự cố
- **Arrange**: Thiết lập `mockPostRepository.getPosts()` trả về `Left(ServerFailure('Connection failed'))`.
- **Act**: Gọi `useCase(NoParams())`.
- **Assert**:
  - Kết quả trả về đúng `Left(ServerFailure)`.
  - Tầng Domain không throw exception crash app mà đóng gói an toàn qua `Either`.

---

## 3. Câu lệnh chạy test và báo cáo kết quả

```bash
flutter test test/features/post/domain/usecases/get_posts_test.dart
```

Kết quả kỳ vọng: 100% test cases pass trong thời gian < 1 giây.
