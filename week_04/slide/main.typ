#import "@preview/typslides:1.3.4": *
#import "@preview/diagraph:0.3.3": *

// =============================================================
// CẤU HÌNH GIAO DIỆN (16:9, TỐI GIẢN CHỮ, ĐA DẠNG HÓA BIỂU DIỄN THỊ GIÁC)
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
// 3. VAI TRÒ CỦA ANIMATION: KIỀNG 3 CHÂN (PILLAR RADAR)
// =============================================================
#slide(title: "Animation & UX Roles", outlined: true)[
  #v(0.4em)
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 15pt,
    [
      #rect(width: 100%, height: 72%, stroke: 1.5pt + rgb("#3182ce"), fill: rgb("#ebf8ff"), inset: 12pt, radius: 10pt)[
        #align(center)[
          #circle(radius: 24pt, fill: rgb("#3182ce"))[
            #v(5pt) #text(size: 20pt, fill: white)[*1*]
          ]
          #v(0.5em)
          #text(size: 14pt, weight: "bold", fill: rgb("#2b6cb0"))[State Continuity]
          #v(0.4em)
          #text(size: 12pt)[
            *Tính liên tục không gian:* Loại bỏ hiện tượng giao diện giật cục khi chuyển trang hoặc thay đổi bố cục màn hình.
          ]
        ]
      ]
    ],
    [
      #rect(width: 100%, height: 72%, stroke: 1.5pt + rgb("#dd6b20"), fill: rgb("#feebc8"), inset: 12pt, radius: 10pt)[
        #align(center)[
          #circle(radius: 24pt, fill: rgb("#dd6b20"))[
            #v(5pt) #text(size: 20pt, fill: white)[*2*]
          ]
          #v(0.5em)
          #text(size: 14pt, weight: "bold", fill: rgb("#c05621"))[Guided Focus]
          #v(0.4em)
          #text(size: 12pt)[
            *Dẫn dắt sự chú ý:* Hướng ánh mắt người dùng theo dõi nguồn gốc xuất hiện của dữ liệu hoặc kết quả xử lý.
          ]
        ]
      ]
    ],
    [
      #rect(width: 100%, height: 72%, stroke: 1.5pt + rgb("#38a169"), fill: rgb("#c6f6d5"), inset: 12pt, radius: 10pt)[
        #align(center)[
          #circle(radius: 24pt, fill: rgb("#38a169"))[
            #v(5pt) #text(size: 20pt, fill: white)[*3*]
          ]
          #v(0.5em)
          #text(size: 14pt, weight: "bold", fill: rgb("#276749"))[Touch Feedback]
          #v(0.4em)
          #text(size: 12pt)[
            *Phản hồi chạm tức thì:* Xác nhận tương tác $<100$ms, triệt tiêu trạng thái bấm lặp do nghi ngờ máy đơ.
          ]
        ]
      ]
    ],
  )
]

// =============================================================
// 4. YÊU CẦU ĐỀ BÀI (SPEC)
// =============================================================
#slide(title: "Requirements (Spec)", outlined: true)[
  #v(0.2em)
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
// 5. KIẾN TRÚC PHÂN TẦNG: LAYER STACK SANDWICH
// =============================================================
#slide(title: "Flutter Animation Architecture", outlined: true)[
  #v(0.2em)
  #align(center)[
    #stack(
      spacing: 8pt,
      rect(width: 90%, height: 48pt, fill: rgb("#ebf8ff"), stroke: 1.5pt + rgb("#3182ce"), radius: 6pt)[
        #align(center + horizon)[
          #text(size: 13.5pt, weight: "bold", fill: rgb("#2b6cb0"))[TẦNG WIDGETS] -- `AnimatedContainer` (Implicit) $|$ `SlideTransition` / `ScaleTransition` (Explicit)
        ]
      ],
      rect(width: 90%, height: 48pt, fill: rgb("#f0fff4"), stroke: 1.5pt + rgb("#38a169"), radius: 6pt)[
        #align(center + horizon)[
          #text(size: 13.5pt, weight: "bold", fill: rgb("#276749"))[TẦNG ĐIỀU KHIỂN & NỘI SUY] -- `AnimationController` ($0.0 \to 1.0$) $|$ `Tween<T>` $|$ `CurvedAnimation`
        ]
      ],
      rect(width: 90%, height: 48pt, fill: rgb("#fefcbf"), stroke: 1.5pt + rgb("#d69e2e"), radius: 6pt)[
        #align(center + horizon)[
          #text(size: 13.5pt, weight: "bold", fill: rgb("#975a16"))[TẦNG LÀM TƯƠI ĐỒNG BỘ] -- `Ticker` & `TickerProvider` (Khóa nhịp VSync 60Hz / 120Hz ProMotion)
        ]
      ],
      rect(width: 90%, height: 48pt, fill: rgb("#faf5ff"), stroke: 1.5pt + rgb("#805ad5"), radius: 6pt)[
        #align(center + horizon)[
          #text(size: 13.5pt, weight: "bold", fill: rgb("#6b46c1"))[TẦNG PHẦN CỨNG (GPU)] -- Chỉ vẽ Transform Matrix Layer $|$ *Không bao giờ rebuild Widget con*
        ]
      ],
    )
  ]
]

// =============================================================
// 6. SO SÁNH ĐỐI ĐẦU: SIDE-BY-SIDE MATRIX TABLE
// =============================================================
#slide(title: "Implicit vs Explicit Matrix", outlined: true)[
  #v(0.3em)
  #align(center)[
    #table(
      columns: (1fr, 1.25fr, 1.25fr),
      inset: 8pt,
      align: (left, left, left),
      fill: (x, y) => if y == 0 { rgb("#ebf8ff") } else if calc.even(y) { rgb("#f7fafc") } else { none },
      table.header([*Đặc Tính Kỹ Thuật*], [*Implicit Animation*], [*Explicit Animation*]),
      [Mô hình lập trình], [Khai báo (*Declarative*)], [Mệnh lệnh (*Imperative*)],
      [Quản lý Controller], [Framework tự quản lý 100% ngầm], [Lập trình viên tự khởi tạo & điều khiển],
      [Khả năng kiểm soát], [Chỉ chạy từ điểm $A \to B$ một chiều], [Toàn quyền: `forward`, `reverse`, `repeat`, `spring`],
      [Nguy cơ rò rỉ bộ nhớ], [Trắng án (*Zero Memory Leak*)], [Cao (*Bắt buộc phải `dispose()` sạch Ticker*)],
      [Trường hợp áp dụng], [Nút bấm, thẻ mở rộng, đổi màu state], [Kéo thả cử chỉ, hiệu ứng lặp, Staggered motion],
    )
  ]
]

// =============================================================
// 7. VÒNG ĐỜI & GIẢI PHÓNG TÀI NGUYÊN: TIMELINE VÒNG ĐỜI
// =============================================================
#slide(title: "Explicit Lifecycle & Memory Safety", outlined: true)[
  #v(0.2em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#38a169"), fill: rgb("#f0fff4"), inset: 10pt, radius: 8pt)[
        #align(center)[*1. Giai Đoạn Khởi Tạo (Mount)*]
        #v(0.2em)
        #text(size: 12.5pt)[
          - `initState()` kích hoạt.
          - `SingleTickerProviderStateMixin` trói `Ticker` với xung VSync hệ thống.
          - Ticker giữ tham chiếu mạnh (*Strong Ref*) tới State.
        ]
      ]
    ],
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#e53e3e"), fill: rgb("#fff5f5"), inset: 10pt, radius: 8pt)[
        #align(center)[*2. Giai Đoạn Giải Phóng (Unmount)*]
        #v(0.2em)
        #text(size: 12.5pt)[
          - *Bước 1:* `controller.dispose()` $\to$ Hủy Ticker & ngắt kết nối.
          - *Bước 2:* `super.dispose()` $\to$ Dọn dẹp State an toàn.
          - Nếu làm ngược: *Framework Assertion Crash & Memory Leak!*
        ]
      ]
    ],
  )
  #v(0.3em)
  #align(center)[
    #rect(width: 90%, stroke: 1pt + rgb("#c53030"), fill: rgb("#fff5f5"), inset: 6pt, radius: 6pt)[
      #text(size: 12.5pt, fill: rgb("#c53030"))[
        *Nguyên lý cốt lõi:* Ticker còn sống $\to$ GC không thể thu hồi State $\to$ Tràn bộ nhớ Heap vĩnh viễn.
      ]
    ]
  ]
]

// =============================================================
// 8. ĐẤU TRƯỜNG CỬ CHỈ: PHỄU LOẠI TRỪ (FUNNEL FILTER)
// =============================================================
#slide(title: "Gesture Arena & Disambiguation", outlined: true)[
  #v(0.1em)
  #align(center)[
    #stack(
      spacing: 6pt,
      rect(width: 85%, height: 42pt, fill: rgb("#ebf8ff"), stroke: 1.5pt + rgb("#3182ce"), radius: 6pt)[
        #align(center + horizon)[*BƯỚC 1: TIẾP NHẬN CHẠM (PointerDown)* -- Tất cả Recognizer thỏa tọa độ cùng vào Arena]
      ],
      rect(width: 70%, height: 42pt, fill: rgb("#feebc8"), stroke: 1.5pt + rgb("#dd6b20"), radius: 6pt)[
        #align(center + horizon)[*BƯỚC 2: MÀNG LỌC TOUCH SLOP ($>18$dp)* -- Đo vector di chuyển; sai hướng tự rút lui (*Self-elimination*)]
      ],
      rect(width: 55%, height: 42pt, fill: rgb("#c6f6d5"), stroke: 1.5pt + rgb("#38a169"), radius: 6pt)[
        #align(center + horizon)[*BƯỚC 3: CHIẾN THẮNG (Declare Win)* -- Nhận diện thành công; loại bỏ toàn bộ đối thủ còn lại]
      ],
    )
  ]
  #v(0.2em)
  #align(center)[
    #text(size: 12.5pt)[
      *Quy tắc phân cấp Cha - Con:* Widget con được nạp vào Arena trước $\to$ Ưu tiên xử lý *First-Come, First-Served*.
    ]
  ]
]

// =============================================================
// 9. THƯỚC ĐO THỜI GIAN UX: HORIZONTAL GAUGE
// =============================================================
#slide(title: "UX Motion Principles & Latency", outlined: true)[
  #v(0.3em)
  #align(center)[
    #grid(
      columns: (1fr, 1.8fr, 1.2fr),
      gutter: 10pt,
      [
        #rect(width: 100%, height: 60pt, fill: rgb("#c6f6d5"), stroke: 1.5pt + rgb("#38a169"), radius: 8pt)[
          #align(center + horizon)[
            #text(size: 14pt, weight: "bold", fill: rgb("#276749"))[< 100 ms] \
            #text(size: 11pt)[Phản hồi xúc giác tức thì]
          ]
        ]
      ],
      [
        #rect(width: 100%, height: 60pt, fill: rgb("#ebf8ff"), stroke: 1.5pt + rgb("#3182ce"), radius: 8pt)[
          #align(center + horizon)[
            #text(size: 14pt, weight: "bold", fill: rgb("#2b6cb0"))[150 ms -- 350 ms] \
            #text(size: 11pt)[Chuyển cảnh tối ưu (Natural Easing)]
          ]
        ]
      ],
      [
        #rect(width: 100%, height: 60pt, fill: rgb("#fed7d7"), stroke: 1.5pt + rgb("#e53e3e"), radius: 8pt)[
          #align(center + horizon)[
            #text(size: 14pt, weight: "bold", fill: rgb("#9b2c2c"))[> 500 ms] \
            #text(size: 11pt)[Cảm giác giật lag, gây ức chế]
          ]
        ]
      ],
    )
  ]
  #v(0.3em)
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
      #align(center)[*1. At Rest (Initial State)*]
      #v(0.1em)
      #image("comp_implicit_rest.png", width: 95%)
    ],
    [
      #align(center)[*2. Interpolated (Expanded State)*]
      #v(0.1em)
      #image("comp_implicit_expanded.png", width: 95%)
    ],
  )
  #v(0.1em)
  #align(center)[
    #text(size: 13pt)[
      *AnimatedContainer:* Tự động biến đổi kích thước, màu sắc & viền khi Target Value thay đổi.
    ]
  ]
]

#slide(title: "Explicit & Gestures: Spring Physics", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    align: center,
    [
      #align(center)[*1. At Rest State*]
      #v(0.1em)
      #image("comp_drag_rest.png", width: 95%)
    ],
    [
      #align(center)[*2. 2D Dragged & Tilt Angle*]
      #v(0.1em)
      #image("comp_drag_active.png", width: 95%)
    ],
  )
  #v(0.1em)
  #align(center)[
    #text(size: 13pt)[
      *Gesture Tracking + SpringSimulation:* Xoay góc theo tọa độ kéo, buông tay lập tức nảy về gốc $(0, 0)$.
    ]
  ]
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

// =============================================================
// 14. CÂY QUYẾT ĐỊNH KỸ THUẬT: NHỊ PHÂN HÌNH HỌC (DIAMOND DECISION)
// =============================================================
#slide(title: "Engineering Decision Tree", outlined: true)[
  #v(0.1em)
  #align(center)[
    #raw-render(
      ```dot
      digraph DecisionTree {
        rankdir=TB;
        bgcolor="transparent";
        nodesep=0.3;
        ranksep=0.35;
        node [fontname="Arial", fontsize=11, margin="0.14,0.08"];
        edge [color="#4a5568", penwidth=1.4, fontname="Arial", fontsize=10];

        q [shape=diamond, style="filled", fillcolor="#feebc8", color="#dd6b20", label="Cần lặp lại / đảo chiều /\ngắn kết cử chỉ kéo thả?"];
        ans_imp [shape=box, style="filled,rounded", fillcolor="#c6f6d5", color="#38a169", label="CHỌN IMPLICIT ANIMATION\n- AnimatedContainer, AnimatedOpacity\n- Khai báo nhanh, Zero Memory Leak 100%"];
        ans_exp [shape=box, style="filled,rounded", fillcolor="#fed7d7", color="#e53e3e", label="CHỌN EXPLICIT ANIMATION\n- AnimationController + Ticker\n- Bắt buộc quản lý dispose() nghiêm ngặt"];

        q -> ans_imp [label="Không"];
        q -> ans_exp [label="Có"];
      }
      ```,
      width: 80%,
    )
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
