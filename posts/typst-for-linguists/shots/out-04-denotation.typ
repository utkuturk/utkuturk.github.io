#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[
  $sem("every") = lam("P", lam("Q", forall x ["P"(x) -> "Q"(x)]))$ \
  $sem("runs") : ty(e, t)$
]
