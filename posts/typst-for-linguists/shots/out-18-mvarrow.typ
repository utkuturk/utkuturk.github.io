#import "_common.typ": *
#set page(width: 13cm, height: 1.9cm, margin: 10pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#let bracket-arrow(from, to, label, depth: 16pt) = label-arrow(
  from, to, tip: ">",
  bend: ((f, t) => (
    (f.at(0), f.at(1) - depth.pt()),
    (t.at(0), t.at(1) - depth.pt()),
  )),
  caption: text(8pt)[#label],
)

#example[
  What#arrow-label(<landing>, dy: -3pt) did a famous linguist
  meet #strike[which linguist]#arrow-label(<trace>, dy: -3pt)?
]

#bracket-arrow(<trace>, <landing>, [_wh_-movement])
