#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[
  #syntree(
    nonterminal: (font: "Charis SIL"),
    terminal: (font: "Charis SIL", style: "italic"),
    child-spacing: 2em,
    layer-spacing: 2.3em,
  )[
    [S [NP [D the] [N linguist]] [VP [V runs]]]
  ]
]
