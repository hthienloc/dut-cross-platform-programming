#import "@preview/typslides:1.3.4": *

// =============================================================
// CẤU HÌNH GIAO DIỆN (CHỮ RÕ NÉT TRÊN MÁY CHIẾU)
// =============================================================
#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
  font: ("Arial", "DejaVu Sans"),
  font-size: 17pt,
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
  title: "Thiết Kế Giao Diện Đa Phong Cách & Nguyên Tắc UX",
  subtitle: [
    TRƯỜNG ĐẠI HỌC BÁCH KHOA — ĐẠI HỌC ĐÀ NẴNG \
    #text(size: 15pt)[*Chủ đề 04: Báo cáo Tuần 03 — Môn: Lập trình Đa nền tảng*]
  ],
  authors: [
    *SVTH:* Huỳnh Thiện Lộc -- *MSSV:* 106230052 \
    *GVHD:* TS. Nguyễn Duy Nhật Viễn
  ],
  info: [Đà Nẵng, 2026],
)

// =============================================================
// 2. MỤC LỤC BÁO CÁO (2 CỘT RÕ RÀNG, CHỮ TO DỄ ĐỌC)
// =============================================================
#slide(title: "Nội dung báo cáo", outlined: false)[
  #v(0.1em)
  #context {
    let subsections = query(<subsection>).dedup()
    let half = calc.ceil(subsections.len() / 2)
    let left_items = subsections.slice(0, half)
    let right_items = subsections.slice(half)
    
    set text(size: 13pt, weight: "medium")
    set par(leading: 6pt)
    
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

#slide(title: "Requirements (Spec)", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2b6cb0"), inset: 10pt, radius: 6pt, fill: rgb("#ebf8ff"))[
        #align(center)[*1. Theoretical Foundation*]
        #v(0.2em)
        #text(size: 13.5pt)[
          - *Overview:* Material Design 3 (Google) vs Cupertino (Apple HIG).
          - *Scaffold & AppBar:* So sánh cấu trúc khung xương layout nền tảng.
          - *Theme & Typography:* Cơ chế kế thừa `InheritedWidget` và token hệ thống.
          - *UX Pillars:* Consistency, Interactive Feedback, Readability, a11y.
        ]
      ]
    ],
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2f855a"), inset: 10pt, radius: 6pt, fill: rgb("#f0fff4"))[
        #align(center)[*2. Practice & Demo*]
        #v(0.2em)
        #text(size: 13.5pt)[
          - *Implementation:* Unified design system adhering to 8dp grid tokens.
          - *Design Decisions:* Giải trình lý do chọn FilledButton, ChangeNotifier, Seed.
          - *Live Demo:* Trình diễn chuyển đổi phong cách, Dark Mode, font scaling.
          - *Automated Verification:* Widget tests xác minh a11y bounds ($>= 48$dp / $>= 44$pt).
        ]
      ]
    ],
  )
]

// =============================================================
// PHẦN 1: CƠ SỞ LÝ THUYẾT & HAI TRƯỜNG PHÁI THIẾT KẾ
// =============================================================
#slide(title: "UI vs UX Fundamentals", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2b6cb0"), inset: 9pt, radius: 6pt, fill: rgb("#ebf8ff"))[
        #align(center)[*UI — User Interface*]
        #v(0.1em)
        #text(size: 13pt)[
          - *Định nghĩa:* Điểm tiếp xúc thị giác trực tiếp giữa người dùng và phần mềm.
          - *Yếu tố cấu thành:* Color palette, typography, icon, layout, spacing, corner radius.
          - *Mục tiêu:* Đẹp mắt, rõ ràng, thẩm mỹ hài hòa, phản ánh đúng brand identity.
        ]
      ]
    ],
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2f855a"), inset: 9pt, radius: 6pt, fill: rgb("#f0fff4"))[
        #align(center)[*UX — User Experience*]
        #v(0.1em)
        #text(size: 13pt)[
          - *Định nghĩa:* Cảm xúc, nhận thức và mức độ dễ dàng khi hoàn thành tác vụ.
          - *Yếu tố cấu thành:* User flow, feedback latency, thumb-reach ergonomics, cognitive load.
          - *Mục tiêu:* Hiệu quả, không gây bực bội, thao tác tự nhiên theo mental model.
        ]
      ]
    ],
  )
]

#slide(title: "Flutter Widget Architecture", outlined: true)[
  #v(0.1em)
  #align(center)[
    #image("widget_tree.svg", width: 85%)
  ]
  #v(0.1em)
  - Cấu trúc chung của Widget trong Flutter:
    - *Everything is a Widget:* Khung trang, căn lề, màu sắc, cử chỉ đều là widget ghép lồng (Composition over Inheritance).
    - *3 Cây cốt lõi:* Widget Tree (bản vẽ mô tả) $arrow.r$ Element Tree (quản lý ngữ cảnh `BuildContext`) $arrow.r$ Render Tree (tính tọa độ layout & vẽ GPU).
    - *Cơ chế Theme:* Nhúng `InheritedWidget` ở gốc để các widget con tự động truy vấn `Theme.of(context)` với độ phức tạp $O(1)$.
]

#slide(title: "Evolution & Origins", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2b6cb0"), inset: 9pt, radius: 6pt, fill: rgb("#ebf8ff"))[
        #align(center)[*Google Material Design*]
        #v(0.1em)
        #text(size: 13pt)[
          - 2014 (M1): Triết lý vật liệu kỹ thuật số Flat & Drop Shadow thay thế Holo.
          - 2018 (M2): Bo góc lớn hơn, chuẩn hóa 8dp Grid System.
          - 2021 (M3 - Material You): Dynamic Color sinh tự động từ hình nền, cá nhân hóa sâu sắc.
        ]
      ]
    ],
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2f855a"), inset: 9pt, radius: 6pt, fill: rgb("#f0fff4"))[
        #align(center)[*Apple Cupertino (HIG)*]
        #v(0.1em)
        #text(size: 13pt)[
          - 2007 (iOS 1-6): Skeuomorphism mô phỏng chất liệu đời thực.
          - 2013 (iOS 7): Flat Design tối giản của Jony Ive, khai sinh Frosted Blur.
          - Hiện nay (iOS 15-18): 3 trụ cột Clarity, Deference, Depth cùng SF Pro & SF Symbols.
        ]
      ]
    ],
  )
]

#slide(title: "Design System Landscape", outlined: true)[
  #v(0.2em)
  - Ngoài Material và Cupertino, thế giới UI/UX còn có các tiêu chuẩn lớn:
    - Fluent Design System (Microsoft): Trọng tâm vào ánh sáng (Light), chiều sâu (Depth), chất liệu bán trong suốt (Mica/Acrylic) và chuyển động mượt mà.
    - One UI (Samsung): Chia màn hình thành vùng hiển thị (Viewing Area ở trên) và vùng tương tác (Interaction Area ở nửa dưới) giúp thao tác bằng một tay.
    - Carbon Design (IBM) / Polaris (Shopify) / Ant Design (Alibaba): Các chuẩn mực thiết kế hàng đầu cho hệ thống quản trị dữ liệu lớn (Enterprise dashboards).
  - Điểm chung: Đều xây dựng trên hệ thống Design Tokens (màu sắc, khoảng cách lưới, phông chữ) để duy trì tính nhất quán trên diện rộng.
]

#slide(title: "Cross-Platform Challenge", outlined: true)[
  #v(0.2em)
  - Sự khác biệt thói quen người dùng (Platform Familiarity):
    - Người dùng Android quen thuộc với gợn sóng Ripple effect, nút hành động nổi FAB, thanh điều hướng đáy dạng viên thuốc.
    - Người dùng iOS kỳ vọng cử chỉ vuốt cạnh trái để lùi trang, hiệu ứng mờ kính phủ Frosted Glass và thanh điều hướng tinh gọn.
  - Mục tiêu kỹ thuật:
    - Cùng một codebase duy nhất nhưng giao diện phản ứng linh hoạt (Adaptive & Responsive).
    - Tối ưu hóa trải nghiệm tự nhiên, không mang lại cảm giác app web đóng gói hay ngoại lai.
]

#slide(title: "Visual Comparison", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    align: center,
    [
      #align(center)[*Material Design 3 (Google)*]
      #v(0.1em)
      #align(center)[#image("material_overview.png", height: 75%)]
    ],
    [
      #align(center)[*Cupertino / HIG (Apple iOS)*]
      #v(0.1em)
      #align(center)[#image("cupertino_overview.png", height: 75%)]
    ],
  )
]

#slide(title: "Design Paradigms", outlined: true)[
  #v(0.2em)
  #align(center)[
    #table(
      columns: (1fr, 1.25fr, 1.25fr),
      inset: 7pt,
      align: (left, left, left),
      fill: (x, y) => if y == 0 { rgb("#ebf8ff") } else if calc.even(y) { rgb("#f7fafc") } else { none },
      table.header([*Tiêu chí*], [*Material Design 3 (M3)*], [*Cupertino (Apple HIG)*]),
      [Triết lý], [Cá nhân hóa, Digital Paper & Ink], [Tối giản: Clarity, Deference, Depth],
      [Hệ thống màu], [Dynamic Color sinh từ Seed Color], [CupertinoDynamicColor linh hoạt],
      [Phân tầng thị giác], [Elevation & Surface Container], [Backdrop Blur & Thin Dividers],
      [Phản hồi chạm], [Ripple Effect (InkWell)], [Opacity Reduction (40%) & Haptics],
    )
  ]
]

#slide(title: "Scaffold & AppBar Architecture", outlined: true)[
  #v(0.05em)
  #align(center)[
    #image("scaffold_structure.svg", width: 75%)
  ]
  #v(0.05em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #text(size: 12.5pt)[
        - *Material 3 (Cấu trúc trang):*
          - `Scaffold`: Quản trị layout trang tổng thể (`appBar`, `body`, `bottomNavigationBar`, `snackBar`).
          - `AppBar`: Hỗ trợ `centerTitle: false` (chuẩn Android), `elevation`, `actions`.
          - `NavigationBar`: Thanh điều hướng đáy dạng pill indicator, nhãn luôn hiển thị.
      ]
    ],
    [
      #text(size: 12.5pt)[
        - *Cupertino (Phân cấp luồng & Tab):*
          - `CupertinoTabScaffold`: Quản trị đa tab độc lập, mỗi tab có stack điều hướng riêng biệt.
          - `CupertinoPageScaffold`: Khung nhìn cho từng trang đơn lẻ, tích hợp `navigationBar`.
          - `CupertinoNavigationBar`: Header Frosted Glass, `middle` căn giữa, `leading` & `trailing`.
      ]
    ],
  )
]

#slide(title: "Buttons & Touch Targets", outlined: true)[
  #v(0.1em)
  #align(center)[
    #image("button_comparison.png", width: 90%)
  ]
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      - *Material 3 Filled Button:*
        - Touch Target tối thiểu $48 times 48$ dp.
        - Corner radius $12$ dp, hiệu ứng InkWell Ripple.
    ],
    [
      - *Cupertino Button Filled:*
        - Touch Target tối thiểu $44 times 44$ pt.
        - Corner radius $10$ pt, hiệu ứng Opacity Reduction $40\%$.
    ],
  )
]

#slide(title: "Color Systems & Theming", outlined: true)[
  #v(0.1em)
  - Ứng dụng UI/UX trong `ThemeData` & Không gian màu:
    - *InheritedWidget Registry:* Theme hoạt động như kho chứa Design Tokens tập trung ở gốc widget tree, giúp mọi component con truy cập `Theme.of(context)` với độ phức tạp $O(1)$ mà không bị Prop Drilling.
    - *Material 3 Dynamic Palette:* Hàm `ColorScheme.fromSeed()` áp dụng toán học không gian màu HCT (Hue, Chroma, Tone) sinh tự động bộ 30+ màu tương phản, đảm bảo chữ luôn tương phản rõ ràng trên nền.
    - *Cupertino Dynamic Adaptation:* `CupertinoDynamicColor.withSettings()` tự động tính toán lại mã màu RGB khi người dùng bật Dark Mode hoặc chế độ Tăng độ tương phản của iOS.
    - *Dark Mode Semantic Mapping:* Thay vì gán cứng mã màu hex, dùng `colorScheme.surface`, `colorScheme.onSurface` để tự động đảo màu nền/chữ chuẩn xác.
]

#slide(title: "Typography & Visual Hierarchy", outlined: true)[
  #v(0.1em)
  - Chuẩn hóa kiểu chữ và phân cấp thị giác theo thiết kế:
    - *15 Phân cấp TextTheme:* Gồm 5 nhóm chính (`display`, `headline`, `title`, `body`, `label`) với 3 kích cỡ (Large, Medium, Small) giúp giao diện có trật tự thị giác chặt chẽ.
    - *Ví dụ gọi thực tế trong mã nguồn Flutter:*
      #text(size: 13pt)[
      ```dart
      Text("Overview Dashboard", style: Theme.of(context).textTheme.titleLarge)
      Text("Tap card to view details", style: Theme.of(context).textTheme.bodyMedium)
      ```
      ]
    - *Khả năng tự thích ứng (Adaptive Typography):*
      - Material 3: Sử dụng font Roboto hoặc font hệ thống với `letterSpacing` và `fontWeight` được tinh chỉnh cho màn hình Android.
      - Cupertino: Tự động map sang San Francisco (SF Pro) với kerning động theo kích cỡ chữ.
    - *Dynamic Scaling Resilient:* Hỗ trợ scale font từ 80% đến 140% mà không bị vỡ layout (tránh overflow bằng `Flexible` và `Wrap`).
]

// =============================================================
// PHẦN 2: 4 TRỤ CỘT NGUYÊN TẮC UX
// =============================================================
#slide(title: "Core UX Pillars", outlined: true)[
  #v(0.1em)
  #align(center)[
    #image("ux_pillars.svg", width: 80%)
  ]
  - Consistency: Đồng nhất hệ thống Spacing (Grid 8dp: 8, 16, 24, 32).
  - Feedback: Xác nhận tức thời thao tác chạm, không để màn hình "chết" khi gọi async.
  - Readability: Đảm bảo độ tương phản chữ/nền tối thiểu 4.5:1 (WCAG AA).
  - Accessibility: Kích thước vùng bấm tối thiểu $48 times 48$ dp (M3) hoặc $44 times 44$ pt (iOS).
]

#slide(title: "Consistency & Feedback", outlined: true)[
  #v(0.2em)
  - Tính nhất quán nội tại (Internal Consistency):
    - Quy chuẩn hóa toàn bộ spacing và padding qua hằng số `AppTokens`.
    - Tránh việc đặt padding tùy hứng (13, 17, 21...) gây mất cân đối thị giác.
  - Phản hồi tương tác (Interactive Feedback):
    - Thao tác người dùng luôn có phản hồi thị giác trong vòng 100ms.
    - Asynchronous tasks hiển thị `AdaptiveLoadingIndicator` và thông báo hoàn tất bằng `SnackBar` (Material) hoặc Status Card (Cupertino).
]

#slide(title: "Readability & a11y", outlined: true)[
  #v(0.2em)
  - Phân cấp thị giác rõ ràng (Visual Hierarchy):
    - Title Large: 18--22pt, Font weight: Bold.
    - Body Medium: 14pt, 70% Opacity hoặc Secondary label.
  - Accessibility (a11y) trong mã nguồn Flutter:
    - Sử dụng `Semantics(button: true, label: ...)` hỗ trợ TalkBack và VoiceOver.
    - Đảm bảo `SizedBox(height: 48)` cho Material và 44 cho Cupertino để touch targets an toàn.
    - Cung cấp thanh kéo điều chỉnh tỉ lệ font chữ ($80% - 140%$) ngay trong ứng dụng.
]

#slide(title: "UX Controls & Scaling", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    align: center,
    [
      #align(center)[*Material 3 Slider (Settings)*]
      #v(0.1em)
      #align(center)[#image("material_settings.png", height: 75%)]
    ],
    [
      #align(center)[*Cupertino Slider (Settings)*]
      #v(0.1em)
      #align(center)[#image("cupertino_settings.png", height: 75%)]
    ],
  )
]

// =============================================================
// PHẦN 3: KIẾN TRÚC MÃ NGUỒN, THIẾT KẾ & THỰC HÀNH DEMO
// =============================================================
#slide(title: "System Architecture", outlined: true)[
  #v(0.1em)
  #align(center)[
    #image("system_architecture.svg", width: 95%)
  ]
  - Trạng thái được quản lý tập trung qua `AppStateNotifier` (`ChangeNotifier`), lắng nghe bởi root widget.
  - Tách biệt hoàn toàn Presentation Layer (`AdaptivePrimaryButton`, `AdaptiveDialog`) khỏi Business Logic Layer; tái sử dụng 100% logic xử lý async.
]

#slide(title: "Design Decisions", outlined: true)[
  #v(0.1em)
  #text(size: 13.5pt)[
    - *FilledButton thay vì ElevatedButton:*
      - M3 khuyến nghị FilledButton cho primary action vì container fill đặc tạo visual prominence cao nhất, không phụ thuộc vào shadow vốn khó nhìn trong Dark Mode.
    - *ChangeNotifier thuần thay vì Provider / Bloc:*
      - Tránh cài thêm third-party package thừa thãi cho phạm vi quản lý localized UI state (style, dark mode, text scale). Sử dụng native Flutter API nhẹ, dễ maintain, zero dependency overhead.
    - *Seed Color (`#2196F3` - Material Blue):*
      - Tone màu công nghệ trung tính, có độ bão hòa (chroma) chuẩn mực trong không gian HCT, giúp thuật toán sinh ra tonal palette tương phản đạt chuẩn WCAG 2.1 AA cho cả Light và Dark mode.
    - *8dp Grid Tokens (`AppTokens`):*
      - Bội số của 8dp (8, 16, 24, 32) khớp hoàn hảo với screen pixel densities hiện đại (tỉ lệ 1x, 2x, 3x), triệt tiêu hoàn toàn anti-aliasing artifacts và subpixel deviation.
  ]
]

#slide(title: "Adaptive Button Code", outlined: true)[
  #v(0.1em)
  #text(size: 14pt)[
  ```dart
  class AdaptivePrimaryButton extends StatelessWidget {
    final AppDesignStyle style;
    final String label;
    final VoidCallback onPressed;

    @override
    Widget build(BuildContext context) {
      if (style == AppDesignStyle.cupertino) {
        return SizedBox(
          height: 44.0, // Chuẩn Apple HIG Touch Target
          child: CupertinoButton.filled(onPressed: onPressed, child: Text(label)),
        );
      }
      return SizedBox(
        height: 48.0, // Chuẩn Material M3 Touch Target
        child: FilledButton(onPressed: onPressed, child: Text(label)),
      );
    }
  }
  ```
  ]
]

#slide(title: "Adaptive Dialogs", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    align: center,
    [
      #align(center)[*Material 3 AlertDialog*]
      #v(0.1em)
      #align(center)[#image("material_dialog.png", height: 75%)]
    ],
    [
      #align(center)[*CupertinoAlertDialog (iOS)*]
      #v(0.1em)
      #align(center)[#image("cupertino_dialog.png", height: 75%)]
    ],
  )
]

#slide(title: "Live Application Demo", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1.1fr, 0.9fr),
    gutter: 15pt,
    [
      #text(size: 13.5pt)[
        - *Kịch bản trình diễn tương tác trực tiếp:*
          - *Hot-Swap Style:* Chuyển đổi tức thì Material 3 $arrow.l.r$ Cupertino mà không reload state ứng dụng.
          - *Theme Mode Toggle:* Chuyển đổi Light Mode $arrow.l.r$ Dark Mode, quan sát `ColorScheme` và `CupertinoDynamicColor` tự tái tạo màu.
          - *Interactive Feedback:* Bấm nút async hành động để quan sát loading indicator và thông báo phản hồi (< 100ms).
          - *Accessibility Font Scaling:* Kéo thanh Text Scale từ 80% đến 140%, chứng minh UI co giãn linh hoạt không bị tràn màn hình (Overflow).
          - *Dialog System:* Bật modal xác nhận trên cả 2 nền tảng.
      ]
    ],
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2b6cb0"), inset: 10pt, radius: 6pt, fill: rgb("#ebf8ff"))[
        #align(center)[*Chạy App Demo Trực Tiếp*]
        #v(0.3em)
        #text(size: 12.5pt)[
          ```bash
          cd week_03/app
          flutter run -d chrome
          # hoặc thiết bị Android/iOS
          ```
          #v(0.2em)
          - Codebase: Sạch 100%, 0 warning linter.
          - Kiến trúc mô-đun hóa dễ mở rộng.
        ]
      ]
    ],
  )
]

#slide(title: "Automated Tests", outlined: true)[
  #v(0.2em)
  - *4 kịch bản kiểm thử tự động toàn diện (`flutter test`: ~3.2s, 0 warning):*
    - `Launch M3`: Xác thực Render Tree chứa `MaterialApp`, `AppBar`, `NavigationBar`.
    - `Hot-toggle Cupertino`: Chạm nút swap, xác thực chuyển đổi sang `CupertinoApp`, `CupertinoTabBar`.
    - `Assert Touch Target Bounds (a11y)`: Dùng `tester.getSize()` xác minh chiều cao nút:
      - Material FilledButton: $>= 48.0$ dp.
      - CupertinoButton: $>= 44.0$ pt.
    - `Text Scaling Slider`: Tương tác kéo slider $80% - 140%$ và kiểm tra font dynamic rebuild.
]

#slide(title: "Conclusion & Trade-offs", outlined: true)[
  #v(0.2em)
  - *Kết quả đạt được:*
    - Xây dựng hoàn chỉnh kiến trúc *DualStyle Hub* chuyển đổi mượt mà giữa Material 3 và Cupertino.
    - Áp dụng triệt để 4 trụ cột UX: Spacing Grid 8dp, phản hồi tương tác $<100$ms, độ tương phản WCAG AA $>= 4.5:1$, vùng chạm an toàn a11y.
    - Kiểm thử tự động đạt 100% với 0 cảnh báo linter (`dart analyze: No issues found!`).
  - *Đánh giá Kỹ thuật & Trade-offs:*
    - *Full Adaptive UI* đem lại trải nghiệm nguyên bản (Native UX) tối đa nhưng tăng chi phí maintain (~1.5x boilerplate so với Unified UI).
    - Giải pháp tối ưu: Xây dựng tầng abstraction (`AdaptivePrimaryButton`, `AdaptiveDialog`) bọc lấy token thiết kế, cô lập logic rẽ nhánh khỏi màn hình nghiệp vụ.
]

#slide(title: "References", outlined: true)[
  #v(0.2em)
  - *Design Systems & Guidelines:*
    - Google Material Design 3 Specification: #link("https://m3.material.io")[m3.material.io]
    - Apple Human Interface Guidelines (HIG): #link("https://developer.apple.com/design/human-interface-guidelines")[developer.apple.com/design]
    - Web Content Accessibility Guidelines (WCAG 2.1 AA): #link("https://www.w3.org/WAI/standards-guidelines/wcag/")[w3.org/WAI]
  - *Flutter Engineering & Architecture:*
    - Flutter Material & Cupertino Libraries: #link("https://api.flutter.dev")[api.flutter.dev]
    - Building Adaptive Apps in Flutter: #link("https://docs.flutter.dev/ui/adaptive-responsive")[docs.flutter.dev/ui/adaptive-responsive]
    - Project Repository & Automated Tests: #link("https://github.com/hthienloc/Hell")[github.com/hthienloc/Hell/week_03]
]
