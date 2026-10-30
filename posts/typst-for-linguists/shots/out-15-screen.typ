#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)

#let scale-box(n) = block(
  width: 1.6em, height: 1.6em,
  stroke: 0.5pt + luma(150), radius: 2pt,
)[#align(center + horizon)[#text(9pt)[#n]]]

#block(width: 100%, stroke: 0.6pt + luma(150), radius: 3pt)[
  #block(
    width: 100%, fill: luma(242), inset: (x: 0.8em, y: 0.45em),
    stroke: (bottom: 0.5pt + luma(205)),
  )[#text(8.5pt, fill: luma(95))[Acceptability judgments, trial 14 of 96]]

  #block(width: 100%, inset: 1.3em)[
    #align(center)[
      #text(13pt)[The key to the cabinets were rusty.]
      #v(1.1em)
      #text(9pt, fill: luma(110))[How natural does this sentence sound?]
      #v(0.6em)
      #grid(
        columns: (auto,) * 7, column-gutter: 0.45em,
        ..range(1, 8).map(n => scale-box(n)),
      )
      #v(0.35em)
      #grid(
        columns: (auto, 1fr, auto), column-gutter: 0.5em,
        text(7.5pt, fill: luma(130))[completely unnatural],
        [],
        text(7.5pt, fill: luma(130))[perfectly natural],
      )
    ]
  ]
]
