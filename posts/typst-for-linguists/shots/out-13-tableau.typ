#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs
#phonokit-init(font: "Charis SIL")

#example[
  #tableau(
    input: "/kat+s/",
    candidates: ("kats", "kat", "katəs"),
    constraints: ("*Complex", "Max", "Dep"),
    violations: (
      ("*!", "", ""),
      ("", "*!", ""),
      ("", "", "*"),
    ),
    winner: 2,
  )
]
