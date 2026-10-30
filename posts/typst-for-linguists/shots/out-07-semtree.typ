#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[
  #tree(
    [$t$ \ $"run"(m)$],
    tree([$e$ \ $m$], [_Mary_]),
    tree([$e -> t$ \ $lam("x", "run"("x"))$], [_runs_]),
  )
]
