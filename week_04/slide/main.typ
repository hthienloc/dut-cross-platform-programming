#import "@preview/typslides:1.3.4": *
#import "@preview/diagraph:0.3.3": *

// =============================================================
// CẤU HÌNH GIAO DIỆN (16:9, TỐI GIẢN CHỮ, TỐI ĐA SƠ ĐỒ TRỰC QUAN)
// =============================================================
#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
  font: ("Arial", "DejaVu Sans"),
  font-size: 16pt,
  link-style: "color",
  show-progress: true,
)

#show raw.where(block: true): block.with(
  fill: rgb("#f8fafc"),
  stroke: 1pt + rgb("#cbd5e0"),
  inset: (x: 10pt, y: 7pt),
  radius: 4pt,
  width: 100%,
)
#show raw.where(block: false): box.with(
  fill: rgb("#edf2f7"),
  inset: (x: 4pt, y: 1pt),
  radius: 3pt,
)

// =============================================================
// COMPONENT DIAGRAM DÙNG CHUNG (TỰ ĐỘNG BỐ TRÍ, ĐỒNG BỘ THEME)
// =============================================================
#let flow-diagram(dot-body, dir: "LR", width: 85%) = align(center)[
  #raw-render(
    raw(
      "digraph G {
        rankdir=" + dir + ";
        bgcolor=\"transparent\";
        nodesep=0.22;
        ranksep=0.32;
        node [shape=box, style=\"filled,rounded\", fontname=\"Arial\", fontsize=11, margin=\"0.16,0.08\", fillcolor=\"#ebf8ff\", color=\"#3182ce\", penwidth=1.4];
        edge [color=\"#4a5568\", penwidth=1.4, fontname=\"Arial\", fontsize=10];
        " + dot-body + "
      }",
      lang: "dot",
    ),
    width: width,
  )
]

// =============================================================
// 1. TRANG BÌA
// =============================================================
#front-slide(
  title: "Animation & Cử Chỉ Nâng Cao",
  subtitle: [
    TRƯỜNG ĐẠI HỌC BÁCH KHOA — ĐẠI HỌC ĐÀ NẴNG \
    #text(size: 15pt)[*Chủ đề 08: Báo cáo Tuần 04 — Môn: Lập trình Đa nền tảng*]
  ],
  authors: [
    *SVTH:* Huỳnh Thiện Lộc -- *MSSV:* 106230052 \
    *GVHD:* TS. Nguyễn Duy Nhật Viễn
  ],
  info: [Đà Nẵng, 2026],
)

// =============================================================
// 2. MỤC LỤC TỔNG QUAN (2 CỘT GỌN GÀNG)
// =============================================================
#slide(title: "Nội dung báo cáo", outlined: false)[
  #v(0.2em)
  #context {
    let subsections = query(<subsection>).dedup()
    let half = calc.ceil(subsections.len() / 2)
    let left_items = subsections.slice(0, half)
    let right_items = subsections.slice(half)
    
    set text(size: 13.5pt, weight: "medium")
    set par(leading: 7pt)
    
    grid(
      columns: (1fr, 1fr),
      gutter: 30pt,
      [
        #enum(
          ..left_items.map(sub => [
            #link(sub.location(), sub.value)
          ])
        )
      ],
      [
        #enum(
          start: half + 1,
          ..right_items.map(sub => [
            #link(sub.location(), sub.value)
          ])
        )
      ]
    )
  }
]

// =============================================================
// 3. YÊU CẦU ĐỀ BÀI (SPEC)
// =============================================================
#slide(title: "Requirements (Spec)", outlined: true)[
  #v(0.3em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2b6cb0"), inset: 12pt, radius: 8pt, fill: rgb("#ebf8ff"))[
        #align(center)[*1. Theoretical Foundation*]
        #v(0.3em)
        #text(size: 13.5pt)[
          - *Implicit Animation:* `AnimatedContainer` & cơ chế nội suy.
          - *Explicit Animation:* `AnimationController` & quản lý tài nguyên.
          - *Gesture Arena:* Xung đột chạm & thời điểm kích hoạt animation.
          - *Non-blocking UX:* Nguyên tắc chuyển động mượt không cản trở.
        ]
      ]
    ],
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2f855a"), inset: 12pt, radius: 8pt, fill: rgb("#f0fff4"))[
        #align(center)[*2. Practice & Demo*]
        #v(0.3em)
        #text(size: 13.5pt)[
          - *Implicit Motion Card:* Tự động biến đổi kích thước & màu sắc.
          - *Draggable Spring Card:* Tương tác 2D pan & phục hồi lò xo.
          - *Morphing Action Button:* Xử lý async không khóa giao diện.
          - *Automated Tests:* 5/5 test pass, xác minh zero memory leak.
        ]
      ]
    ],
  )
]

// =============================================================
// PHẦN 1: CƠ SỞ LÝ THUYẾT & KIẾN TRÚC ANIMATION
// =============================================================
#slide(title: "Flutter Animation Architecture", outlined: true)[
  #v(0.05em)
  #flow-diagram(dir: "TB", width: 72%, "
    subgraph cluster_widgets {
      label=\"TẦNG WIDGETS (KHỞI TẠO)\";
      fontname=\"Arial\"; fontsize=11; color=\"#2b6cb0\"; style=\"filled,rounded\"; fillcolor=\"#ebf8ff\";
      w_imp [label=\"Implicit Widgets\\n(AnimatedContainer, Opacity)\", fillcolor=\"#bee3f8\", color=\"#2b6cb0\"];
      w_exp [label=\"Explicit Widgets\\n(Transition Widgets, AnimatedBuilder)\", fillcolor=\"#fed7d7\", color=\"#e53e3e\"];
    }
    subgraph cluster_engine {
      label=\"TẦNG ĐIỀU KHIỂN & NỘI SUY\";
      fontname=\"Arial\"; fontsize=11; color=\"#2f855a\"; style=\"filled,rounded\"; fillcolor=\"#f0fff4\";
      c_ctrl [label=\"AnimationController\\n(Quản lý tiến trình & thời lượng)\", fillcolor=\"#ffffff\", color=\"#38a169\"];
      c_tween [label=\"Tween<T> & Curves\\n(Ánh xạ 0.0 -> 1.0 sang giá trị thực)\", fillcolor=\"#ffffff\", color=\"#38a169\"];
    }
    subgraph cluster_hardware {
      label=\"TẦNG PHẦN CỨNG & RENDER LAYER\";
      fontname=\"Arial\"; fontsize=11; color=\"#805ad5\"; style=\"filled,rounded\"; fillcolor=\"#faf5ff\";
      h_ticker [label=\"Ticker & Vsync\\n(Đồng bộ xung nhịp GPU 60/120Hz)\", fillcolor=\"#e9d8fd\", color=\"#805ad5\"];
      h_gpu [label=\"GPU Render Pipeline\\n(Chỉ vẽ Transform Layer, không rebuild Widget)\", fillcolor=\"#ffffff\", color=\"#805ad5\"];
    }
    w_imp -> c_tween [label=\"Tự quản lý\"];
    w_exp -> c_ctrl [label=\"Điều khiển trực tiếp\"];
    c_ctrl -> c_tween;
    c_ctrl -> h_ticker [label=\"vsync: this\"];
    c_tween -> h_gpu;
  ")
]

#slide(title: "Implicit vs Explicit Matrix", outlined: true)[
  #v(0.1em)
  #flow-diagram(dir: "LR", width: 90%, "
    subgraph cluster_imp {
      label=\"IMPLICIT (DECLARATIVE)\";
      fontname=\"Arial\"; fontsize=12; color=\"#2b6cb0\"; style=\"filled,rounded\"; fillcolor=\"#ebf8ff\";
      i1 [label=\"Chỉ cần truyền Target Value & Duration\", fillcolor=\"#ffffff\", color=\"#3182ce\"];
      i2 [label=\"Framework tự quản lý Controller ngầm\", fillcolor=\"#ffffff\", color=\"#3182ce\"];
      i3 [label=\"ZERO Memory Leak (Tự giải phóng 100%)\", fillcolor=\"#c6f6d5\", color=\"#38a169\"];
      i1 -> i2 -> i3;
    }
    subgraph cluster_exp {
      label=\"EXPLICIT (IMPERATIVE)\";
      fontname=\"Arial\"; fontsize=12; color=\"#e53e3e\"; style=\"filled,rounded\"; fillcolor=\"#fff5f5\";
      e1 [label=\"Khởi tạo thủ công AnimationController\", fillcolor=\"#ffffff\", color=\"#e53e3e\"];
      e2 [label=\"Toàn quyền: forward, reverse, repeat, spring\", fillcolor=\"#ffffff\", color=\"#e53e3e\"];
      e3 [label=\"BẮT BUỘC dispose() trước super.dispose()\", fillcolor=\"#fed7d7\", color=\"#e53e3e\"];
      e1 -> e2 -> e3;
    }
  ")
]

#slide(title: "Explicit Lifecycle & Memory Safety", outlined: true)[
  #v(0.1em)
  #flow-diagram(dir: "LR", width: 90%, "
    state [label=\"State Object\\nwith SingleTickerProvider\", fillcolor=\"#ebf8ff\", color=\"#3182ce\"];
    ticker [label=\"Ticker Instance\\n(Vsync Listener)\", fillcolor=\"#feebc8\", color=\"#dd6b20\"];
    controller [label=\"AnimationController\\n(Active Ref)\", fillcolor=\"#fed7d7\", color=\"#e53e3e\"];
    safe_dispose [label=\"1. controller.dispose()\\n2. super.dispose()\", fillcolor=\"#c6f6d5\", color=\"#38a169\"];

    state -> ticker [label=\"createTicker()\"];
    ticker -> controller [label=\"Strong Ref\"];
    controller -> safe_dispose [label=\"Ngắt kết nối\"];
  ")
  #v(0.15em)
  #align(center)[
    #rect(stroke: 1pt + rgb("#e53e3e"), fill: rgb("#fff5f5"), inset: 8pt, radius: 6pt)[
      #text(size: 12.5pt, fill: rgb("#c53030"))[
        *Quy tắc giải phóng bắt buộc:* Luôn gọi `controller.dispose()` trước `super.dispose()` để ngắt Ticker listener.
      ]
    ]
  ]
]

#slide(title: "Gesture Arena & Disambiguation", outlined: true)[
  #v(0.1em)
  #flow-diagram(dir: "LR", width: 90%, "
    pointer [label=\"PointerDown\\n(Hit-testing)\", fillcolor=\"#ebf8ff\", color=\"#3182ce\"];
    arena [label=\"Gesture Arena\\n(Tap, Horizontal, Vertical)\", fillcolor=\"#feebc8\", color=\"#dd6b20\"];
    slop [label=\"Touch Slop (> 18dp)\\nTrajectory Check\", fillcolor=\"#faf5ff\", color=\"#805ad5\"];
    win [label=\"1. Self-elimination\\n2. Declare Winner\\n3. Last-Man-Standing\", fillcolor=\"#c6f6d5\", color=\"#38a169\"];

    pointer -> arena [label=\"Register\"];
    arena -> slop [label=\"Finger moves\"];
    slop -> win [label=\"Disambiguation\"];
  ")
]

#slide(title: "UX Motion Principles & Latency", outlined: true)[
  #v(0.1em)
  #flow-diagram(dir: "LR", width: 88%, "
    t1 [label=\"< 100ms\\nPhản hồi xúc giác\\n(Instant Touch Feedback)\", fillcolor=\"#c6f6d5\", color=\"#38a169\"];
    t2 [label=\"150ms - 350ms\\nChuyển cảnh tối ưu\\n(Smooth Transition)\", fillcolor=\"#ebf8ff\", color=\"#3182ce\"];
    t3 [label=\"> 500ms\\nNgưỡng gây ức chế\\n(Perceived Delay)\", fillcolor=\"#fed7d7\", color=\"#e53e3e\"];

    t1 -> t2 [label=\"Natural Easing\"];
    t2 -> t3 [label=\"Tránh dùng\"];
  ")
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #text(size: 12.5pt)[
        - *Non-Blocking Interaction:* Không khóa cảm ứng khi animation đang chạy.
        - *Interruptible Motion:* Cho phép đảo chiều hoặc buông tay mượt mà.
      ]
    ],
    [
      #text(size: 12.5pt)[
        - *Guided Focus:* Dẫn dắt ánh mắt theo dòng thay đổi của dữ liệu.
        - *Reduced Motion Support:* Tôn trọng thiết lập trợ năng của hệ thống.
      ]
    ],
  )
]

// =============================================================
// PHẦN 2: THỰC HÀNH & KẾT QUẢ DEMO
// =============================================================
#slide(title: "Application Architecture", outlined: true)[
  #v(0.2em)
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 15pt,
    align: horizon,
    [
      #text(size: 13.5pt)[
        - *MotionTokens (`theme/motion_tokens.dart`):*
          - Chuẩn hóa lưới 8dp (`space8`, `space16`, `space24`).
          - Thang thời lượng M3 (`150ms`, `300ms`, `450ms`).
        - *Phân hệ chuyển động độc lập:*
          - `ImplicitMotionCard`: Không Controller, tự nội suy.
          - `DragSpringCard`: `GestureDetector` + `SpringSimulation`.
          - `MorphingActionButton`: Trạng thái bất đồng bộ không chặn UI.
      ]
    ],
    [
      #align(center)[
        #image("app_overview.png", height: 78%)
      ]
    ],
  )
]

#slide(title: "Implicit Motion: State Interpolation", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    align: center,
    [
      #align(center)[*Thẻ Ban Đầu (At Rest)*]
      #v(0.1em)
      #image("app_overview.png", height: 75%)
    ],
    [
      #align(center)[*Thẻ Mở Rộng (AnimatedContainer)*]
      #v(0.1em)
      #image("implicit_expanded.png", height: 75%)
    ],
  )
]

#slide(title: "Explicit & Gestures: Spring Physics", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1.1fr),
    gutter: 15pt,
    align: horizon,
    [
      #align(center)[
        #image("explicit_dragged.png", height: 78%)
      ]
    ],
    [
      #text(size: 13pt)[
        - *Tương tác Kéo thả 2D:*
          - `onPanUpdate`: Cập nhật trực tiếp delta offset và góc nghiêng thẻ.
        - *Hồi phục bằng mô phỏng vật lý:*
          - `onPanEnd`: Trích xuất vận tốc `velocity` của ngón tay.
          - `SpringSimulation(spring, 0.0, 1.0, -velocity)` giúp thẻ nảy về gốc $(0,0)$ tự nhiên.
        - *Interruptible:* Chạm lại giữa chừng lập tức hủy chuyển động hồi phục để đón cử chỉ mới.
      ]
    ],
  )
]

#slide(title: "Automated Verification & Tests", outlined: true)[
  #v(0.2em)
  #text(size: 13.5pt)[
    - *Bộ kiểm thử tự động 5/5 kịch bản (`flutter test`: ~2.5s, 0 warning):*
      1. `Launch M3`: Khởi tạo giao diện, kiểm tra sự tồn tại của cả 3 phân hệ chuyển động.
      2. `Implicit Interpolation`: Kích hoạt mở rộng thẻ, kiểm tra nội suy kích thước & màu sắc từng frame.
      3. `Gesture Drag & Recoil`: Mô phỏng vuốt thẻ $80$px, kiểm tra trạng thái Dragging và nảy về $(0,0)$.
      4. `Non-Blocking Lifecycle`: Kiểm tra nút bấm đổi hình thái Async mà không khóa luồng tương tác.
      5. `Memory Leak Teardown`: Unmount widget, xác thực `controller.dispose()` thu hồi 100% Ticker.
  ]
]

#slide(title: "Engineering Decision Tree", outlined: true)[
  #v(0.05em)
  #flow-diagram(dir: "TB", width: 62%, "
    q1 [label=\"Nhu cầu tạo chuyển động?\", fillcolor=\"#ebf8ff\", color=\"#3182ce\"];
    q2 [label=\"Có cần lặp / đảo chiều /\\ngắn kết cử chỉ kéo thả?\", fillcolor=\"#feebc8\", color=\"#dd6b20\"];
    ans_imp [label=\"CHỌN IMPLICIT ANIMATION\\n- AnimatedContainer\\n- Zero Memory Leak, cực nhanh\", fillcolor=\"#c6f6d5\", color=\"#38a169\"];
    ans_exp [label=\"CHỌN EXPLICIT ANIMATION\\n- AnimationController + Ticker\\n- Bắt buộc quản lý dispose()\", fillcolor=\"#fed7d7\", color=\"#e53e3e\"];

    q1 -> q2;
    q2 -> ans_imp [label=\"Không\"];
    q2 -> ans_exp [label=\"Có\"];
  ")
]

// =============================================================
// PHẦN 3: TÀI LIỆU THAM KHẢO CHÍNH THỨC (HTTP 200 VERIFIED)
// =============================================================
#slide(title: "References", outlined: true)[
  #v(0.2em)
  #text(size: 13pt)[
    - *Official Flutter Documentation & Guides:*
      - Flutter Animations Overview: #link("https://docs.flutter.dev/ui/animations/overview")[docs.flutter.dev/ui/animations/overview]
      - Implicit Animations Guide: #link("https://docs.flutter.dev/ui/animations/implicit-animations")[docs.flutter.dev/ui/animations/implicit-animations]
      - Gestures & Disambiguation Arena: #link("https://docs.flutter.dev/ui/interactivity/gestures")[docs.flutter.dev/ui/interactivity/gestures]
    - *Official API Reference:*
      - `AnimationController`: #link("https://api.flutter.dev/flutter/animation/AnimationController-class.html")[api.flutter.dev/AnimationController]
      - `AnimatedContainer`: #link("https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html")[api.flutter.dev/AnimatedContainer]
      - `GestureArenaManager`: #link("https://api.flutter.dev/flutter/gestures/GestureArenaManager-class.html")[api.flutter.dev/GestureArenaManager]
    - *Material Design Guidelines:*
      - Material 3 Motion Principles: #link("https://m3.material.io/styles/motion/overview/how-it-works")[m3.material.io/styles/motion]
  ]
]
