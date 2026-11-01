#import "@preview/typslides:1.3.4": *
#import "@preview/diagraph:0.3.3": *

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
// 2. MỤC LỤC BÁO CÁO (2 CỘT RÕ RÀNG, DỄ ĐỌC)
// =============================================================
#slide(title: "Nội dung báo cáo", outlined: false)[
  #v(0.1em)
  #columns(2, gutter: 20pt)[
    #set text(size: 13.5pt)
    #context {
      let subsections = query(<subsection>).dedup()
      enum(
        ..subsections.map(sub => [
          #link(sub.location(), sub.value)
        ])
      )
    }
  ]
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
        #text(size: 14pt)[
          - *Overview:* Material Design 3 (Google) vs Cupertino (Apple HIG).
          - *Core Elements:* `Scaffold`, `AppBar`, theme, typography, color system.
          - *UX Pillars:* Consistency, Interactive Feedback, Readability, a11y.
        ]
      ]
    ],
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2f855a"), inset: 10pt, radius: 6pt, fill: rgb("#f0fff4"))[
        #align(center)[*2. Practice & Demo*]
        #v(0.2em)
        #text(size: 14pt)[
          - *Implementation:* Unified design system adhering to 8dp grid tokens.
          - *Design Decisions:* Justify components, themes, and UX trade-offs.
          - *Automated Verification:* Widget tests for adaptive rendering & a11y bounds.
        ]
      ]
    ],
  )
]

// =============================================================
// PHẦN 1: CƠ SỞ LÝ THUYẾT & HAI TRƯỜNG PHÁI THIẾT KẾ
// =============================================================
#slide(title: "1. Evolution & Origins", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2b6cb0"), inset: 9pt, radius: 6pt, fill: rgb("#ebf8ff"))[
        #align(center)[*Google Material Design*]
        #v(0.1em)
        #text(size: 13pt)[
          - 2014 (M1): Loại bỏ Holo tối tăm, ra mắt triết lý vật liệu giấy & mực kỹ thuật số (Flat + Shadow).
          - 2018 (M2): Bo góc lớn hơn, chuẩn hóa lưới khoảng cách 8dp.
          - 2021 (M3 - Material You): Trích xuất Dynamic Color từ hình nền người dùng, cá nhân hóa sâu sắc.
        ]
      ]
    ],
    [
      #rect(width: 100%, stroke: 1.5pt + rgb("#2f855a"), inset: 9pt, radius: 6pt, fill: rgb("#f0fff4"))[
        #align(center)[*Apple Cupertino (HIG)*]
        #v(0.1em)
        #text(size: 13pt)[
          - 2007 (iOS 1-6): Thời kỳ Skeuomorphism (mô phỏng da thuộc, kính bóng, gỗ thật).
          - 2013 (iOS 7): Cuộc cách mạng Flat Design tối giản của Jony Ive, khai sinh kính mờ (Frosted Blur).
          - Hiện nay (iOS 15-18): Hoàn thiện 3 trụ cột Clarity, Deference, Depth cùng SF Pro & SF Symbols.
        ]
      ]
    ],
  )
]

#slide(title: "2. Design System Landscape", outlined: true)[
  #v(0.2em)
  - Ngoài Material và Cupertino, thế giới UI/UX còn có các tiêu chuẩn lớn:
    - Fluent Design System (Microsoft): Trọng tâm vào ánh sáng (Light), chiều sâu (Depth), chất liệu bán trong suốt (Mica/Acrylic) và chuyển động mượt mà.
    - One UI (Samsung): Chia màn hình thành vùng hiển thị (Viewing Area ở trên) và vùng tương tác (Interaction Area ở nửa dưới) giúp thao tác bằng một tay.
    - Carbon Design (IBM) / Polaris (Shopify) / Ant Design (Alibaba): Các chuẩn mực thiết kế hàng đầu cho hệ thống quản trị dữ liệu lớn (Enterprise dashboards).
  - Điểm chung: Đều xây dựng trên hệ thống Design Tokens (màu sắc, khoảng cách lưới, phông chữ) để duy trì tính nhất quán trên diện rộng.
]

#slide(title: "3. Cross-Platform Challenge", outlined: true)[
  #v(0.2em)
  - Sự khác biệt thói quen người dùng (Platform Familiarity):
    - Người dùng Android quen thuộc với gợn sóng Ripple effect, nút hành động nổi FAB, thanh điều hướng đáy dạng viên thuốc.
    - Người dùng iOS kỳ vọng cử chỉ vuốt cạnh trái để lùi trang, hiệu ứng mờ kính phủ Frosted Glass và thanh điều hướng tinh gọn.
  - Mục tiêu kỹ thuật:
    - Cùng một codebase duy nhất nhưng giao diện phản ứng linh hoạt (Adaptive & Responsive).
    - Tối ưu hóa trải nghiệm tự nhiên, không mang lại cảm giác app web đóng gói hay ngoại lai.
]

#slide(title: "4. Visual Comparison", outlined: true)[
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

#slide(title: "5. Design Paradigms", outlined: true)[
  #v(0.2em)
  #align(center)[
    #table(
      columns: (1fr, 1.25fr, 1.25fr),
      inset: 7pt,
      align: (left, left, left),
      fill: (x, y) => if y == 0 { rgb("#ebf8ff") } else if calc.even(y) { rgb("#f7fafc") } else { none },
      table.header([*Tiêu chí*], [*Material Design 3 (M3)*], [*Cupertino (Apple HIG)*]),
      [Triết lý], [Cá nhân hóa, mô phỏng chất liệu giấy], [Tối giản: Clarity, Deference, Depth],
      [Hệ thống màu], [Dynamic Color sinh từ Seed Color], [CupertinoDynamicColor linh hoạt],
      [Phân tầng thị giác], [Cao độ (Elevation) & Bề mặt (Surface)], [Kính mờ (Backdrop Blur) & Đường kẻ viền],
      [Phản hồi chạm], [Hiệu ứng gợn sóng (Ripple / InkWell)], [Giảm độ mờ (Opacity 40%) & Haptic rung],
    )
  ]
]

#slide(title: "6. Buttons & Touch Targets", outlined: true)[
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
        - Độ cao tối thiểu $48 times 48$ dp.
        - Bo góc $12$ dp, hiệu ứng lan tỏa *InkWell*.
    ],
    [
      - *Cupertino Button Filled:*
        - Độ cao tối thiểu $44 times 44$ pt.
        - Bo góc $10$ pt, hiệu ứng giảm Opacity $40\%$.
    ],
  )
]

#slide(title: "7. Theme & Typography", outlined: true)[
  #v(0.2em)
  - *Material 3 Theme Data:*
    - Sử dụng `ColorScheme.fromSeed(seedColor: ...)` tự động tính 30+ sắc thái màu tương phản chuẩn WCAG.
    - Cung cấp thang đo 15 kiểu chữ quy chuẩn: `display`, `headline`, `title`, `body`, `label`.
  - *Cupertino Theme Data:*
    - Sử dụng `CupertinoThemeData` tập trung vào phông chữ San Francisco (SF Pro).
    - Hỗ trợ màu sắc thích ứng sáng/tối theo hệ điều hành (`resolveFrom(context)`).
  - *Hỗ trợ Dark Mode:*
    - Tách biệt `MaterialThemeConfig.lightTheme()` / `darkTheme()` và `CupertinoThemeConfig.themeData(brightness)`.
]

// =============================================================
// PHẦN 2: 4 TRỤ CỘT NGUYÊN TẮC UX
// =============================================================
#slide(title: "8. Core UX Pillars", outlined: true)[
  #v(0.1em)
  #align(center)[
    #raw-render(
      ```dot
      digraph UX {
        rankdir=LR;
        bgcolor="transparent";
        node [shape=box, style="filled,rounded", fontname="Arial", fontsize=13, margin="0.2,0.1"];
        edge [dir=both, color="#4a5568", penwidth=1.5];

        c [label="Tính Nhất Quán\n(Consistency)", fillcolor="#ebf8ff", color="#3182ce"];
        f [label="Phản Hồi Tương Tác\n(Feedback)", fillcolor="#feebc8", color="#dd6b20"];
        r [label="Khả Năng Đọc\n(Readability)", fillcolor="#c6f6d5", color="#38a169"];
        a [label="Khả Năng Tiếp Cận\n(Accessibility)", fillcolor="#e9d8fd", color="#805ad5"];

        c -> f;
        f -> a;
        a -> r;
        r -> c;
      }
      ```,
      width: 80%,
    )
  ]
  - Consistency: Đồng nhất hệ thống Spacing (Grid 8dp: 8, 16, 24, 32).
  - Feedback: Xác nhận tức thời thao tác chạm, không để màn hình "chết" khi gọi async.
  - Readability: Đảm bảo độ tương phản chữ/nền tối thiểu 4.5:1 (WCAG AA).
  - Accessibility: Kích thước vùng bấm tối thiểu $48 times 48$ dp (M3) hoặc $44 times 44$ pt (iOS).
]

#slide(title: "9. Consistency & Feedback", outlined: true)[
  #v(0.2em)
  - Tính nhất quán nội tại (Internal Consistency):
    - Quy chuẩn hóa toàn bộ khoảng cách lề và padding qua hằng số `AppTokens`.
    - Tránh việc đặt padding tùy hứng (13, 17, 21...) gây mất cân đối thị giác.
  - Phản hồi tương tác (Interactive Feedback):
    - Thao tác người dùng luôn có phản hồi thị giác trong vòng 100ms.
    - Tác vụ mạng hoặc xử lý ngầm (asynchronous) hiển thị `AdaptiveLoadingIndicator` và thông báo hoàn tất bằng `SnackBar` (Android) hoặc Card trạng thái (iOS).
]

#slide(title: "10. Readability & a11y", outlined: true)[
  #v(0.2em)
  - Phân cấp thị giác rõ ràng (Visual Hierarchy):
    - Tiêu đề cấp 1: Kích cỡ 18--22pt, Font weight: Bold.
    - Phụ đề cấp 2: Kích cỡ 14pt, Color độ mờ 70% hoặc Secondary label.
  - Accessibility (a11y) trong mã nguồn Flutter:
    - Sử dụng `Semantics(button: true, label: ...)` hỗ trợ TalkBack và VoiceOver.
    - Đảm bảo `SizedBox(height: 48)` cho nút bấm Material và 44 cho nút Cupertino để người dùng không bấm trượt.
    - Cung cấp thanh kéo điều chỉnh tỉ lệ font chữ ($80% - 140%$) ngay trong ứng dụng.
]

#slide(title: "11. UX Controls & Scaling", outlined: true)[
  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    align: center,
    [
      #align(center)[*Tùy chỉnh UX (Material 3 Slider)*]
      #v(0.1em)
      #align(center)[#image("material_settings.png", height: 75%)]
    ],
    [
      #align(center)[*Tùy chỉnh UX (Cupertino Slider)*]
      #v(0.1em)
      #align(center)[#image("cupertino_settings.png", height: 75%)]
    ],
  )
]

// =============================================================
// PHẦN 3: KIẾN TRÚC MÃ NGUỒN & THỰC HÀNH DEMO
// =============================================================
#slide(title: "12. System Architecture", outlined: true)[
  #v(0.1em)
  #align(center)[
    #raw-render(
      ```dot
      digraph Architecture {
        rankdir=LR;
        bgcolor="transparent";
        node [shape=box, style="filled,rounded", fontname="Arial", fontsize=12, margin="0.18,0.08"];
        edge [color="#2b6cb0", penwidth=1.5, fontname="Arial", fontsize=10];

        notifier [label="AppStateNotifier\n(Style & DarkMode)", fillcolor="#bee3f8", color="#2b6cb0"];
        root [label="Root App Builder\n(Material / Cupertino)", fillcolor="#fed7d7", color="#e53e3e"];
        home [label="HomeScreen\n(Scaffold / TabScaffold)", fillcolor="#c6f6d5", color="#38a169"];
        adaptive [label="Adaptive Widgets\n(Button, Dialog, Indicator)", fillcolor="#feebc8", color="#dd6b20"];

        notifier -> root [label="notifyListeners()"];
        root -> home [label="Rebuild Theme"];
        home -> adaptive [label="Inject Style"];
      }
      ```,
      width: 95%,
    )
  ]
  - Trạng thái được quản lý tập trung qua `AppStateNotifier` (`ChangeNotifier`), lắng nghe bởi root widget.
  - Tách biệt hoàn toàn Presentation Layer (`AdaptivePrimaryButton`, `AdaptiveDialog`) khỏi Business Logic Layer; tái sử dụng 100% logic xử lý async.
]

#slide(title: "13. Adaptive Button Code", outlined: true)[
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

#slide(title: "14. Adaptive Dialogs", outlined: true)[
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

#slide(title: "15. Automated Tests", outlined: true)[
  #v(0.2em)
  - *4 kịch bản kiểm thử tự động toàn diện (`flutter test`: ~3.2s, 0 warning):*
    - `Launch M3`: Xác thực Render Tree chứa `MaterialApp`, `AppBar`, `NavigationBar`.
    - `Hot-toggle Cupertino`: Chạm nút swap, xác thực chuyển đổi sang `CupertinoApp`, `CupertinoTabBar`.
    - `Assert Touch Target Bounds (a11y)`: Dùng `tester.getSize()` xác minh chiều cao nút:
      - Material FilledButton: $>= 48.0$ dp.
      - CupertinoButton: $>= 44.0$ pt.
    - `Text Scaling Slider`: Tương tác kéo slider $80% - 140%$ và kiểm tra font dynamic rebuild.
]

#slide(title: "16. Conclusion & Trade-offs", outlined: true)[
  #v(0.2em)
  - *Kết quả đạt được:*
    - Xây dựng hoàn chỉnh kiến trúc *DualStyle Hub* chuyển đổi mượt mà giữa Material 3 và Cupertino.
    - Áp dụng triệt để 4 trụ cột UX: Spacing Grid 8dp, phản hồi tương tác $<100$ms, độ tương phản WCAG AA $\ge 4.5:1$, vùng chạm an toàn a11y.
    - Kiểm thử tự động đạt 100% với 0 cảnh báo linter (`dart analyze: No issues found!`).
  - *Đánh giá Kỹ thuật & Trade-offs:*
    - *Full Adaptive UI* đem lại trải nghiệm nguyên bản (Native UX) tối đa nhưng tăng chi phí maintain (~1.5x boilerplate so với Unified UI).
    - Giải pháp tối ưu: Xây dựng tầng abstraction (`AdaptivePrimaryButton`, `AdaptiveDialog`) bọc lấy token thiết kế, cô lập logic rẽ nhánh khỏi màn hình nghiệp vụ.
]

#slide(title: "17. References", outlined: true)[
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
