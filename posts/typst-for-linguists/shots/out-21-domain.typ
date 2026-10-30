#import "_common.typ": *
#set page(width: 13cm, height: 5.7cm, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[
  #syntree(
    nonterminal: (font: "Charis SIL"),
    terminal: (font: "Charis SIL", style: "italic"),
    child-spacing: 1.6em,
  )[
    [S [NP [D the] [N dog]]
      [VP [#box[V]<v> barked] [#box[NP]<obj> [D the] [N mailman]]]]
  ]
]

#label-arrow(<v>, <obj>, tip: none, bend: -34,
  stroke: (thickness: 0.6pt, dash: "dashed"),
  from-offset: (30pt, 6pt), to-offset: (48pt, 6pt),
  caption: text(8pt)[cyclic domain], caption-position: "end",
  caption-options: (frame: none, padding: 5pt, anchor: "west"))
