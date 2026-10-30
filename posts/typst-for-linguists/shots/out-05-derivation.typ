#import "_common.typ": *
#set page(width: 12cm, height: auto, margin: 8pt, fill: white)
#set text(font: "Charis SIL", size: 11pt)
#show: eggs

#example[$sem("Mary loves John")$

  #derivation(
    ($sem("loves John")$, $=$,
     $(lam("y", lam("x", "love"("x","y"))))(j)$, [by FA]),
    ([], $=>_beta$,
     $lam("x", "love"("x", j))$, [by $beta$-red.]),
    ($sem("Mary loves John")$, $=$,
     $(lam("x", "love"("x", j)))(m)$, [by FA]),
    ([], $=>_beta$,
     $"love"(m, j)$, [by $beta$-red.]),
  )
]
