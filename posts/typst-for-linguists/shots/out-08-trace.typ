#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[_Which linguist did Mary meet?_

  #syntree(
    nonterminal: (font: "Charis SIL"),
    terminal: (font: "Charis SIL", style: "italic"),
    child-spacing: 1.8em,
    layer-spacing: 2.3em,
  )[
    [CP [#[DP#sub[i]] [D which] [N linguist]]
      [C′ [C did] [TP [DP Mary] [VP [V meet] [DP $t_i$]]]]]
  ]
]
