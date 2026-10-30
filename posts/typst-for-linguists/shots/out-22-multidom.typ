#import "_common.typ": *
#set page(width: 13cm, height: 6.8cm, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[
  #syntree(
    nonterminal: (font: "Charis SIL"),
    terminal: (font: "Charis SIL", style: "italic"),
    child-spacing: 1.6em,
  )[
    [ConjP
      [S [^NP Sebastián] [#box[VP]<shared> [V loves]]]
      [Conj′ [Conj but]
        [S [^NP Mal] [VP [V hates] [#box[NP]<obj> birds]]]]]
  ]
]

#label-arrow(<shared>, <obj>, tip: none, bend: -18,
  stroke: 0.75pt,
  from-offset: (0pt, -7pt), to-offset: (0pt, 7pt))
