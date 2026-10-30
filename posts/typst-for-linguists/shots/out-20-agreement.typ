#import "_common.typ": *
#set page(width: 13cm, height: 6.6cm, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#let dependency(from, to, label, depth: 18) = label-arrow(
  from, to, tip: "o", from-tip: "o",
  stroke: (thickness: 0.6pt, dash: "dashed"),
  bend: ((f, t) => {
    let y = calc.min(f.at(1), t.at(1)) - depth
    ((f.at(0), y), (t.at(0), y))
  }),
  caption: text(8pt)[#smallcaps(label)],
  caption-options: (frame: none, padding: 3pt, anchor: "north"),
)

#let phi = text(9pt)[$mat(delim: "[",
  "case:", std.smallcaps("nom");
  "pers:", "3";
  "num:", std.smallcaps("sg"))$]

#example[
  #syntree(
    nonterminal: (font: "Charis SIL"),
    terminal: (font: "Charis SIL", style: "italic"),
    child-spacing: 1.6em,
  )[
    [S [NP [D the] [N #box[#stack(spacing: 0.4em, [linguist], phi)] <subj>]]
      [VP [V #box[walks] <verb>] [NP [D her] [N dog]]]]
  ]
]

#dependency(<subj>, <verb>, [subject–verb agreement], depth: 26)
