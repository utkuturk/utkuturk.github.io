#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: (x: 8pt, top: 8pt, bottom: 20pt), fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[
  #lrender(
    ltree(
      tag: [CP],
      ltree(tag: [DP#sub[i]], mark(tag: <landing>)[which linguist]),
      ltree(tag: [C'],
        ltree(tag: [C], [did]),
        ltree(tag: [TP],
          ltree(tag: [DP], [Mary]),
          ltree(tag: [VP],
            ltree(tag: [V], [meet]),
            ltree(tag: [DP], mark(tag: <trace>)[$t_i$]),
          ),
        ),
      ),
    ),
  )

  #annot-cetz(
    (<trace>, <landing>), cetz,
    {
      cetz.draw.bezier-through(
        "trace.south",
        (rel: (x: -1.6, y: -0.55)),
        "landing.south",
        stroke: (dash: "dashed"),
        mark: (end: "straight"),
      )
    },
  )
]
