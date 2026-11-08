---
marp: true
theme: default
paginate: true
size: 16:9
style: |
  section {
    font-family: 'Arial', sans-serif;
    padding: 35px 55px;
    background: #f8fafc;
    color: #1e293b;
  }
  h1 {
    color: #1e3a8a;
    font-size: 2.2rem;
    margin-bottom: 0.3rem;
  }
  h2 {
    color: #1d4ed8;
    font-size: 1.8rem;
    border-bottom: 2px solid #93c5fd;
    padding-bottom: 6px;
    margin-top: 0;
  }
  .lead-title {
    text-align: center;
    padding-top: 70px;
  }
  .sub-title {
    color: #475569;
    font-size: 1.25rem;
    margin-top: 15px;
  }
  .meta-info {
    margin-top: 40px;
    font-size: 1.1rem;
    color: #334155;
  }
  .grid-2 {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 25px;
    margin-top: 20px;
  }
  .grid-3 {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 20px;
    margin-top: 25px;
  }
  .card {
    background: #ffffff;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.08);
    border: 1px solid #e2e8f0;
  }
  .card-blue { border-top: 5px solid #2563eb; }
  .card-orange { border-top: 5px solid #ea580c; }
  .card-green { border-top: 5px solid #16a34a; }
  .card-red { border-top: 5px solid #dc2626; }
  .badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 6px;
    font-weight: bold;
    font-size: 0.85rem;
  }
  .badge-blue { background: #dbeafe; color: #1e40af; }
  .badge-green { background: #dcfce7; color: #166534; }
  .badge-red { background: #fee2e2; color: #991b1b; }
  .badge-yellow { background: #fef9c3; color: #854d0e; }
  .layer-box {
    padding: 12px 18px;
    margin-bottom: 10px;
    border-radius: 8px;
    font-size: 1.05rem;
    font-weight: bold;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
    font-size: 0.95rem;
  }
  th {
    background: #e2e8f0;
    color: #0f172a;
    padding: 10px;
    text-align: left;
  }
  td {
    padding: 10px;
    border-bottom: 1px solid #e2e8f0;
  }
  footer {
    font-size: 0.8rem;
    color: #64748b;
  }
---

<!-- _class: lead-title -->
# Animation & Cử Chỉ Nâng Cao
### TRƯỜNG ĐẠI HỌC BÁCH KHOA — ĐẠI HỌC ĐÀ NẴNG
<div class="sub-title">Chủ đề 08: Báo cáo Tuần 04 — Môn: Lập trình Đa nền tảng</div>

<div class="meta-info">
  <b>SVTH:</b> Huỳnh Thiện Lộc — <b>MSSV:</b> 106230052 <br>
  <b>GVHD:</b> TS. Nguyễn Duy Nhật Viễn
</div>

<!-- note:
Chào Thầy và các bạn. Hôm nay em xin báo cáo Chủ đề 08: Animation và Cử chỉ nâng cao trong Flutter.
-->

---

## Nội dung báo cáo

<div class="grid-2">
  <div>
    <ol>
      <li><b>Animation & UX Roles</b></li>
      <li><b>Requirements (Spec)</b></li>
      <li><b>Flutter Animation Architecture</b></li>
      <li><b>Implicit vs Explicit Matrix</b></li>
      <li><b>Explicit Lifecycle & Memory Safety</b></li>
      <li><b>Gesture Arena & Disambiguation</b></li>
      <li><b>UX Motion Principles & Latency</b></li>
    </ol>
  </div>
  <div>
    <ol start="8">
      <li><b>Application Architecture</b></li>
      <li><b>Implicit Motion: State Interpolation</b></li>
      <li><b>Explicit & Gestures: Spring Physics</b></li>
      <li><b>Automated Verification & Tests</b></li>
      <li><b>Engineering Decision Tree</b></li>
      <li><b>References & Verified Sources</b></li>
    </ol>
  </div>
</div>

<!-- note:
Bài báo cáo gồm 3 phần lớn: Bản chất UX & Kiến trúc Flutter, Đấu trường cử chỉ, và Thực hành ứng dụng demo kèm kiểm thử.
-->

---

## 1. Animation & UX Roles

<div class="grid-3">
  <div class="card card-blue">
    <div class="badge badge-blue">Trụ Cột 1</div>
    <h3 style="color: #2563eb; margin: 10px 0 6px 0;">State Continuity</h3>
    <p style="font-size: 0.95rem; line-height: 1.4;">
      <b>Tính liên tục không gian:</b> Loại bỏ hiện tượng giật cục khi chuyển trang hoặc thay đổi kích thước layout.
    </p>
  </div>

  <div class="card card-orange">
    <div class="badge badge-yellow">Trụ Cột 2</div>
    <h3 style="color: #ea580c; margin: 10px 0 6px 0;">Guided Focus</h3>
    <p style="font-size: 0.95rem; line-height: 1.4;">
      <b>Dẫn dắt sự chú ý:</b> Hướng mắt người dùng nhận biết tức thì điểm xuất hiện của dữ liệu hoặc kết quả vừa xử lý.
    </p>
  </div>

  <div class="card card-green">
    <div class="badge badge-green">Trụ Cột 3</div>
    <h3 style="color: #16a34a; margin: 10px 0 6px 0;">Touch Feedback</h3>
    <p style="font-size: 0.95rem; line-height: 1.4;">
      <b>Phản hồi xúc giác &lt; 100ms:</b> Xác nhận thao tác chạm ngay lập tức, triệt tiêu việc bấm lặp do tưởng ứng dụng bị đơ.
    </p>
  </div>
</div>

<!-- note:
Animation không phải để trang trí. Nó giải quyết 3 bài toán UX lớn: Tính liên tục không gian, Dẫn hướng mắt, và Phản hồi tức thì dưới 100ms.
-->

---

## 2. Requirements (Spec)

<div class="grid-2">
  <div class="card card-blue">
    <h3 style="color: #1d4ed8; margin-top: 0;">1. Theoretical Foundation</h3>
    <ul style="font-size: 0.95rem; line-height: 1.6;">
      <li><b>Implicit Animation:</b> <code>AnimatedContainer</code> & tự động nội suy.</li>
      <li><b>Explicit Animation:</b> <code>AnimationController</code> & quản lý tài nguyên.</li>
      <li><b>Gesture Arena:</b> Xung đột chạm & thời điểm kích hoạt.</li>
      <li><b>Non-blocking UX:</b> Chuyển động không gây cản trở thao tác.</li>
    </ul>
  </div>

  <div class="card card-green">
    <h3 style="color: #16a34a; margin-top: 0;">2. Practice & Demo</h3>
    <ul style="font-size: 0.95rem; line-height: 1.6;">
      <li><b>Implicit Card:</b> Biến đổi kích thước, màu sắc & viền mượt mà.</li>
      <li><b>Draggable Spring Card:</b> Pan 2D kèm quán tính lò xo.</li>
      <li><b>Morphing Button:</b> Xử lý async không khóa UI pipeline.</li>
      <li><b>Automated Tests:</b> 5/5 test pass, 0 memory leak.</li>
    </ul>
  </div>
</div>

<!-- note:
Đề bài yêu cầu nắm vững cả 2 trường phái Implicit & Explicit, phân giải xung đột Gesture, và chứng minh tính không cản trở thao tác.
-->

---

## 3. Flutter Animation Architecture

<div style="margin-top: 15px;">
  <div class="layer-box" style="background: #dbeafe; color: #1e40af; border-left: 6px solid #2563eb;">
    <span>TẦNG WIDGETS (KHỞI TẠO)</span>
    <span style="font-size: 0.9rem; font-weight: normal;"><code>AnimatedContainer</code> (Implicit) | <code>SlideTransition</code> (Explicit)</span>
  </div>

  <div class="layer-box" style="background: #dcfce7; color: #166534; border-left: 6px solid #16a34a;">
    <span>TẦNG ĐIỀU KHIỂN & NỘI SUY</span>
    <span style="font-size: 0.9rem; font-weight: normal;"><code>AnimationController</code> (0.0 → 1.0) | <code>Tween&lt;T&gt;</code> | <code>CurvedAnimation</code></span>
  </div>

  <div class="layer-box" style="background: #fef9c3; color: #854d0e; border-left: 6px solid #ca8a04;">
    <span>TẦNG LÀM TƯƠI ĐỒNG BỘ</span>
    <span style="font-size: 0.9rem; font-weight: normal;"><code>Ticker</code> & <code>TickerProvider</code> (Khóa xung VSync 60Hz / 120Hz)</span>
  </div>

  <div class="layer-box" style="background: #f3e8ff; color: #6b21a8; border-left: 6px solid #9333ea;">
    <span>TẦNG PHẦN CỨNG (GPU RENDER)</span>
    <span style="font-size: 0.9rem; font-weight: normal;">Chỉ cập nhật Transform Layer | <b>Không rebuild Widget con</b></span>
  </div>
</div>

<!-- note:
Kiến trúc phân tầng Flutter: Widget chỉ là bản khai báo. Ticker bắt nhịp VSync từ hệ điều hành, và GPU chỉ việc cập nhật Layer biến hình mà không phải rebuild lại cây widget.
-->

---

## 4. Implicit vs Explicit Matrix

<table>
  <thead>
    <tr>
      <th>Đặc Tính Kỹ Thuật</th>
      <th>Implicit Animation (Khai báo)</th>
      <th>Explicit Animation (Mệnh lệnh)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>Cơ chế điều khiển</b></td>
      <td>Truyền Target Value, tự nội suy</td>
      <td>Dùng <code>AnimationController</code> thủ công</td>
    </tr>
    <tr>
      <td><b>Mức độ linh hoạt</b></td>
      <td>Chạy 1 chiều từ A → B</td>
      <td>Toàn quyền: <code>forward</code>, <code>reverse</code>, <code>repeat</code>, <code>spring</code></td>
    </tr>
    <tr>
      <td><b>Nguy cơ Memory Leak</b></td>
      <td><span class="badge badge-green">ZERO LEAK (An toàn 100%)</span></td>
      <td><span class="badge badge-red">CAO (Bắt buộc phải dispose)</span></td>
    </tr>
    <tr>
      <td><b>Boilerplate Code</b></td>
      <td>Cực ít, không cần Ticker</td>
      <td>Cần <code>SingleTickerProviderStateMixin</code></td>
    </tr>
    <tr>
      <td><b>Ứng dụng thực tế</b></td>
      <td>Đổi màu nút, mở rộng thẻ, fade in/out</td>
      <td>Kéo thả cử chỉ, nảy lò xo, chuyển động lặp</td>
    </tr>
  </tbody>
</table>

<!-- note:
Implicit là lựa chọn mặc định an toàn tuyệt đối. Chỉ chuyển sang Explicit khi cần lặp lại, đảo chiều, hoặc gắn kết theo cử chỉ người dùng.
-->

---

## 5. Explicit Lifecycle & Memory Safety

<div class="grid-2">
  <div class="card card-green">
    <div class="badge badge-green">Pha 1: Khởi Tạo (Mount)</div>
    <h3 style="color: #166534; margin: 10px 0;">initState()</h3>
    <ul style="font-size: 0.95rem; line-height: 1.5;">
      <li><code>SingleTickerProviderStateMixin</code> khởi tạo <code>Ticker</code>.</li>
      <li>Ticker lắng nghe xung VSync màn hình.</li>
      <li><b>Ticker giữ Strong Reference tới State.</b></li>
    </ul>
  </div>

  <div class="card card-red">
    <div class="badge badge-red">Pha 2: Giải Phóng (Unmount)</div>
    <h3 style="color: #991b1b; margin: 10px 0;">dispose()</h3>
    <ul style="font-size: 0.95rem; line-height: 1.5;">
      <li><b>Bước 1:</b> <code>controller.dispose()</code> (Ngắt Ticker).</li>
      <li><b>Bước 2:</b> <code>super.dispose()</code> (Dọn State).</li>
      <li><b>Làm ngược:</b> Crash & Memory Leak vĩnh viễn!</li>
    </ul>
  </div>
</div>

<div style="background: #fee2e2; color: #991b1b; padding: 10px 15px; border-radius: 8px; margin-top: 15px; font-size: 0.95rem;">
  <b>Quy tắc vàng:</b> Luôn giải phóng controller TRƯỚC <code>super.dispose()</code>. Nếu Ticker còn sống, Garbage Collector không thể thu hồi State object.
</div>

<!-- note:
Điểm Giảng viên hay hỏi nhất: Vì sao controller.dispose() phải gọi trước super.dispose()? Vì super.dispose sẽ đóng TickerProvider; nếu Ticker còn sống, Flutter sẽ ném framework assertion error ngay lập tức.
-->

---

## 6. Gesture Arena & Disambiguation

<div style="margin-top: 15px;">
  <div class="card card-blue" style="margin-bottom: 12px; padding: 14px 20px;">
    <b>BƯỚC 1: TIẾP NHẬN CHẠM (PointerDown)</b>
    <span style="float: right; color: #64748b;">Hit-testing</span>
    <p style="margin: 5px 0 0 0; font-size: 0.9rem; color: #475569;">
      Mọi Recognizer thỏa mãn tọa độ chạm (Tap, Drag dọc, Drag ngang) đều bước vào Đấu trường.
    </p>
  </div>

  <div class="card card-orange" style="margin-bottom: 12px; padding: 14px 20px;">
    <b>BƯỚC 2: MÀNG LỌC TOUCH SLOP (&gt; 18dp)</b>
    <span style="float: right; color: #64748b;">Trajectory Filter</span>
    <p style="margin: 5px 0 0 0; font-size: 0.9rem; color: #475569;">
      Ngón tay di chuyển: Recognizer ngược hướng tự rút lui (<b>Self-elimination</b>).
    </p>
  </div>

  <div class="card card-green" style="padding: 14px 20px;">
    <b>BƯỚC 3: CHIẾN THẮNG (Declare Win)</b>
    <span style="float: right; color: #64748b;">Resolution</span>
    <p style="margin: 5px 0 0 0; font-size: 0.9rem; color: #475569;">
      Cử chỉ ưu thế tuyên bố thắng cuộc; toàn bộ đối thủ còn lại lập tức bị loại.
    </p>
  </div>
</div>

<p style="font-size: 0.85rem; color: #64748b; margin-top: 12px; text-align: center;">
  <b>Phân cấp Cha - Con:</b> Widget con được đưa vào Arena trước → Ưu tiên thắng theo <i>First-Come, First-Served</i>.
</p>

<!-- note:
Đấu trường cử chỉ phân định qua 3 bước: PointerDown, Touch Slop 18dp lọc hướng, và Declare Win. Widget con luôn được nạp trước nên có ưu thế hơn widget cha.
-->

---

## 7. UX Motion Principles & Latency

<div class="grid-3" style="margin-top: 15px;">
  <div style="background: #dcfce7; border: 2px solid #16a34a; border-radius: 10px; padding: 15px; text-align: center;">
    <h2 style="color: #166534; margin: 0; font-size: 1.9rem; border: none;">&lt; 100 ms</h2>
    <p style="margin: 6px 0 0 0; font-weight: bold; color: #15803d;">Phản Hồi Xúc Giác</p>
    <p style="font-size: 0.85rem; color: #374151; margin-top: 5px;">Tức thì, loại bỏ cảm giác trễ ngón tay</p>
  </div>

  <div style="background: #dbeafe; border: 2px solid #2563eb; border-radius: 10px; padding: 15px; text-align: center;">
    <h2 style="color: #1e40af; margin: 0; font-size: 1.9rem; border: none;">150 - 350 ms</h2>
    <p style="margin: 6px 0 0 0; font-weight: bold; color: #1d4ed8;">Chuyển Cảnh Tối Ưu</p>
    <p style="font-size: 0.85rem; color: #374151; margin-top: 5px;">Mượt mà, áp dụng đường cong gia tốc</p>
  </div>

  <div style="background: #fee2e2; border: 2px solid #dc2626; border-radius: 10px; padding: 15px; text-align: center;">
    <h2 style="color: #991b1b; margin: 0; font-size: 1.9rem; border: none;">&gt; 500 ms</h2>
    <p style="margin: 6px 0 0 0; font-weight: bold; color: #b91c1c;">Ngưỡng Gây Ức Chế</p>
    <p style="font-size: 0.85rem; color: #374151; margin-top: 5px;">Gây cảm giác lề mề, cản trở thao tác</p>
  </div>
</div>

<div class="grid-2" style="margin-top: 20px; font-size: 0.95rem;">
  <div>
    • <b>Non-Blocking:</b> Không khóa cảm ứng khi animation đang chạy.<br>
    • <b>Interruptible:</b> Cho phép đổi chiều hoặc buông tay giữa chừng.
  </div>
  <div>
    • <b>Guided Focus:</b> Dẫn hướng mắt theo luồng thông tin.<br>
    • <b>Reduced Motion:</b> Hỗ trợ tắt animation cho người say xe thị giác.
  </div>
</div>

<!-- note:
Về mặt tâm lý học thời gian: Phản hồi chạm phải dưới 100ms, chuyển cảnh 150-350ms. Trên 500ms người dùng sẽ bắt đầu thấy khó chịu và bực bội.
-->

---

## 8. Application Architecture

<div class="grid-2" style="align-items: center;">
  <div>
    <h3 style="color: #1d4ed8; margin-top: 0;">Kiến trúc Demo App (week_04/app)</h3>
    <ul style="font-size: 0.95rem; line-height: 1.6;">
      <li><b>MotionTokens (Lưới 8dp):</b>
        <code>space8</code>, <code>space16</code>, <code>space24</code> chuẩn thiết kế.
      </li>
      <li><b>3 Phân hệ chuyển động độc lập:</b>
        <ol>
          <li><code>ImplicitMotionCard</code>: Tự nội suy Declarative.</li>
          <li><code>DragSpringCard</code>: Gesture Arena + Lò xo.</li>
          <li><code>MorphingActionButton</code>: Async không chặn UI.</li>
        </ol>
      </li>
      <li><b>Đồng bộ VSync:</b> Tự động phát nhịp 60Hz / 120Hz.</li>
    </ul>
  </div>
  <div style="text-align: center;">
    <img src="app_overview.png" style="height: 380px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.15);" />
  </div>
</div>

<!-- note:
Ứng dụng demo được thiết kế theo chuẩn Clean Architecture, tách biệt rõ 3 phân hệ chuyển động tương ứng với 3 yêu cầu của đề bài.
-->

---

## 9. Implicit Motion: State Interpolation

<div class="grid-2" style="text-align: center; margin-top: 10px;">
  <div>
    <span class="badge badge-blue">1. Trạng Thái Ban Đầu (At Rest)</span>
    <div style="margin-top: 10px;">
      <img src="comp_implicit_rest.png" style="width: 90%; border-radius: 8px; border: 1px solid #cbd5e1;" />
    </div>
  </div>
  <div>
    <span class="badge badge-green">2. Trạng Thái Mở Rộng (Interpolated)</span>
    <div style="margin-top: 10px;">
      <img src="comp_implicit_expanded.png" style="width: 90%; border-radius: 8px; border: 1px solid #cbd5e1;" />
    </div>
  </div>
</div>

<p style="text-align: center; font-size: 0.95rem; margin-top: 15px; color: #334155;">
  <b>AnimatedContainer:</b> Tự động tính toán biến thiên kích thước, màu nền và độ bo góc khi Target Value đổi mà không cần bất kỳ <code>AnimationController</code> nào.
</p>

<!-- note:
Khi bấm nút, AnimatedContainer tự so sánh kích thước cũ và mới rồi nội suy mượt mà qua từng frame. Hoàn toàn không phát sinh rò rỉ bộ nhớ.
-->

---

## 10. Explicit & Gestures: Spring Physics

<div class="grid-2" style="text-align: center; margin-top: 10px;">
  <div>
    <span class="badge badge-blue">1. Trạng Thái Ở Gốc (Offset 0, 0)</span>
    <div style="margin-top: 10px;">
      <img src="comp_drag_rest.png" style="width: 90%; border-radius: 8px; border: 1px solid #cbd5e1;" />
    </div>
  </div>
  <div>
    <span class="badge badge-orange">2. Đang Kéo & Xoay Góc Quán Tính</span>
    <div style="margin-top: 10px;">
      <img src="comp_drag_active.png" style="width: 90%; border-radius: 8px; border: 1px solid #cbd5e1;" />
    </div>
  </div>
</div>

<p style="text-align: center; font-size: 0.95rem; margin-top: 15px; color: #334155;">
  <b>GestureDetector + SpringSimulation:</b> Bắt tọa độ 2D pan để xoay góc thẻ; khi buông tay, mô phỏng vật lý lò xo kéo thẻ nảy về gốc <code>(0.0, 0.0)</code> theo đúng vận tốc vung tay.
</p>

<!-- note:
Sử dụng GestureDetector kết hợp SpringSimulation. Góc nghiêng tự tính theo độ dời pan. Buông tay ra là thẻ tự nảy đàn hồi về gốc theo đúng vận tốc tay người dùng.
-->

---

## 11. Automated Verification & Tests

<div class="card card-green" style="margin-top: 15px;">
  <h3 style="color: #166534; margin-top: 0;">5/5 Kịch Bản Kiểm Thử Tự Động Passed 100% (~2.5s)</h3>
  <ol style="font-size: 0.95rem; line-height: 1.7; margin-bottom: 0;">
    <li><b>Launch M3:</b> Khởi chạy thành công giao diện và render đầy đủ 3 phân hệ.</li>
    <li><b>Implicit Interpolation:</b> Kích hoạt mở rộng thẻ, kiểm tra biến thiên frame.</li>
    <li><b>Gesture Drag & Recoil:</b> Vuốt dời 80px, kiểm tra trạng thái Dragging và nảy về gốc (0,0).</li>
    <li><b>Non-Blocking Async:</b> Nút Morphing Button chạy tác vụ ngầm mà không khóa UI.</li>
    <li><b>Memory Leak Teardown:</b> Unmount widget, xác nhận thu hồi 100% Ticker.</li>
  </ol>
</div>

<div style="text-align: right; margin-top: 15px; font-size: 0.9rem; color: #16a34a; font-weight: bold;">
  ✓ flutter test: All tests passed! | ✓ dart analyze: No issues found!
</div>

<!-- note:
Toàn bộ mã nguồn đã được kiểm thử tự động 5/5 kịch bản, xác thực không còn Ticker nào bị bỏ quên khi màn hình bị unmount.
-->

---

## 12. Engineering Decision Tree

<div class="grid-2" style="margin-top: 30px;">
  <div class="card card-green" style="text-align: center; padding: 30px 20px;">
    <div class="badge badge-green" style="font-size: 1rem;">LỰA CHỌN MẶC ĐỊNH</div>
    <h3 style="color: #166534; margin: 15px 0 10px 0;">Implicit Animation</h3>
    <p style="font-size: 0.95rem; color: #374151;">
      • Chỉ cần đổi giao diện khi state thay đổi.<br>
      • Chuyển động 1 chiều từ A → B.<br>
      • <b>Zero Memory Leak, viết code nhanh nhất.</b>
    </p>
  </div>

  <div class="card card-red" style="text-align: center; padding: 30px 20px;">
    <div class="badge badge-red" style="font-size: 1rem;">KHI CÓ NHU CẦU NÂNG CAO</div>
    <h3 style="color: #991b1b; margin: 15px 0 10px 0;">Explicit Animation</h3>
    <p style="font-size: 0.95rem; color: #374151;">
      • Cần lặp lại vô hạn hoặc đảo chiều giữa chừng.<br>
      • Gắn kết trực tiếp với tọa độ kéo thả cử chỉ.<br>
      • <b>Bắt buộc phải quản lý dispose() nghiêm ngặt.</b>
    </p>
  </div>
</div>

<!-- note:
Cây quyết định: Hãy luôn chọn Implicit làm mặc định để an toàn và tiết kiệm chi phí bảo trì. Chỉ dùng Explicit khi thực sự cần kiểm soát hướng chuyển động và cử chỉ phức tạp.
-->

---

## 13. References & Verified Sources

<div class="grid-2" style="margin-top: 15px; font-size: 0.9rem;">
  <div>
    <h4 style="color: #1d4ed8; margin-bottom: 8px;">Official Flutter Documentation</h4>
    • Flutter Animations Overview:<br>
      <a href="https://docs.flutter.dev/ui/animations/overview">docs.flutter.dev/ui/animations/overview</a><br>
    • Implicit Animations Guide:<br>
      <a href="https://docs.flutter.dev/ui/animations/implicit-animations">docs.flutter.dev/ui/animations/implicit-animations</a><br>
    • Gestures & Disambiguation Arena:<br>
      <a href="https://docs.flutter.dev/ui/interactivity/gestures">docs.flutter.dev/ui/interactivity/gestures</a>
  </div>
  <div>
    <h4 style="color: #1d4ed8; margin-bottom: 8px;">API Reference & Design System</h4>
    • <code>AnimationController</code> Class:<br>
      <a href="https://api.flutter.dev/flutter/animation/AnimationController-class.html">api.flutter.dev/AnimationController</a><br>
    • <code>GestureArenaManager</code> Class:<br>
      <a href="https://api.flutter.dev/flutter/gestures/GestureArenaManager-class.html">api.flutter.dev/GestureArenaManager</a><br>
    • Material Design 3 Motion Principles:<br>
      <a href="https://m3.material.io/styles/motion/overview/how-it-works">m3.material.io/styles/motion</a>
  </div>
</div>

<p style="text-align: center; color: #64748b; font-size: 0.85rem; margin-top: 25px;">
  <i>Tất cả các liên kết tham khảo đã được kiểm tra kết nối trực tiếp (HTTP 200 OK).</i>
</p>

<!-- note:
Toàn bộ tài liệu tham khảo chính thức đều được kiểm tra mở và hoạt động bình thường. Em xin cảm ơn Thầy và các bạn đã theo dõi bài báo cáo.
-->
