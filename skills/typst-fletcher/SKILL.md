---
name: typst-fletcher
description: Design clear, modern, and mathematically sound diagrams, flowcharts, architectures, and state machines in Typst documents and slides using the Fletcher package (@preview/fletcher:0.5.8).
---

# Typst Fletcher Diagram Skill

Use this skill when designing architecture diagrams, state machines, sequence-like flows, and execution pipelines in Typst documents and Typslides presentations.

## 1. Import & Setup

```typ
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: diamond, pill, cylinder, hexagon
```

## 2. Core Concepts

Fletcher operates on a dynamic grid coordinate system `(col, row)`:
- `(0, 0)` is top-left.
- `col` increases to the right (`x`), `row` increases downward (`y`).
- Non-integer positions (e.g. `(1.5, 0)`) and relative/CeTZ expressions are supported.

### Sizing and Spacing
Always specify explicit spacing tuned to presentation slides:
```typ
#diagram(
  spacing: (32mm, 15mm), // (col-spacing, row-spacing)
  node-stroke: 1.2pt + rgb("#0284c7"),
  node-fill: rgb("#f0f9ff"),
  edge-stroke: 1.2pt + rgb("#0369a1"),
  node-corner-radius: 6pt,
  node-inset: 9pt,
  ...
)
```

## 3. Strict Audit Rules: Preventing Text Overlap in Presentations (CRITICAL)

### Font Inheritance Pitfall
In presentation packages like `typslides`, the slide body font size is usually large (`18pt`).
- If you do not explicitly scope `#text(size: 12pt)[...]` over the `#diagram(...)`, Fletcher inherits the `18pt` font for node contents, while coordinate calculations can cause text to overflow the node bounding boxes or bleed into neighboring edges and nodes!
- **Rule**: ALWAYS wrap presentation diagrams in:
  ```typ
  #align(center)[
    #text(size: 12pt)[
      #diagram(
        spacing: (35mm, 15mm),
        node-inset: 8pt,
        node-corner-radius: 6pt,
        ...
      )
    ]
  ]
  ```

### Node Widths and Multi-line Text
- Set explicit node widths (`width: 38mm` to `48mm`) according to text length.
- Use `#text(12pt, weight: "bold")[Title]` and `#text(10pt)[Subtitle]`.

### Edge Labels
- Valid `label-side` values in Fletcher 0.5.8 are: `left`, `right`, `center`, `auto` (Do **not** use `top` or `bottom`).
- Use `label-size: 10pt` or `11pt` to prevent edge labels from touching node borders.

## 4. Semantic Color Palette for Technical Presentations
- **Source / Producer**: `#fff5f5` (stroke: `#e53e3e`) - Light rose / red
- **Processing / Controller**: `#f0fff4` (stroke: `#38a169`) - Light green
- **Buffer / Queue**: `#ebf8ff` (stroke: `#2b6cb0`) - Light blue
- **Execution Thread / Core**: `#fefcbf` (stroke: `#d69e2e`) - Warm yellow
- **Consumer / UI Widget**: `#faf5ff` (stroke: `#805ad5`) - Light purple

## 5. Visual Audit Verification
After compiling with `typst compile`, always render pages to PNG with `pdftoppm -png -r 150 ...` and visually inspect using `read_file` to ensure:
1. No edge labels overlap node boundaries.
2. Padding (`node-inset: 8pt` to `10pt`) gives clear breathing room around text.
3. Node labels do not wrap awkwardly.
