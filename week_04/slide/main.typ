#import "@preview/typslides:1.3.4": *

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
  #align(center)[
    #image("diagrams/animation_architecture.svg", height: 75%)
  ]
]

#slide(title: "Implicit vs Explicit Matrix", outlined: true)[
  #v(0.1em)
  #align(center)[
    #image("diagrams/implicit_explicit_matrix.svg", width: 92%)
  ]
]

#slide(title: "Explicit Lifecycle & Memory Safety", outlined: true)[
  #v(0.1em)
  #align(center)[
    #image("diagrams/controller_lifecycle.svg", width: 90%)
  ]
  #v(0.2em)
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
  #align(center)[
    #image("diagrams/gesture_arena.svg", width: 90%)
  ]
]

#slide(title: "UX Motion Principles & Latency", outlined: true)[
  #v(0.1em)
  #align(center)[
    #image("diagrams/ux_motion_timeline.svg", width: 88%)
  ]
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
  #align(center)[
    #image("diagrams/decision_tree.svg", height: 75%)
  ]
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
