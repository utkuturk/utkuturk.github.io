#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)

#let frame(body) = block(
  width: 3cm, height: 1.9cm,
  stroke: 0.5pt + luma(140), radius: 2pt, inset: 6pt,
)[#align(center + horizon)[#body]]

#let step(body, dur) = stack(
  spacing: 0.45em,
  frame(body),
  align(center, text(8pt, fill: luma(110))[#dur]),
)

#let arrow = align(horizon, text(13pt, fill: luma(160))[#sym.arrow.r])

#grid(
  columns: (auto,) * 5,
  column-gutter: 0.7em,
  align: top,
  step([$+$], [500 ms]),
  arrow,
  step([_The key to the cabinets_], [self-paced]),
  arrow,
  step([Was the key rusty?], [until response]),
)
