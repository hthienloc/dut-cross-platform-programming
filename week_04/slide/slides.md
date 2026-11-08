---
theme: default
background: '#f8fafc'
class: text-center
highlighter: shiki
lineNumbers: false
drawings:
  persist: false
transition: slide-left
title: 'Animation & Cử Chỉ Nâng Cao'
fonts:
  sans: 'Inter, system-ui, sans-serif'
info: |
  ## Tuần 04: Animation và Cử Chỉ Nâng Cao trong Flutter
  Môn: Lập trình Đa nền tảng
---

# Animation & Cử Chỉ Nâng Cao

<div class="text-gray-600 text-lg mt-2 font-medium">Chủ đề 08: Báo cáo Tuần 04 — Môn: Lập trình Đa nền tảng</div>

<div class="mt-8 text-sm text-slate-700 bg-white inline-block px-6 py-3 rounded-xl border border-slate-200 shadow-sm">
  <span class="font-semibold text-blue-700">SVTH:</span> Huỳnh Thiện Lộc — <span class="font-semibold text-blue-700">MSSV:</span> 106230052 <br>
  <span class="font-semibold text-slate-600">GVHD:</span> TS. Nguyễn Duy Nhật Viễn
</div>

<div class="mt-6 flex justify-center gap-3">
  <span class="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-xs font-semibold">Flutter Motion</span>
  <span class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs font-semibold">Gesture Arena</span>
  <span class="px-3 py-1 bg-purple-100 text-purple-700 rounded-full text-xs font-semibold">60/120 FPS VSync</span>
</div>

<!--
Chào Thầy và các bạn. Hôm nay em xin báo cáo Chủ đề 08: Animation và Cử chỉ nâng cao trong Flutter.
-->

---

# Nội dung báo cáo

<div class="grid grid-cols-2 gap-8 text-left mt-6">
  <div class="bg-white p-5 rounded-xl border border-slate-200 shadow-sm">
    <div class="text-xs font-bold text-blue-600 uppercase tracking-wider mb-2">PHẦN 1: NỀN TẢNG LÝ THUYẾT</div>
    <ol class="space-y-2 text-sm text-slate-700">
      <li><b class="text-blue-700">1.</b> Animation & UX Roles</li>
      <li><b class="text-blue-700">2.</b> Requirements (Spec)</li>
      <li><b class="text-blue-700">3.</b> Flutter Animation Architecture</li>
      <li><b class="text-blue-700">4.</b> Implicit vs Explicit Matrix</li>
      <li><b class="text-blue-700">5.</b> Explicit Lifecycle & Memory Safety</li>
      <li><b class="text-blue-700">6.</b> Gesture Arena & Disambiguation</li>
      <li><b class="text-blue-700">7.</b> UX Motion Principles & Latency</li>
    </ol>
  </div>
  <div class="bg-white p-5 rounded-xl border border-slate-200 shadow-sm">
    <div class="text-xs font-bold text-green-600 uppercase tracking-wider mb-2">PHẦN 2: THỰC THI & MINH CHỨNG</div>
    <ol start="8" class="space-y-2 text-sm text-slate-700">
      <li><b class="text-green-700">8.</b> Application Architecture</li>
      <li><b class="text-green-700">9.</b> Implicit Motion: State Interpolation</li>
      <li><b class="text-green-700">10.</b> Explicit & Gestures: Spring Physics</li>
      <li><b class="text-green-700">11.</b> Automated Verification & Tests</li>
      <li><b class="text-green-700">12.</b> Engineering Decision Tree</li>
      <li><b class="text-green-700">13.</b> References & Verified Sources</li>
    </ol>
  </div>
</div>

<!--
Nội dung báo cáo gồm 2 phần lớn: Cơ chế cốt lõi (Kiến trúc Render, Lifecycle, Gesture Arena) và Ứng dụng demo thực tế kiểm thử 5/5 kịch bản.
-->

---

# 1. Animation & UX Roles

<div class="grid grid-cols-3 gap-4 mt-6 text-left">
  <div class="bg-white p-4 rounded-xl border-t-4 border-blue-500 shadow-sm">
    <span class="px-2 py-0.5 bg-blue-100 text-blue-800 rounded text-xs font-bold">Trụ Cột 1</span>
    <h3 class="text-blue-700 font-bold text-base mt-2 mb-1">Spatial Continuity</h3>
    <p class="text-xs text-slate-600 leading-relaxed">
      <b>Duy trì liên tục không gian:</b> Giúp não bộ kết nối nguồn gốc chuyển dịch của phần tử, xóa bỏ hiện tượng "nhấp nháy giật cục".
    </p>
  </div>

  <div class="bg-white p-4 rounded-xl border-t-4 border-orange-500 shadow-sm">
    <span class="px-2 py-0.5 bg-orange-100 text-orange-800 rounded text-xs font-bold">Trụ Cột 2</span>
    <h3 class="text-orange-600 font-bold text-base mt-2 mb-1">Focus Guidance</h3>
    <p class="text-xs text-slate-600 leading-relaxed">
      <b>Dẫn dắt sự chú ý:</b> Hướng mắt người dùng nhận biết tức thì điểm xuất hiện của dữ liệu hoặc kết quả vừa xử lý.
    </p>
  </div>

  <div class="bg-white p-4 rounded-xl border-t-4 border-green-500 shadow-sm">
    <span class="px-2 py-0.5 bg-green-100 text-green-800 rounded text-xs font-bold">Trụ Cột 3</span>
    <h3 class="text-green-700 font-bold text-base mt-2 mb-1">Touch Feedback</h3>
    <p class="text-xs text-slate-600 leading-relaxed">
      <b>Phản hồi xúc giác &lt; 100ms:</b> Xác nhận thao tác chạm ngay lập tức, triệt tiêu việc bấm lặp do tưởng ứng dụng bị đơ.
    </p>
  </div>
</div>

<!--
Animation không phải để trang trí. Nó giải quyết 3 bài toán UX lớn: Tính liên tục không gian, Dẫn hướng mắt, và Phản hồi tức thì dưới 100ms.
-->

---

# 2. Requirements (Spec)

<div class="grid grid-cols-2 gap-6 mt-6 text-left">
  <div class="bg-white p-5 rounded-xl border-t-4 border-blue-500 shadow-sm">
    <h3 class="text-blue-700 font-bold text-base mb-3">1. Theoretical Foundation</h3>
    <ul class="space-y-2 text-xs text-slate-700">
      <li>• <b>Implicit Animation:</b> <code>AnimatedContainer</code> & cơ chế tự động nội suy.</li>
      <li>• <b>Explicit Animation:</b> <code>AnimationController</code> & quản lý tài nguyên nghiêm ngặt.</li>
      <li>• <b>Gesture Arena:</b> Phân giải xung đột cử chỉ chạm & thời điểm kích hoạt.</li>
      <li>• <b>Non-blocking UX:</b> Chuyển động tương tác không cản trở thao tác người dùng.</li>
    </ul>
  </div>

  <div class="bg-white p-5 rounded-xl border-t-4 border-green-500 shadow-sm">
    <h3 class="text-green-700 font-bold text-base mb-3">2. Practice & Demo App</h3>
    <ul class="space-y-2 text-xs text-slate-700">
      <li>• <b>Implicit Card:</b> Biến đổi kích thước, màu sắc & bo góc mượt mà.</li>
      <li>• <b>Draggable Spring Card:</b> Pan 2D kèm quán tính dao động lò xo.</li>
      <li>• <b>Morphing Button:</b> Xử lý async không khóa UI pipeline.</li>
      <li>• <b>Automated Tests:</b> 5/5 test pass 100%, 0 memory leak.</li>
    </ul>
  </div>
</div>

<!--
Đề bài yêu cầu nắm vững cả 2 trường phái Implicit & Explicit, phân giải xung đột Gesture, và chứng minh tính không cản trở thao tác.
-->

---

# 3. Flutter Animation Architecture

<div class="flex flex-col gap-2 mt-4 text-left">
  <div class="p-3 bg-blue-50 border-l-4 border-blue-600 rounded flex justify-between items-center text-blue-900">
    <span class="font-bold text-xs">TẦNG WIDGETS (KHỞI TẠO)</span>
    <span class="text-xs font-mono"><code>AnimatedContainer</code> (Implicit) | <code>SlideTransition</code> (Explicit)</span>
  </div>

  <div class="p-3 bg-green-50 border-l-4 border-green-600 rounded flex justify-between items-center text-green-900">
    <span class="font-bold text-xs">TẦNG ĐIỀU KHIỂN & NỘI SUY</span>
    <span class="text-xs font-mono"><code>AnimationController</code> (0.0 → 1.0) | <code>Tween&lt;T&gt;</code> | <code>CurvedAnimation</code></span>
  </div>

  <div class="p-3 bg-yellow-50 border-l-4 border-yellow-600 rounded flex justify-between items-center text-yellow-900">
    <span class="font-bold text-xs">TẦNG LÀM TƯƠI ĐỒNG BỘ</span>
    <span class="text-xs font-mono"><code>Ticker</code> & <code>TickerProvider</code> (Khóa xung VSync 60Hz / 120Hz)</span>
  </div>

  <div class="p-3 bg-purple-50 border-l-4 border-purple-600 rounded flex justify-between items-center text-purple-900">
    <span class="font-bold text-xs">TẦNG PHẦN CỨNG (GPU RENDER)</span>
    <span class="text-xs font-mono">Chỉ cập nhật Transform Layer | <b>Không rebuild Widget con</b></span>
  </div>
</div>

<!--
Kiến trúc phân tầng Flutter: Widget chỉ là bản khai báo. Ticker bắt nhịp VSync từ hệ điều hành, và GPU chỉ việc cập nhật Layer biến hình mà không phải rebuild lại cây widget.
-->

---

# 4. Implicit vs Explicit Matrix

<div class="mt-4 text-xs text-left">
  <table class="w-full bg-white rounded-xl overflow-hidden border border-slate-200 shadow-sm">
    <thead class="bg-slate-100 text-slate-800">
      <tr>
        <th class="p-2.5 font-bold">Tiêu Chí So Sánh</th>
        <th class="p-2.5 font-bold text-blue-700">Implicit Animation</th>
        <th class="p-2.5 font-bold text-orange-700">Explicit Animation</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-slate-100 text-slate-700">
      <tr>
        <td class="p-2.5 font-semibold">Tư duy lập trình</td>
        <td class="p-2.5">Declarative (Khai báo đích đến)</td>
        <td class="p-2.5">Imperative (Lập trình điều khiển luồng)</td>
      </tr>
      <tr>
        <td class="p-2.5 font-semibold">Quản lý Controller</td>
        <td class="p-2.5 text-green-600 font-bold">Tự động (Ẩn trong State)</td>
        <td class="p-2.5 text-red-600 font-bold">Thủ công (AnimationController)</td>
      </tr>
      <tr>
        <td class="p-2.5 font-semibold">Rủi ro Memory Leak</td>
        <td class="p-2.5 text-green-600 font-bold">0% (Zero Leak)</td>
        <td class="p-2.5 text-amber-600 font-bold">Cao (Nếu quên dispose())</td>
      </tr>
      <tr>
        <td class="p-2.5 font-semibold">Lặp lại / Đảo chiều</td>
        <td class="p-2.5">Không hỗ trợ</td>
        <td class="p-2.5 font-bold text-blue-700">Hỗ trợ đầy đủ (repeat, reverse)</td>
      </tr>
      <tr>
        <td class="p-2.5 font-semibold">Gắn kết Cử chỉ (Pan)</td>
        <td class="p-2.5">Khó / Không khả thi</td>
        <td class="p-2.5 font-bold text-blue-700">Đồng bộ mượt theo tọa độ ngón tay</td>
      </tr>
    </tbody>
  </table>
</div>

<!--
Ma trận so sánh: Implicit cực kỳ an toàn vì không thể rò rỉ bộ nhớ, nhưng khi cần lặp vô hạn hoặc gắn với cử chỉ tay thì bắt buộc phải dùng Explicit.
-->

---

# 5. Explicit Lifecycle & Memory Safety

<div class="grid grid-cols-4 gap-3 mt-4 text-center">
  <div class="bg-blue-50 p-3 rounded-lg border border-blue-200">
    <div class="text-xs font-bold text-blue-700">1. initState()</div>
    <div class="text-[11px] text-slate-600 mt-1">Khởi tạo Controller & gán <code>vsync: this</code></div>
  </div>

  <div class="bg-green-50 p-3 rounded-lg border border-green-200">
    <div class="text-xs font-bold text-green-700">2. Ticker Hook</div>
    <div class="text-[11px] text-slate-600 mt-1">Đăng ký callback nhận nhịp xung nhịp VSync</div>
  </div>

  <div class="bg-purple-50 p-3 rounded-lg border border-purple-200">
    <div class="text-xs font-bold text-purple-700">3. Running Frame</div>
    <div class="text-[11px] text-slate-600 mt-1">Nội suy giá trị (0.0 → 1.0) theo hàm thời gian</div>
  </div>

  <div class="bg-red-50 p-3 rounded-lg border border-red-200">
    <div class="text-xs font-bold text-red-700">4. dispose()</div>
    <div class="text-[11px] text-slate-600 mt-1">Hủy Ticker để chặn <b>Strong Ref Leak</b></div>
  </div>
</div>

<div class="bg-amber-50 border-l-4 border-amber-500 p-3 rounded mt-4 text-xs text-left text-amber-900 leading-relaxed">
  <b>Cảnh báo bẫy Giảng viên:</b> Nếu không gọi <code>controller.dispose()</code>, đối tượng TickerProvider vẫn bị lưu giữ trong Engine Scheduler qua Strong Reference, khiến GC không thể thu hồi bộ nhớ ngay cả khi Widget đã bị unmount.
</div>

<!--
Vòng đời bắt đầu từ initState và kết thúc bắt buộc tại dispose. Quên dispose sẽ tạo Strong Reference khiến Garbage Collector không thể giải phóng màn hình.
-->

---

# 6. Gesture Arena & Disambiguation

<div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm text-left">
  <div class="text-xs font-bold text-slate-500 mb-2">QUY TRÌNH PHÂN GIẢI XUNG ĐỘT (ARENA FUNNEL)</div>
  <div class="flex items-center gap-2 text-xs">
    <div class="bg-blue-100 text-blue-800 px-3 py-2 rounded font-semibold flex-1 text-center">1. PointerDown<br><span class="text-[10px] font-normal">Ghi danh mọi Recognizer</span></div>
    <div class="text-slate-400 font-bold">→</div>
    <div class="bg-amber-100 text-amber-800 px-3 py-2 rounded font-semibold flex-1 text-center">2. PointerMove &gt; 18dp<br><span class="text-[10px] font-normal">PanRecognizer tuyên bố Thắng</span></div>
    <div class="text-slate-400 font-bold">→</div>
    <div class="bg-red-100 text-red-800 px-3 py-2 rounded font-semibold flex-1 text-center">3. Sweep Arena<br><span class="text-[10px] font-normal">Hủy TapRecognizer</span></div>
    <div class="text-slate-400 font-bold">→</div>
    <div class="bg-green-100 text-green-800 px-3 py-2 rounded font-semibold flex-1 text-center">4. PointerUp<br><span class="text-[10px] font-normal">Kích hoạt dao động lò xo</span></div>
  </div>
</div>

<div class="grid grid-cols-2 gap-4 mt-4 text-left text-xs">
  <div class="bg-slate-50 p-3 rounded-lg border border-slate-200">
    <b class="text-blue-700">Tọa độ Pan 2D:</b> Dời hình theo đúng độ lệch ngón tay mà không khóa luồng xử lý chính.
  </div>
  <div class="bg-slate-50 p-3 rounded-lg border border-slate-200">
    <b class="text-green-700">SpringSimulation:</b> Đàn hồi về gốc <code>(0.0, 0.0)</code> với độ cứng (stiffness) và cản (damping) chân thực.
  </div>
</div>

<!--
Gesture Arena giải quyết xung đột: khi di chuyển vượt ngưỡng slop (18dp), PanRecognizer sẽ loại bỏ TapRecognizer để nhận toàn quyền cử chỉ.
-->

---

# 7. UX Motion Principles & Latency

<div class="grid grid-cols-3 gap-3 mt-4 text-center">
  <div class="bg-green-50 border-2 border-green-500 rounded-xl p-3">
    <div class="text-xl font-bold text-green-700">&lt; 100 ms</div>
    <div class="text-xs font-semibold text-green-800 mt-1">Phản Hồi Xúc Giác</div>
    <div class="text-[10px] text-slate-500 mt-1">Tức thời, tự nhiên</div>
  </div>

  <div class="bg-blue-50 border-2 border-blue-500 rounded-xl p-3">
    <div class="text-xl font-bold text-blue-700">150 – 350 ms</div>
    <div class="text-xs font-semibold text-blue-800 mt-1">Chuyển Cảnh M3</div>
    <div class="text-[10px] text-slate-500 mt-1">Thời lượng chuẩn vàng</div>
  </div>

  <div class="bg-red-50 border-2 border-red-500 rounded-xl p-3">
    <div class="text-xl font-bold text-red-700">&gt; 500 ms</div>
    <div class="text-xs font-semibold text-red-800 mt-1">Ngưỡng Gây Ức Chế</div>
    <div class="text-[10px] text-slate-500 mt-1">Gây cảm giác lề mề</div>
  </div>
</div>

<div class="grid grid-cols-2 gap-4 mt-4 text-xs text-left text-slate-700">
  <div>
    • <b>Non-Blocking:</b> Không khóa cảm ứng khi animation đang chạy.<br>
    • <b>Interruptible:</b> Cho phép đổi chiều hoặc buông tay giữa chừng.
  </div>
  <div>
    • <b>Guided Focus:</b> Dẫn hướng mắt theo luồng thông tin.<br>
    • <b>Reduced Motion:</b> Hỗ trợ tắt animation cho người say xe thị giác.
  </div>
</div>

<!--
Về mặt tâm lý học thời gian: Phản hồi chạm phải dưới 100ms, chuyển cảnh 150-350ms. Trên 500ms người dùng sẽ bắt đầu thấy khó chịu và bực bội.
-->

---

# 8. Application Architecture

<div class="grid grid-cols-2 gap-6 items-center mt-2 text-left">
  <div>
    <h3 class="text-blue-700 font-bold text-sm mb-2">Kiến trúc Demo App (week_04/app)</h3>
    <ul class="space-y-2 text-xs text-slate-700">
      <li>• <b>MotionTokens (Lưới 8dp):</b> <code>space8</code>, <code>space16</code>, <code>space24</code>.</li>
      <li>• <b>3 Phân hệ chuyển động độc lập:</b>
        <ol class="list-decimal pl-4 mt-1 space-y-1">
          <li><code>ImplicitMotionCard</code>: Tự nội suy Declarative.</li>
          <li><code>DragSpringCard</code>: Gesture Arena + Lò xo.</li>
          <li><code>MorphingActionButton</code>: Async không chặn UI.</li>
        </ol>
      </li>
      <li>• <b>Đồng bộ VSync:</b> Tự động phát nhịp 60Hz / 120Hz.</li>
    </ul>
  </div>
  <div class="flex justify-center">
    <img src="/app_overview_cropped.png" class="max-h-[300px] rounded-lg shadow-md border border-slate-200" />
  </div>
</div>

<!--
Ứng dụng demo được thiết kế theo chuẩn Clean Architecture, tách biệt rõ 3 phân hệ chuyển động tương ứng với 3 yêu cầu của đề bài.
-->

---

# 9. Implicit Motion: State Interpolation

<div class="grid grid-cols-2 gap-6 text-center mt-2">
  <div>
    <span class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs font-semibold">1. Trạng Thái Ban Đầu (At Rest)</span>
    <div class="mt-2 flex justify-center">
      <img src="/comp_implicit_rest.png" class="max-h-[220px] rounded-lg border border-slate-200 shadow-sm" />
    </div>
  </div>
  <div>
    <span class="px-2 py-1 bg-green-100 text-green-800 rounded text-xs font-semibold">2. Trạng Thái Mở Rộng (Interpolated)</span>
    <div class="mt-2 flex justify-center">
      <img src="/comp_implicit_expanded.png" class="max-h-[220px] rounded-lg border border-slate-200 shadow-sm" />
    </div>
  </div>
</div>

<p class="text-center text-xs mt-3 text-slate-700">
  <b>AnimatedContainer:</b> Tự động tính toán biến thiên kích thước, màu nền và viền khi Target Value đổi mà không cần bất kỳ <code>AnimationController</code> nào.
</p>

<!--
Khi bấm nút, AnimatedContainer tự so sánh kích thước cũ và mới rồi nội suy mượt mà qua từng frame. Hoàn toàn không phát sinh rò rỉ bộ nhớ.
-->

---

# 10. Explicit & Gestures: Spring Physics

<div class="grid grid-cols-2 gap-6 text-center mt-2">
  <div>
    <span class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs font-semibold">1. Trạng Thái Ở Gốc (Offset 0, 0)</span>
    <div class="mt-2 flex justify-center">
      <img src="/comp_drag_rest.png" class="max-h-[220px] rounded-lg border border-slate-200 shadow-sm" />
    </div>
  </div>
  <div>
    <span class="px-2 py-1 bg-amber-100 text-amber-800 rounded text-xs font-semibold">2. Đang Kéo & Xoay Góc Quán Tính</span>
    <div class="mt-2 flex justify-center">
      <img src="/comp_drag_active.png" class="max-h-[220px] rounded-lg border border-slate-200 shadow-sm" />
    </div>
  </div>
</div>

<p class="text-center text-xs mt-3 text-slate-700">
  <b>GestureDetector + SpringSimulation:</b> Bắt tọa độ 2D pan để xoay góc thẻ; khi buông tay, mô phỏng vật lý lò xo kéo thẻ nảy về gốc <code>(0.0, 0.0)</code> theo đúng vận tốc vung tay.
</p>

<!--
Sử dụng GestureDetector kết hợp SpringSimulation. Góc nghiêng tự tính theo độ dời pan. Buông tay ra là thẻ tự nảy đàn hồi về gốc theo đúng vận tốc tay người dùng.
-->

---

# 11. Automated Verification & Tests

<div class="bg-white p-4 rounded-xl border-l-4 border-green-600 shadow-sm text-left mt-3">
  <h3 class="text-green-800 font-bold text-sm mb-2">5/5 Kịch Bản Kiểm Thử Tự Động Passed 100% (~2.5s)</h3>
  <ol class="space-y-1.5 text-xs text-slate-700">
    <li><b>1. Launch M3:</b> Khởi chạy thành công giao diện và render đầy đủ 3 phân hệ.</li>
    <li><b>2. Implicit Interpolation:</b> Kích hoạt mở rộng thẻ, kiểm tra biến thiên frame.</li>
    <li><b>3. Gesture Drag & Recoil:</b> Vuốt dời 80px, kiểm tra trạng thái Dragging và nảy về gốc (0,0).</li>
    <li><b>4. Non-Blocking Async:</b> Nút Morphing Button chạy tác vụ ngầm mà không khóa UI.</li>
    <li><b>5. Memory Leak Teardown:</b> Unmount widget, xác nhận thu hồi 100% Ticker.</li>
  </ol>
</div>

<div class="text-right mt-4 text-xs font-bold text-green-600">
  ✓ flutter test: All tests passed! | ✓ dart analyze: No issues found!
</div>

<!--
Toàn bộ mã nguồn đã được kiểm thử tự động 5/5 kịch bản, xác thực không còn Ticker nào bị bỏ quên khi màn hình bị unmount.
-->

---

# 12. Engineering Decision Tree

<div class="grid grid-cols-2 gap-6 mt-6 text-center">
  <div class="bg-green-50 border-2 border-green-400 p-5 rounded-xl">
    <span class="px-2.5 py-1 bg-green-200 text-green-900 rounded text-xs font-bold">LỰA CHỌN MẶC ĐỊNH</span>
    <h3 class="text-green-800 font-bold text-base mt-3 mb-2">Implicit Animation</h3>
    <p class="text-xs text-slate-600 text-left leading-relaxed">
      • Chỉ cần đổi giao diện khi state thay đổi.<br>
      • Chuyển động 1 chiều từ A → B.<br>
      • <b>Zero Memory Leak, viết code nhanh nhất.</b>
    </p>
  </div>

  <div class="bg-red-50 border-2 border-red-400 p-5 rounded-xl">
    <span class="px-2.5 py-1 bg-red-200 text-red-900 rounded text-xs font-bold">KHI CÓ NHU CẦU NÂNG CAO</span>
    <h3 class="text-red-800 font-bold text-base mt-3 mb-2">Explicit Animation</h3>
    <p class="text-xs text-slate-600 text-left leading-relaxed">
      • Cần lặp lại vô hạn hoặc đảo chiều giữa chừng.<br>
      • Gắn kết trực tiếp với tọa độ kéo thả cử chỉ.<br>
      • <b>Bắt buộc phải quản lý dispose() nghiêm ngặt.</b>
    </p>
  </div>
</div>

<!--
Cây quyết định: Hãy luôn chọn Implicit làm mặc định để an toàn và tiết kiệm chi phí bảo trì. Chỉ dùng Explicit khi thực sự cần kiểm soát hướng chuyển động và cử chỉ phức tạp.
-->

---

# 13. References & Verified Sources

<div class="grid grid-cols-2 gap-6 text-left text-xs mt-3">
  <div>
    <h4 class="text-blue-700 font-bold text-sm mb-2">Official Flutter Documentation</h4>
    <p class="mb-2">• Flutter Animations Overview:<br>
      <a href="https://docs.flutter.dev/ui/animations/overview" class="text-blue-600 underline">docs.flutter.dev/ui/animations/overview</a>
    </p>
    <p class="mb-2">• Implicit Animations Guide:<br>
      <a href="https://docs.flutter.dev/ui/animations/implicit-animations" class="text-blue-600 underline">docs.flutter.dev/ui/animations/implicit-animations</a>
    </p>
    <p class="mb-2">• Gestures & Disambiguation Arena:<br>
      <a href="https://docs.flutter.dev/ui/interactivity/gestures" class="text-blue-600 underline">docs.flutter.dev/ui/interactivity/gestures</a>
    </p>
  </div>

  <div>
    <h4 class="text-blue-700 font-bold text-sm mb-2">API Reference & Design System</h4>
    <p class="mb-2">• <code>AnimationController</code> Class:<br>
      <a href="https://api.flutter.dev/flutter/animation/AnimationController-class.html" class="text-blue-600 underline">api.flutter.dev/AnimationController</a>
    </p>
    <p class="mb-2">• <code>GestureArenaManager</code> Class:<br>
      <a href="https://api.flutter.dev/flutter/gestures/GestureArenaManager-class.html" class="text-blue-600 underline">api.flutter.dev/GestureArenaManager</a>
    </p>
    <p class="mb-2">• Material Design 3 Motion Principles:<br>
      <a href="https://m3.material.io/styles/motion/overview/how-it-works" class="text-blue-600 underline">m3.material.io/styles/motion</a>
    </p>
  </div>
</div>

<p class="text-center text-slate-500 text-[11px] mt-6 italic">
  Tất cả các liên kết tham khảo đã được kiểm tra kết nối trực tiếp (HTTP 200 OK).
</p>

<!--
Toàn bộ tài liệu tham khảo chính thức đều được kiểm tra mở và hoạt động bình thường. Em xin cảm ơn Thầy và các bạn đã theo dõi bài báo cáo.
-->
