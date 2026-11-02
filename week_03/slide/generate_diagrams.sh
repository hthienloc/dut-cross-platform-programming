#!/bin/bash
dot -Tsvg -o week_03/slide/widget_tree.svg << 'DOT'
digraph WidgetTree {
  rankdir=LR;
  bgcolor="transparent";
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=12, margin="0.2,0.12"];
  edge [color="#4a5568", penwidth=1.5, fontname="Arial", fontsize=10];

  widget [label="Widget (UI Spec)\nImmutable Config", fillcolor="#ebf8ff", color="#3182ce"];
  element [label="Element (Lifecycle)\nBuildContext Tree", fillcolor="#feebc8", color="#dd6b20"];
  render [label="RenderObject (Layout)\nPaint & Hit Test", fillcolor="#c6f6d5", color="#38a169"];

  widget -> element [label="createElement()"];
  element -> render [label="createRenderObject()"];
}
DOT

dot -Tsvg -o week_03/slide/scaffold_structure.svg << 'DOT'
digraph ScaffoldCompare {
  rankdir=LR;
  bgcolor="transparent";
  nodesep=0.15;
  ranksep=0.25;
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=10, margin="0.1,0.05"];
  edge [color="#4a5568", penwidth=1.2, fontname="Arial", fontsize=9];

  subgraph cluster_m3 {
    label="Material Design 3 (M3)";
    fontname="Arial Bold";
    fontsize=11;
    color="#2b6cb0";
    style="filled,rounded";
    fillcolor="#ebf8ff";

    m_scaffold [label="Scaffold\n(Global Page)", fillcolor="#bee3f8", color="#2b6cb0"];
    m_appbar [label="appBar: AppBar", fillcolor="#ffffff", color="#3182ce"];
    m_body [label="body: CustomScrollView", fillcolor="#ffffff", color="#3182ce"];
    m_nav [label="bottomNavigationBar: NavigationBar", fillcolor="#ffffff", color="#3182ce"];

    m_scaffold -> m_appbar;
    m_scaffold -> m_body;
    m_scaffold -> m_nav;
  }

  subgraph cluster_cup {
    label="Cupertino (Apple HIG)";
    fontname="Arial Bold";
    fontsize=11;
    color="#2f855a";
    style="filled,rounded";
    fillcolor="#f0fff4";

    c_scaffold [label="CupertinoTabScaffold\n(Root Tab Manager)", fillcolor="#c6f6d5", color="#2f855a"];
    c_tabbar [label="tabBar: CupertinoTabBar", fillcolor="#ffffff", color="#38a169"];
    c_tabbuilder [label="tabBuilder: CupertinoPageScaffold", fillcolor="#ffffff", color="#38a169"];
    c_nav [label="navigationBar: CupertinoNavigationBar", fillcolor="#ffffff", color="#38a169"];

    c_scaffold -> c_tabbar;
    c_scaffold -> c_tabbuilder;
    c_tabbuilder -> c_nav;
  }
}
DOT

dot -Tsvg -o week_03/slide/system_architecture.svg << 'DOT'
digraph Architecture {
  rankdir=LR;
  bgcolor="transparent";
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=11, margin="0.16,0.07"];
  edge [color="#2b6cb0", penwidth=1.5, fontname="Arial", fontsize=10];

  notifier [label="AppStateNotifier\n(Style & DarkMode)", fillcolor="#bee3f8", color="#2b6cb0"];
  root [label="Root App Builder\n(Material / Cupertino)", fillcolor="#fed7d7", color="#e53e3e"];
  home [label="HomeScreen\n(Scaffold / TabScaffold)", fillcolor="#c6f6d5", color="#38a169"];
  adaptive [label="Adaptive Widgets\n(Button, Dialog, Indicator)", fillcolor="#feebc8", color="#dd6b20"];

  notifier -> root [label="notifyListeners()"];
  root -> home [label="Rebuild Theme"];
  home -> adaptive [label="Inject Style"];
}
DOT

dot -Tsvg -o week_03/slide/ux_pillars.svg << 'DOT'
digraph UX {
  rankdir=LR;
  bgcolor="transparent";
  node [shape=box, style="filled,rounded", fontname="Arial", fontsize=12, margin="0.16,0.08"];
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
DOT
