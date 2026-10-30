#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[
  #lrender(
    ltree(
      tag: [TP],
      ltree(tag: [DP#sub[i]], mark(tag: <landing>)[Mary]),
      ltree(tag: [VP],
        ltree(tag: [DP], mark(tag: <trace>)[$t_i$]),
        ltree(tag: [V], [left]),
      ),
    ),
  )

  #annot-cetz(
    (<trace>, <landing>), cetz,
    {
      cetz.draw.line(
        "trace.south",
        "landing.south",
        stroke: (dash: "dashed"),
        mark: (end: "straight"),
      )
    },
  )
]
