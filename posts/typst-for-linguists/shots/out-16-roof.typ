#import "_common.typ": *
#set page(width: 13cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[
  #grid(columns: (auto, auto), column-gutter: 2.5em, align: bottom,
    syntree(child-spacing: 1.6em)[
      [S [NP [D the] [N linguist]] [^VP likes typst a lot]]
    ],
    tree([S],
      tree([NP], tree([D], [the]), tree([N], [linguist])),
      tree([VP], [likes typst a lot], roof: true),
      child-spacing: 1.6em,
    ),
  )
]
