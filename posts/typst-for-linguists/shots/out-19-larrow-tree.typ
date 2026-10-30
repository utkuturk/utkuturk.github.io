#import "_common.typ": *
#set page(width: 13cm, height: 6.6cm, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[
  #syntree(
    nonterminal: (font: "Charis SIL"),
    terminal: (font: "Charis SIL", style: "italic"),
    child-spacing: 1.8em,
    layer-spacing: 2.3em,
  )[
    [CP [#[DP#sub[i]] [D which] [N #box[linguist] <landing>]]
      [C′ [C did] [TP [DP Mary] [VP [V meet]
        [DP #box[$t_i$] <trace>]]]]]
  ]
]

#label-arrow(<trace>, <landing>, bend: -55, tip: ">",
  stroke: (thickness: 0.6pt, dash: "dashed"),
  caption: text(8pt)[_wh_-movement])
