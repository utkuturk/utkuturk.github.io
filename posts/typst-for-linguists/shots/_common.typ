// Shared helpers for the blog-post screenshots.
// Each shot file sets its own page size and imports from here.

#import "@preview/eggs:0.6.0": *
#import abbreviations: nom, acc, pst, q
#import "@preview/syntree:0.3.1": syntree, tree, listtree
#import "@preview/larrow:1.2.0": label-arrow, arrow-label
#import "@preview/lingotree:1.0.0": tree as ltree, render as lrender
#import "@preview/mannot:0.3.0": mark, annot-cetz
#import "@preview/cetz:0.4.2" as cetz

// ── semantics helpers (same ones the guide defines) ──
#let sem(x) = $lr(bracket.l.stroked #x bracket.r.stroked)$
#let semo(x) = $lr(bracket.l.stroked #x bracket.r.stroked)^o$
#let semf(x) = $lr(bracket.l.stroked #x bracket.r.stroked)^f$
#let lam(v, body) = $lambda #v . thin #body$
#let ty(..args) = {
  let a = args.pos()
  $chevron.l #a.join($, $) chevron.r$
}
#let jb(main, annot) = grid(
  columns: (1fr, auto),
  main,
  align(right, text(size: 9pt, fill: luma(100))[#annot]),
)
#let derivation(..steps) = {
  set par(first-line-indent: 0em)
  let cells = ()
  for step in steps.pos() {
    let (lhs, op, rhs, label) = step
    cells.push(align(right, lhs))
    cells.push(op)
    cells.push(rhs)
    cells.push(align(right, text(size: 9pt, fill: luma(100))[#label]))
  }
  block(inset: (left: 0em, y: 0.3em))[
    #grid(columns: (auto, auto, 1fr, auto),
      column-gutter: 0.4em, row-gutter: 0.45em, ..cells)
  ]
}

// ── phonology (phonokit) ──────────────────────────────
#import "@preview/phonokit:0.5.14": phonokit-init, ipa, feat, syllable, tableau
