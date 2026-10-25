# Hướng Dẫn Ôn Tập & Bộ Câu Hỏi Phản Biện — Tuần 02
## Chủ Đề 02: Lập Trình Bất Đồng Bộ Với Future & Stream Trong Flutter

- **Môn học:** Lập trình Đa nền tảng
- **Giảng viên hướng dẫn:** TS. Nguyễn Duy Nhật Viễn
- **Sinh viên thực hiện:** Huỳnh Thiện Lộc (MSSV: 106230052)

---

## PHẦN I: TỔNG QUAN BẢN CHẤT KỸ THUẬT CỐT LÕI

### 1. Dart Event Loop — Tại sao đơn luồng (Single Thread) lại không bị giật lag?
- **Bản chất:** Dart chạy trên một **Isolate** duy nhất với một luồng thực thi (Thread) và vùng nhớ riêng biệt. Mọi đoạn code Dart bình thường chạy tuần tự trên thread này.
- **Cơ chế điều phối:** Để không bị "chết" giao diện khi chờ mạng hay timer, Dart sử dụng **Event Loop** liên tục quét qua 2 hàng đợi theo thứ tự ưu tiên:
  1. **Microtask Queue (Ưu tiên tuyệt đối):** Chứa các tác vụ nội bộ khẩn cấp của VM (được nạp qua `scheduleMicrotask`). Event loop luôn chạy cạn toàn bộ hàng đợi này trước. Nếu một microtask liên tục sinh microtask mới, app sẽ bị treo (Event Queue starvation).
  2. **Event Queue (Ưu tiên sau):** Chứa các sự kiện bên ngoài: I/O (file, network), Timer, vẽ cử chỉ cảm ứng (User tap, gestures). Mỗi event được lấy ra chạy trọn vẹn từ đầu đến cuối trên Thread.
- **Ý nghĩa:** Khi gặp tác vụ tốn thời gian, Dart không bắt Thread chờ (block) mà đẩy callback vào Event Queue và lập tức nhường Thread để vẽ khung hình tiếp theo (60-120 FPS).

---

### 2. Future & Cú pháp `async`/`await`
- **Future:** Đại diện cho một giá trị **chưa có sẵn** nhưng sẽ có trong tương lai (kết quả thành công hoặc một Exception). Future **chỉ sinh ra 1 giá trị duy nhất** rồi đóng vòng đời.
- **Từ khóa `async`:** Báo cho trình biên dịch biết hàm này là bất đồng bộ và tự động bọc giá trị trả về trong một `Future<T>`.
- **Từ khóa `await` (Non-blocking Suspend):**
  - **Điểm hay:** Làm cho code bất đồng bộ trông giống như đồng bộ (dễ đọc, dễ `try-catch`), loại bỏ triệt để **Callback Hell** (`.then().catchError()`).
  - **Hoạt động thực tế:** Khi gặp `await`, Dart lưu lại ngữ cảnh hàm và **tạm ngưng thực thi hàm đó**, lập tức trả Thread về cho Event Loop xử lý các frame giao diện. Khi Future hoàn thành, kết quả được đẩy vào Event Queue dưới dạng callback để chạy tiếp phần còn lại của hàm.

---

### 3. Stream & Mô hình Reactive Streams
- **Stream:** Là một "đường ống" phát ra **chuỗi nhiều giá trị liên tục** theo thời gian (hoặc báo lỗi, hoặc báo kết thúc).
- **StreamController:** Đóng vai trò là người quản lý ống dẫn gồm 2 đầu:
  - **`sink` (Đầu vào):** Nơi nguồn dữ liệu đẩy dữ liệu vào thông qua `sink.add(value)` hoặc `sink.addError(err)`.
  - **`stream` (Đầu ra):** Nơi các đối tượng bên ngoài đăng ký nhận dữ liệu qua `stream.listen()`.
- **Single-subscription vs Broadcast:**
  - *Single-subscription:* Chỉ cho phép đúng **1 listener duy nhất** trong suốt vòng đời. Nếu listener thứ 2 đăng ký sẽ bắn lỗi ngay `Bad state: Stream has already been listened to`. (Phù hợp: Đọc file, nạp tệp zip).
  - *Broadcast:* Cho phép **nhiều listener cùng nghe đồng thời**, có thể đăng ký và hủy bất kỳ lúc nào. (Phù hợp: Timer, cảm biến sensor, tọa độ GPS, WebSocket, EventBus).

---

### 4. `StreamBuilder` vs `setState()` — Tối ưu hiệu năng 60 FPS
- **Vấn đề của `setState()`:** Mỗi khi Stream có giá trị mới, nếu gọi `setState()` trong `StatefulWidget`, Flutter sẽ đánh dấu toàn bộ State đó là `dirty` và **rebuild lại toàn bộ cây widget con** (Scaffold, AppBar, Padding, Button, Containers) $\rightarrow$ Tiêu tốn CPU, dễ rớt khung hình (Jank).
- **Giải pháp `StreamBuilder`:**
  - Lắng nghe trực tiếp `Stream` và chỉ rebuild duy nhất phần Widget nằm trong hàm `builder`.
  - Quản lý trạng thái kết nối thông qua `AsyncSnapshot`:
    - `ConnectionState.none`: Chưa gắn vào Stream.
    - `ConnectionState.waiting`: Đang chờ phát ra giá trị đầu tiên.
    - `ConnectionState.active`: Đang phát dữ liệu liên tục (`snapshot.hasData`).
    - `ConnectionState.done`: Stream đã kết thúc (`close()`).

---

### 5. Memory Leak & Cơ Chế Dọn Dẹp (Resource Clean-up)
- **Nguyên nhân Memory Leak trong Dart:** Dart sử dụng Garbage Collector (GC) dựa trên **Reachability (Khả năng truy cập từ Root)**.
  - Khi bạn đăng ký `stream.listen((event) { ... })` bên trong một State của Widget: Controller nắm giữ một tham chiếu (reference) mạnh đến hàm callback đó, và callback đó lại trỏ đến chính Widget State (`this`).
  - Khi người dùng bấm nút Back thoát màn hình: Widget bị gỡ khỏi Element Tree, nhưng `StreamController` hoặc `Timer` vẫn đang sống $\rightarrow$ GC không thể thu hồi vùng nhớ của Widget $\rightarrow$ **Rò rỉ RAM (Memory Leak)**.
  - Nếu `Timer` vẫn chạy, nó sẽ tiếp tục gọi `sink.add()` lên một controller đã đóng $\rightarrow$ Gây lỗi nghiêm trọng `Bad state: Cannot add event after closing`.
- **Quy tắc dọn dẹp bắt buộc trong `dispose()`:**
  1. Hủy Timer/Subscription: `_timer?.cancel();`
  2. Đóng cổng nạp: `_controller.close();`
  3. Phòng thủ khi phát dữ liệu: Luôn kiểm tra `if (!_controller.isClosed) _controller.sink.add(data);`

---

## PHẦN II: BỘ CÂU HỎI PHẢN BIỆN DỰ ĐOÁN & CÁCH TRẢ LỜI ĐẠT ĐIỂM TỐI ĐA

### Nhóm 1: Về Nền Tảng Dart Event Loop & Future

#### Q1: "Dart là đơn luồng (Single Thread), vậy khi ta gọi `http.get()` hoặc `Future.delayed(5s)`, luồng đó có bị đứng trong 5 giây đó không? Tại sao?"
> **Trả lời:**
> "Dạ thưa Thầy, **hoàn toàn không bị đứng**.
> Bản chất của `http.get` hay `Future.delayed` là các tác vụ I/O bất đồng bộ được giao cho hệ điều hành (OS) hoặc các luồng C++ bên dưới Engine của Dart xử lý.
> Luồng Dart chính chỉ làm nhiệm vụ đăng ký một bộ đếm thời gian hoặc socket descriptor với OS. Trong suốt 5 giây chờ, Dart Execution Thread hoàn toàn rảnh rỗi và tiếp tục lấy các sự kiện khác trong Event Queue để vẽ UI (60 FPS).
> Khi hết 5 giây hoặc mạng trả dữ liệu về, OS sẽ báo lại và Dart VM đẩy một callback vào cuối Event Queue để gọi tiếp phần mã phía sau."

#### Q2: "Sự khác biệt giữa Microtask Queue và Event Queue là gì? Nếu trong code em liên tục gọi `scheduleMicrotask` thì chuyện gì sẽ xảy ra?"
> **Trả lời:**
> "Dạ thưa Thầy:
> - **Microtask Queue** có độ ưu tiên cao hơn, dùng để xử lý các tác vụ nội bộ khẩn cấp ngắn hạn.
> - **Event Queue** xử lý các sự kiện bên ngoài như tương tác người dùng, I/O mạng, Timer.
> Event Loop có nguyên tắc: **Chỉ khi nào Microtask Queue hoàn toàn rỗng thì nó mới lấy sự kiện tiếp theo từ Event Queue**.
> Do đó, nếu ta liên tục gọi `scheduleMicrotask` đệ quy hoặc lặp vô tận, Event Loop sẽ bị kẹt lại ở Microtask Queue (hiện tượng **Queue Starvation**), khiến Event Queue không bao giờ được phục vụ $\rightarrow$ Mọi cử chỉ chạm (tap), timer và vẽ lại giao diện sẽ bị đóng băng hoàn toàn."

#### Q3: "Từ khóa `await` có phải là một lệnh dừng chương trình không? Cơ chế ngầm bên dưới của nó là gì?"
> **Trả lời:**
> "Dạ thưa Thầy, `await` không phải là lệnh dừng chương trình dạng `sleep()`.
> Khi gặp `await`, Dart VM thực hiện cơ chế **Non-blocking Suspend**:
> 1. Hàm hiện tại được tạm dừng và lưu lại trạng thái stack frame.
> 2. Trả quyền điều khiển ngay lập tức về cho Event Loop.
> 3. Đằng sau hậu trường, trình biên dịch Dart chuyển đổi đoạn mã phía sau `await` thành một callback tương đương với `.then()`. Khi `Future` hoàn tất, callback này mới được đẩy vào Event Queue để chạy tiếp."

---

### Nhóm 2: Về Stream & Kiến Trúc Xử Lý Luồng

#### Q4: "Tại sao trong bài demo em lại chọn khởi tạo `StreamController<int>.broadcast()` thay vì dùng `StreamController<int>()` mặc định?"
> **Trả lời:**
> "Dạ thưa Thầy:
> - `StreamController` mặc định là **Single-subscription Stream**, chỉ cho phép 1 listener duy nhất. Nếu ta có một widget khác (ví dụ: thanh status hiển thị số tick ở app bar) cùng muốn lắng nghe, app sẽ crash với lỗi `Bad state: Stream has already been listened to`.
> - Ứng dụng demo của em là luồng sự kiện thời gian thực (real-time events) có thể được theo dõi bởi nhiều thành phần giao diện khác nhau, nên việc dùng `.broadcast()` là chuẩn kiến trúc của mô hình Publish/Subscribe trong Flutter."

#### Q5: "Nếu em bấm nút Bắt đầu (Start) nhiều lần liên tiếp thì có chuyện gì xảy ra không? Em đã xử lý điều này như thế nào trong mã nguồn?"
> **Trả lời:**
> "Dạ thưa Thầy, nếu không có cơ chế chặn, mỗi lần bấm Start sẽ tạo ra một `Timer.periodic` mới chạy song song, khiến các Timer cùng đè nhau bắn vào `sink`, làm số đếm nhảy loạn xạ và rò rỉ tài nguyên.
> Trong mã nguồn [`stream_service.dart`](file:///home/loccun/Documents/Năm 4 - Kì 1/LT Đa nền tảng/Hell/week_02/app/lib/stream_service.dart), em đã xử lý chặt chẽ bằng State Pattern:
> ```dart
> void start() {
>   if (_state == StreamState.running || _controller.isClosed) return;
>   _state = StreamState.running;
>   ...
> }
> ```
> Đồng thời trên giao diện, nút Bắt đầu được gán `onPressed: _service.state == StreamState.running ? null : () { ... }` để vô hiệu hóa (disable) ngay khi đang chạy."

---

### Nhóm 3: Về StreamBuilder & Tối Ưu Giao Diện (Performance)

#### Q6: "Tại sao không dùng `setState()` cho nhanh mà phải dùng `StreamBuilder`? Sử dụng `StreamBuilder` mang lại lợi ích gì về mặt hiệu năng (FPS)?"
> **Trả lời:**
> "Dạ thưa Thầy:
> - Nếu dùng `setState()`: Mỗi giây hoặc mỗi 0.5s Stream bắn về, `setState()` sẽ ép Flutter đánh dấu toàn bộ `State` của màn hình là dirty $\rightarrow$ Hàm `build()` chạy lại toàn bộ, rebuild cả AppBar, Scaffold, các Container và dãy Button phía dưới.
> - Sử dụng `StreamBuilder`: Flutter chỉ rebuild **duy nhất Widget con nằm trong hàm `builder` của StreamBuilder** (ở đây là widget `Text('$count')`). Toàn bộ cây Widget bên ngoài đứng yên 100%.
> - Điều này đặc biệt quan trọng với các luồng tần số cao (100ms - 500ms như cảm biến hoặc đồ thị chứng khoán), giúp app giữ vững 60 FPS mượt mà và tiết kiệm pin tối đa."

#### Q7: "Trong `StreamBuilder`, nếu Stream chưa kịp phát ra giá trị đầu tiên thì `snapshot.data` sẽ là gì? Em xử lý trường hợp này ra sao?"
> **Trả lời:**
> "Dạ thưa Thầy:
> Khi Stream vừa được gán vào `StreamBuilder` và chưa phát ra sự kiện nào, `snapshot.connectionState` sẽ ở trạng thái `ConnectionState.waiting`, và `snapshot.data` sẽ là `null`.
> Trong bài làm, em xử lý bằng 2 cách:
> 1. Truyền `initialData: _service.currentCount` trực tiếp vào `StreamBuilder` để widget có dữ liệu khởi tạo ngay lập tức mà không bị chớp màn hình.
> 2. Dùng toán tử `snapshot.data ?? 0` để đảm bảo luôn có giá trị an toàn fallback."

---

### Nhóm 4: Về Vòng Đời, Dọn Dẹp Bộ Nhớ & Unit Test

#### Q8: "Điều gì sẽ xảy ra nếu người dùng đang chạy đếm mà thoát khỏi màn hình (Pop Screen) nhưng ta KHÔNG viết hàm `dispose()`?"
> **Trả lời:**
> "Dạ thưa Thầy, sẽ xảy ra 2 lỗi nghiêm trọng:
> 1. **Memory Leak (Rò rỉ bộ nhớ):** `Timer.periodic` vẫn tiếp tục chạy trong nền. Vì callback của Timer tham chiếu đến `StreamCounterService` và Service tham chiếu đến `StreamController`, Garbage Collector (GC) không thể dọn dẹp vùng nhớ này.
> 2. **Lỗi Runtime Exception:** Nếu một listener nào đó bị hủy mà Timer vẫn tiếp tục gọi `sink.add()`, hoặc khi Controller bị đóng mà Timer vẫn cố nạp dữ liệu, Flutter sẽ quăng lỗi ngoại lệ:
>    `Bad state: Cannot add event after closing`.
> Do đó, trong hàm `dispose()` của cả Service và Widget, em luôn gọi `_timer?.cancel()` và `_controller.close()`."

#### Q9: "Trong bài kiểm thử Unit Test (`stream_service_test.dart`), tại sao em lại dùng `emitsInOrder` thay vì dùng hàm `expect()` thông thường?"
> **Trả lời:**
> "Dạ thưa Thầy:
> - `expect()` thông thường chỉ so sánh giá trị tĩnh tại một thời điểm tức thời ($t = 0$).
> - Còn `Stream` là dữ liệu biến thiên theo trục thời gian bất đồng bộ. Matcher `emitsInOrder([1, 2, 3])` kết hợp cùng `expectLater()` cho phép bộ test đăng ký lắng nghe và xác nhận chính xác **chuỗi sự kiện phải phát ra đúng thứ tự tuần tự theo thời gian**.
> - Em dùng `service.stream.take(3)` để lấy đúng 3 giá trị đầu tiên giúp test case hoàn tất nhanh chóng và giải phóng luồng an toàn mà không cần chờ đợi thủ công."
