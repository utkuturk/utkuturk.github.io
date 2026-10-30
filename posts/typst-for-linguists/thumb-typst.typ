// Standalone thumbnail: denotation brackets around a lambda, the two marks
// that say "formal semantics" at a glance. Bold enough to read at 82px.
// Build:  typst compile thumb-typst.typ thumb-typst.png --ppi 200
#set page(width: 10cm, height: 10cm, margin: 0pt, fill: white)
#set text(font: "Charis SIL")

#align(center + horizon)[
  #move(dy: -9pt, text(size: 145pt, fill: luma(15))[
    $lr(bracket.l.stroked thin lambda thin bracket.r.stroked)$
  ])
]
