#!/bin/bash
set -e

mkdir -p week_04/slide/diagrams

# 1. Architecture 4-Layer Diagram
dot -Tsvg -o week_04/slide/diagrams/animation_architecture.svg << 'DOT'
digraph AnimationArch {
  rankdir=TB;
  bgcolor="transparent";
  nodesep=0.2;
  ranksep=0.25;
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=11, margin="0.16,0.08"];
  edge [color="#4a5568", penwidth=1.4, fontname="Arial", fontsize=10];

  subgraph cluster_widgets {
    label="TẦNG WIDGETS (KHỞI TẠO)";
    fontname="Arial Bold";
    fontsize=11;
    color="#2b6cb0";
    style="filled,rounded";
    fillcolor="#ebf8ff";

    w_implicit [label="Implicit Widgets\n(AnimatedContainer, Opacity)", fillcolor="#bee3f8", color="#2b6cb0"];
    w_explicit [label="Explicit Widgets\n(Transition Widgets, AnimatedBuilder)", fillcolor="#fed7d7", color="#e53e3e"];
  }

  subgraph cluster_engine {
    label="TẦNG ĐIỀU KHIỂN & NỘI SUY";
    fontname="Arial Bold";
    fontsize=11;
    color="#2f855a";
    style="filled,rounded";
    fillcolor="#f0fff4";

    c_tween [label="Tween<T> & Curves\n(Ánh xạ 0.0 -> 1.0 sang giá trị thực)", fillcolor="#ffffff", color="#38a169"];
    c_controller [label="AnimationController\n(Quản lý tiến trình & thời lượng)", fillcolor="#ffffff", color="#38a169"];
  }

  subgraph cluster_hardware {
    label="TẦNG PHẦN CỨNG & RENDER LAYER";
    fontname="Arial Bold";
    fontsize=11;
    color="#805ad5";
    style="filled,rounded";
    fillcolor="#faf5ff";

    h_ticker [label="Ticker & Vsync\n(Đồng bộ xung nhịp GPU 60/120Hz)", fillcolor="#e9d8fd", color="#805ad5"];
    h_gpu [label="GPU Render Pipeline\n(Chỉ vẽ Transform Layer, không rebuild Widget)", fillcolor="#ffffff", color="#805ad5"];
  }

  w_implicit -> c_tween [label="Tự quản lý"];
  w_explicit -> c_controller [label="Điều khiển trực tiếp"];
  c_controller -> c_tween;
  c_controller -> h_ticker [label="vsync: this"];
  c_tween -> h_gpu;
}
DOT

# 2. Implicit vs Explicit Comparison Matrix Diagram
dot -Tsvg -o week_04/slide/diagrams/implicit_explicit_matrix.svg << 'DOT'
digraph Matrix {
  rankdir=LR;
  bgcolor="transparent";
  nodesep=0.25;
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=11, margin="0.18,0.1"];
  edge [color="#4a5568", penwidth=1.5, fontname="Arial", fontsize=10];

  subgraph cluster_imp {
    label="IMPLICIT (DECLARATIVE)";
    fontname="Arial Bold";
    fontsize=12;
    color="#2b6cb0";
    style="filled,rounded";
    fillcolor="#ebf8ff";

    i1 [label="Chỉ cần truyền Target Value & Duration", fillcolor="#ffffff", color="#3182ce"];
    i2 [label="Framework tự quản lý Controller ngầm", fillcolor="#ffffff", color="#3182ce"];
    i3 [label="ZERO Memory Leak (Tự giải phóng 100%)", fillcolor="#c6f6d5", color="#38a169"];
    i1 -> i2 -> i3;
  }

  subgraph cluster_exp {
    label="EXPLICIT (IMPERATIVE)";
    fontname="Arial Bold";
    fontsize=12;
    color="#e53e3e";
    style="filled,rounded";
    fillcolor="#fff5f5";

    e1 [label="Khởi tạo thủ công AnimationController", fillcolor="#ffffff", color="#e53e3e"];
    e2 [label="Toàn quyền: forward, reverse, repeat, spring", fillcolor="#ffffff", color="#e53e3e"];
    e3 [label="BẮT BUỘC dispose() trước super.dispose()", fillcolor="#fed7d7", color="#e53e3e"];
    e1 -> e2 -> e3;
  }
}
DOT

# 3. Explicit Lifecycle & Vsync Strong Reference
dot -Tsvg -o week_04/slide/diagrams/controller_lifecycle.svg << 'DOT'
digraph Lifecycle {
  rankdir=LR;
  bgcolor="transparent";
  nodesep=0.2;
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=11, margin="0.18,0.1"];
  edge [color="#4a5568", penwidth=1.5, fontname="Arial", fontsize=10];

  state [label="State Object\nwith SingleTickerProvider", fillcolor="#ebf8ff", color="#3182ce"];
  ticker [label="Ticker Instance\n(Vsync Listener)", fillcolor="#feebc8", color="#dd6b20"];
  controller [label="AnimationController\n(Active Ref)", fillcolor="#fed7d7", color="#e53e3e"];
  safe_dispose [label="1. controller.dispose()\n2. super.dispose()", fillcolor="#c6f6d5", color="#38a169"];

  state -> ticker [label="createTicker()"];
  ticker -> controller [label="Strong Ref"];
  controller -> safe_dispose [label="Ngắt kết nối"];
}
DOT

# 4. Gesture Arena Resolution Flow
dot -Tsvg -o week_04/slide/diagrams/gesture_arena.svg << 'DOT'
digraph Arena {
  rankdir=LR;
  bgcolor="transparent";
  nodesep=0.15;
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=11, margin="0.16,0.08"];
  edge [color="#4a5568", penwidth=1.4, fontname="Arial", fontsize=10];

  pointer [label="PointerDown\n(Hit-testing)", fillcolor="#ebf8ff", color="#3182ce"];
  arena [label="Gesture Arena\n(Tap, Horizontal, Vertical)", fillcolor="#feebc8", color="#dd6b20"];
  slop [label="Touch Slop (> 18dp)\nTrajectory Check", fillcolor="#faf5ff", color="#805ad5"];
  win [label="1. Self-elimination\n2. Declare Winner\n3. Last-Man-Standing", fillcolor="#c6f6d5", color="#38a169"];

  pointer -> arena [label="Register"];
  arena -> slop [label="Finger moves"];
  slop -> win [label="Disambiguation"];
}
DOT

# 5. UX Motion Timeline & Thresholds
dot -Tsvg -o week_04/slide/diagrams/ux_motion_timeline.svg << 'DOT'
digraph UXMotion {
  rankdir=LR;
  bgcolor="transparent";
  nodesep=0.15;
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=11, margin="0.16,0.08"];
  edge [color="#4a5568", penwidth=1.5, fontname="Arial", fontsize=10];

  t1 [label="< 100ms\nPhản hồi xúc giác\n(Instant Touch Feedback)", fillcolor="#c6f6d5", color="#38a169"];
  t2 [label="150ms - 350ms\nChuyển cảnh tối ưu\n(Smooth Transition)", fillcolor="#ebf8ff", color="#3182ce"];
  t3 [label="> 500ms\nNgưỡng gây ức chế\n(Perceived Delay)", fillcolor="#fed7d7", color="#e53e3e"];

  t1 -> t2 [label="Natural Easing"];
  t2 -> t3 [label="Tránh dùng"];
}
DOT

# 6. Engineering Decision Tree
dot -Tsvg -o week_04/slide/diagrams/decision_tree.svg << 'DOT'
digraph Decision {
  rankdir=TB;
  bgcolor="transparent";
  nodesep=0.2;
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=11, margin="0.16,0.08"];
  edge [color="#4a5568", penwidth=1.4, fontname="Arial", fontsize=10];

  q1 [label="Nhu cầu tạo chuyển động?", fillcolor="#ebf8ff", color="#3182ce"];
  q2 [label="Có cần lặp / đảo chiều /\ngắn kết cử chỉ kéo thả?", fillcolor="#feebc8", color="#dd6b20"];
  ans_imp [label="CHỌN IMPLICIT ANIMATION\n- AnimatedContainer\n- Zero Memory Leak, cực nhanh", fillcolor="#c6f6d5", color="#38a169"];
  ans_exp [label="CHỌN EXPLICIT ANIMATION\n- AnimationController + Ticker\n- Bắt buộc quản lý dispose()", fillcolor="#fed7d7", color="#e53e3e"];

  q1 -> q2;
  q2 -> ans_imp [label="Không"];
  q2 -> ans_exp [label="Có"];
}
DOT

echo "All SVG diagrams generated successfully!"
