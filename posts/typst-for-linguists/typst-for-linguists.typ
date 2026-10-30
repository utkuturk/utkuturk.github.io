// ══════════════════════════════════════════════════════════════
//  Typst for Linguists — Formal Semantics Edition
//  Author: Utku Turk
// ══════════════════════════════════════════════════════════════

#set document(
  title: "Typst for Linguists: Formal Semantics Edition",
  author: "Utku Turk",
)

#set page(
  paper: "us-letter",
  margin: (x: 1in, y: 0.9in),
  numbering: "1",
  number-align: center,
  header: context {
    if counter(page).get().first() > 1 {
      set text(8.5pt, fill: luma(120))
      grid(
        columns: (1fr, 1fr),
        align(left)[Typst for Linguists],
        align(right)[Utku Turk],
      )
      line(length: 100%, stroke: 0.3pt + luma(180))
    }
  },
)

#set text(
  font: "Charis SIL",
  size: 10.5pt,
  lang: "en",
)

#set par(
  justify: true,
  leading: 0.6em,
  first-line-indent: 1em,
)

#set heading(numbering: "1.1")

#show heading: it => {
  set par(first-line-indent: 0em)
  v(0.45em)
  it
  v(0.2em)
}

// ── Package imports ───────────────────────────────────
#import "@preview/eggs:0.6.0": *
#import abbreviations: nom, acc, pst, q
#show: eggs

#import "@preview/syntree:0.2.1": syntree, tree
#import "@preview/lingotree:1.0.0": tree as ltree, render as lrender
#import "@preview/mannot:0.3.0": mark, annot-cetz
#import "@preview/cetz:0.4.2" as cetz

// ── Code display ──────────────────────────────────────
#show raw.where(block: true): it => {
  set par(first-line-indent: 0em)
  block(
    width: 100%,
    fill: luma(247),
    stroke: (left: 2.5pt + luma(190)),
    inset: (x: 0.8em, y: 0.5em),
    radius: 2pt,
    text(size: 8.4pt, it),
  )
}

#show raw.where(block: false): it => {
  box(
    fill: luma(245),
    inset: (x: 0.2em, y: 0.12em),
    radius: 2pt,
    text(size: 8.9pt, it),
  )
}

// ── Code then output demos ───────────────────────────
#let demo(rendered, code) = {
  set par(first-line-indent: 0em)
  text(8pt, weight: "bold", fill: luma(120))[Code]
  v(0.2em)
  code
  v(0.45em)
  text(8pt, weight: "bold", fill: luma(120))[Output]
  v(0.2em)
  block(
    width: 100%,
    stroke: 0.4pt + luma(210),
    inset: (x: 0.7em, y: 0.55em),
    radius: 2pt,
  )[#rendered]
}

// ── Tip box ───────────────────────────────────────────
#let tip(body) = block(
  width: 100%,
  fill: rgb("#f0f7ff"),
  stroke: (left: 2.5pt + rgb("#4a90d9")),
  inset: (x: 0.8em, y: 0.5em),
  radius: 2pt,
)[
  #set par(first-line-indent: 0em)
  *Tip:* #body
]

// ── Warning box ───────────────────────────────────────
#let warning(body) = block(
  width: 100%,
  fill: rgb("#fff8f0"),
  stroke: (left: 2.5pt + rgb("#d97a4a")),
  inset: (x: 0.8em, y: 0.5em),
  radius: 2pt,
)[
  #set par(first-line-indent: 0em)
  *Warning:* #body
]

// ══════════════════════════════════════════════════════
//  SEMANTIC HELPERS
// ══════════════════════════════════════════════════════

// Denotation brackets ⟦ · ⟧
// bracket.l.double / bracket.r.double are DEPRECATED.
// Use bracket.l.stroked / bracket.r.stroked.
#let sem(x) = $lr(bracket.l.stroked #x bracket.r.stroked)$
#let semo(x) = $lr(bracket.l.stroked #x bracket.r.stroked)^o$
#let semf(x) = $lr(bracket.l.stroked #x bracket.r.stroked)^f$

// Lambda shorthand
#let lam(v, body) = $lambda #v . thin #body$

// Angle-bracket types: #ty(e, t) → ⟨e, t⟩
#let ty(..args) = {
  let a = args.pos()
  $chevron.l #a.join($, $) chevron.r$
}

// ── Citation helpers ──────────────────────────────────
// Author (Year) — like \citet
#let narr(key) = cite(key, form: "prose")
// Author's (Year) — like \citeauthor's \citeyearpar
#let gen(key) = {
  cite(key, form: "author")
  [\u{2019}s ]
  cite(key, form: "year")
}

// ── Jambox: right-aligned annotation ──────────────────
#let jb(main, annot) = grid(
  columns: (1fr, auto),
  main,
  align(right, text(size: 9pt, fill: luma(100))[#annot]),
)

// ── Derivation with rule labels ───────────────────────
// 4-column grid: LHS (right-aligned), operator, RHS, label.
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
    #grid(
      columns: (auto, auto, 1fr, auto),
      column-gutter: 0.4em,
      row-gutter: 0.45em,
      ..cells,
    )
  ]
}


// ════════════════════════════════════════════════════════════
//  TITLE
// ════════════════════════════════════════════════════════════

#set par(first-line-indent: 0em)

#align(center)[
  #text(8.5pt, fill: luma(130), tracking: 2pt)[TYPST FOR LINGUISTS]
  #v(0.3em)
  #text(18pt, weight: "bold")[
    Typesetting Formal Semantics in Typst
  ]
  #v(0.2em)
  #text(12pt, style: "italic", fill: luma(80))[
    A Guide from Document Basics to Lambda Calculus
  ]
  #v(0.5em)
  #line(length: 35%, stroke: 0.4pt + luma(160))
  #v(0.3em)
  #text(10.5pt)[Utku Turk]
  #v(0.1em)
  #text(9.5pt, fill: luma(120))[University of Maryland, College Park]
  #v(0.5em)
]

#line(length: 100%, stroke: 0.4pt)
#v(0.5em)

#set par(first-line-indent: 1em)


// ════════════════════════════════════════════════════════════
//  BODY
// ════════════════════════════════════════════════════════════

= Why Typst? <sec:why>

If you have used LaTeX, you know the loop: edit, compile, wait, check
the PDF, fix one thing, compile again. Typst is much faster in actual
use because the preview updates incrementally while you type. For a
semantics paper with trees, glosses, and derivations, that matters.

The second advantage is that Typst reads more like code you actually
want to maintain. Instead of piling macros into a preamble, you can
write small functions for repeated jobs: semantic brackets, citation
helpers, jamboxes, derivation layouts, or different header behavior on
page 1 versus later pages.

For example, this document's header logic is ordinary Typst code:

#demo(
  [Pages after the first get a running header; page 1 does not.],
  ```typst
  #set page(
    header: context {
      if counter(page).get().first() > 1 {
        grid(
          columns: (1fr, 1fr),
          align(left)[Typst for Linguists],
          align(right)[Utku Turk],
        )
      }
    },
  )
  ```
)

The syntax is also more transparent. Where LaTeX needs
`\textbf{bold}`, Typst uses `*bold*`. Where LaTeX needs
`\begin{itemize} \item ... \end{itemize}`, Typst uses `- item`. If you
can read `#text(size: 14pt)[Hello]`, you already understand the basic
shape of the language.

The ecosystem is younger, so some linguistics workflows still need
manual setup. That is what this guide is for.


= Typst Basics <sec:basics>

== Document Metadata, Pages, and Fonts

#demo(
  [
    *My Paper*\
    Your Name
  ],
  ```typst
  #set document(title: "My Paper", author: "Your Name")
  #set page(paper: "us-letter", margin: (x: 1in, y: 1in))
  #set text(font: "Charis SIL", size: 11pt, lang: "en")
  #set par(justify: true, first-line-indent: 1.2em, leading: 0.65em)
  #set heading(numbering: "1.1")
  ```
)

Other page options: `"a4"`, per-side margins with
`margin: (top: 1in, bottom: 1in, left: 1.5in, right: 1in)`.

== Headings

`= Top-Level`, `== Second Level`, `=== Third Level`. Add numbering
with `#set heading(numbering: "1.1")`.

== Inline Formatting

`*bold*` → *bold*, `_italic_` → _italic_,
`#underline[text]` → #underline[text],
`#strike[text]` → #strike[text],
`#smallcaps[text]` → #smallcaps[text].
Lists: `-` for bullets, `+` for numbered.

== Figures and Tables

Reference with `@tab:types`. This produces @tab:types:

#demo(
  [
    #figure(
      table(
        columns: (auto, auto, auto),
        align: (left, left, left),
        stroke: none,
        inset: 5pt,
        table.header[*Expression*][*Type*][*Gloss*],
        table.hline(stroke: 0.4pt),
        [_Mary_],   [$e$],                              [individual],
        [_runs_],   [$e -> t$],                         [one-place predicate],
        [_loves_],  [$e -> (e -> t)$],                  [two-place relation],
        [_every_],  [$(e -> t) -> ((e -> t) -> t)$],    [GQ det],
      ),
      caption: [Lexical types for selected English expressions.],
    ) <tab:types>
  ],
  ```typst
  #figure(
    table(
      columns: (auto, auto, auto),
      align: (left, left, left),
      stroke: none,
      inset: 5pt,
      table.header[*Expression*][*Type*][*Gloss*],
      table.hline(stroke: 0.4pt),
      [_Mary_],   [$e$],                              [individual],
      [_runs_],   [$e -> t$],                         [one-place predicate],
      [_loves_],  [$e -> (e -> t)$],                  [two-place relation],
      [_every_],  [$(e -> t) -> ((e -> t) -> t)$],    [GQ det],
    ),
    caption: [Lexical types for selected English expressions.],
  ) <tab:types>
  ```
)

== Boxes and Colored Boxes

A framed box: `#block(stroke: 0.5pt, inset: 1em, radius: 3pt)[...]`:

#demo(
  [
    #block(
      width: 100%, stroke: 0.5pt + luma(120),
      inset: 1em, radius: 3pt,
    )[Content here.]

    #v(0.7em)
    #tip[Wrap the pattern in a function and reuse it.]
  ],
  ```typst
  #block(
    width: 100%, stroke: 0.5pt + luma(120),
    inset: 1em, radius: 3pt,
  )[Content here.]

  #let tip(body) = block(
    fill: rgb("#f0f7ff"),
    stroke: (left: 3pt + rgb("#4a90d9")),
    inset: (x: 1em, y: 0.7em), radius: 2pt,
  )[*Tip:* #body]
  ```
)

== Cross-References and Bibliography

Label with `<label>` after any heading, figure, or example. Reference
with `@label`. For bibliography:

```typst
#bibliography("refs.bib", style: "chicago-author-date")
```

Cite with `@citekey` for parenthetical or
`#cite(<citekey>, form: "prose")` for "Author (Year)". Rather than
typing `form: "prose"` every time, define short helpers:

```typst
// Author (Year) — like \citet or \textcite
#let narr(key) = cite(key, form: "prose")

// Author's (Year) — like \citeauthor's \citeyearpar
#let gen(key) = {
  cite(key, form: "author")
  [\u{2019}s ]
  cite(key, form: "year")
}
```

Then `#narr(<rooth1992>)` gives "Rooth (1992)" and
`#gen(<atlamaz2023>)` gives "Atlamaz's (2023)".


= Linguistic Examples with `eggs` <sec:examples>

The `eggs` package handles numbered examples, sub-examples,
grammaticality judgments, glossing, and cross-referencing. Import it
and apply the show rule at the top of your file:

```typst
#import "@preview/eggs:0.6.0": *
#import abbreviations: nom, acc, pst, q
#show: eggs
```

== Basic Examples

Inside `#example[...]`, content is a single example. Numbered lists
(`+`) become sub-examples automatically:

#demo(
  [
    #example[
      + Heidi ate the döner.
      + Heidi ate the D#smallcaps[öner]#sub[F].
      #ex-label(<donerpair>)
    ]
  ],
  ```typst
  #example[
    + Heidi ate the döner.
    + Heidi ate the D#smallcaps[öner]#sub[F].
    #ex-label(<donerpair>)
  ]
  ```
)

== Grammaticality Judgments

Prefix sub-examples with `\*`, `\#`, `\?`, or `\%` and `eggs` handles
them automatically, pulling the judge mark into the left margin:

#demo(
  [
    #example[
      + Heidi ate the döner.
      + \*Ate Heidi döner the.
      + \#Heidi ate the döner, but I don't care if Bill ate it.
      + \?The döner Heidi ate.
      + \%Heidi the döner ate.
    ]
  ],
  ```typst
  #example[
    + Heidi ate the döner.
    + \*Ate Heidi döner the.
    + \#Heidi ate the döner, but I don't care if Bill ate it.
    + \?The döner Heidi ate.
    + \%Heidi the döner ate.
  ]
  ```
)

For custom judgments (e.g., `??` or `#?`), use `#judge[??]` inside the
sub-example.

== Cross-Referencing Examples

Label with `#ex-label(<name>)` inside the example. Reference with
`@name` or for more control use `#ex-ref()`:

```typst
#ex-ref(<donerpair>)                    // (1)
@donerpair                              // (1)
#ex-ref(<donerpair:a>)                  // (1a)
#ex-ref(<donerpair:a>, <donerpair:b>)   // (1a--b)
#ex-ref(1)                    // relative: next example
```

== Interlinear Glosses

Inside `#example[...]`, bullet lists (`-`) are treated as glosses.
Separate words with *two or more spaces*:

#demo(
  [
    #example[
      - Heidi  döner-i  ye-di=mi?
      - Heidi  döner-#acc  eat-#pst.3#smallcaps[sg]=#q
      'Did Heidi eat the döner?'
      #ex-label(<pq>)
    ]
  ],
  ```typst
  #example[
    - Heidi  döner-i       ye-di=mi?
    - Heidi  döner-#acc    eat-#pst.3#smallcaps[sg]=#q
    'Did Heidi eat the döner?'
    #ex-label(<pq>)
  ]
  ```
)

Leipzig abbreviations imported from the `abbreviations` submodule
auto-render in small caps. Print the full list with
`#print-abbreviations()`.

== Jambox-Style Annotations

`eggs` does not have a built-in jambox. A small helper does the job:

```typst
#let jb(main, annot) = grid(
  columns: (1fr, auto),
  main,
  align(right, text(size: 9pt, fill: luma(100))[#annot]),
)
```

#demo(
  [
    #example[
      + #jb[H#smallcaps[eidi]#sub[F]=mi döneri yedi?][Subject NFQ]
      + #jb[Heidi D#smallcaps[öner]-i#sub[F]=mi yedi?][Object NFQ]
      + #jb[Heidi döneri BUG#smallcaps[ün]#sub[F]=mü yedi?][Adjunct NFQ]
      + #jb[Heidi döneri Y#smallcaps[e]-D#smallcaps[i]#sub[F]=mi?][Verum/TAM NFQ]
    ]
  ],
  ```typst
  #example[
    + #jb[H#smallcaps[EIDI]#sub[F]=mi döneri yedi?][Subject NFQ]
    + #jb[Heidi D#smallcaps[ÖNER]-i#sub[F]=mi yedi?][Object NFQ]
    + #jb[Heidi döneri BUG#smallcaps[ÜN]#sub[F]=mü yedi?][Adjunct NFQ]
    + #jb[Heidi döneri Y#smallcaps[E]-D#smallcaps[İ]#sub[F]=mi?][Verum/TAM NFQ]
  ]
  ```
)


= Formal Semantics Notation <sec:semantics>

No `\usepackage{stmaryrd}` needed. Everything lives in math mode.

== Denotation Brackets

#demo(
  [`$sem("runs")$` -> $sem("runs")$],
  ```typst
  #let sem(x) = $lr(bracket.l.stroked #x bracket.r.stroked)$
  ```
)

The `lr()` makes brackets scale.

#warning[`bracket.l.double` / `bracket.r.double` are *deprecated*. Use
`bracket.l.stroked` / `bracket.r.stroked`. Do not paste CJK brackets
`〚〛` (U+301A/B) --- they are not in Typst's math delimiter set.]

== Ordinary / Focus Denotations

```typst
#let semo(x) = $lr(bracket.l.stroked #x bracket.r.stroked)^o$
#let semf(x) = $lr(bracket.l.stroked #x bracket.r.stroked)^f$
```

$semo("TP")$ and $semf("TP")$. World-indexed: $sem("runs")^(w)$.

#demo(
  [
    #example[$semo("TP") = "ate"("heidi","doner")$]
    #example[$semf("TP") = mat(delim: "{",
      "ate"("heidi","doner") ,;
      "ate"("heidi","dolma") ,;
      "ate"("heidi","donut") ,;
      dots.v;
    )$]
  ],
  ```typst
  #example[$semo("TP") = "ate"("heidi","doner")$]
  #example[$semf("TP") = mat(delim: "{",
    "ate"("heidi","doner") ,;
    "ate"("heidi","dolma") ,;
    "ate"("heidi","donut") ,;
    dots.v;
  )$]
  ```
)

== Lambda Expressions

```typst
#let lam(v, body) = $lambda #v . thin #body$
```

$lam("x", phi(x))$ · $lam("y", lam("x", "love"("x","y")))$

== Semantic Types

Arrow: `$e -> t$` → $e -> t$. Angle brackets:

```typst
#let ty(..args) = {
  let a = args.pos()
  $angle.l #a.join($, $) angle.r$
}
```

$ty(e, t)$ · $ty(e, ty(s, t))$ — replaces your LaTeX `\type` command.

== Quantifiers and Logical Symbols

All built in: `forall` $forall$, `exists` $exists$, `not` $not$,
`and` $and$, `or` $or$, `->` $->$, `<->` $<->$,
`~>` $~>$, `=>` $=>$, `mapsto` $mapsto$,
`square` $square$, `diamond.stroked` $diamond.stroked$,
`iota` $iota$, `models` $models$.

== Semantics Inside Examples

Denotation brackets work directly inside `#example[...]`:

#example[$sem(C_(+"pq")) = lam("p", lam("q", "q" = "p" or "q" = not "p"))$]

```typst
#example[$sem(C_(+"pq")) = lam("p", lam("q",
  "q" = "p" or "q" = not "p"))$]
```

Combine a gloss with a denotation in the same example:

#example[
  - Heidi  döner-i  ye-di=mi?
  - Heidi  döner-#acc  eat-#pst.3#smallcaps[sg]=#q
  'Did Heidi eat the döner?'

  $sem("...") = mat(delim: "{",
    "ate"("heidi","doner") ,;
    not "ate"("heidi","doner");
  )$
]

```typst
#example[
  - Heidi  döner-i       ye-di=mi?
  - Heidi  döner-#acc    eat-#pst.3#smallcaps[sg]=#q
  'Did Heidi eat the döner?'

  $sem("...") = mat(delim: "{",
    "ate"("heidi","doner") ,;
    not "ate"("heidi","doner");
  )$
]
```

== Multi-Line Derivations

Aligned math with `&` and `\`:

#example[$sem("Mary runs")$

  $ sem("Mary runs")
      &= sem("runs")(sem("Mary")) \
      &= (lam("x", "run"("x")))(m) \
      &=>_beta "run"(m) $
]

```typst
#example[$sem("Mary runs")$

  $ sem("Mary runs")
      &= sem("runs")(sem("Mary")) \
      &= (lam("x", "run"("x")))(m) \
      &=>_beta "run"(m) $
]
```

== Derivations with Rule Labels

For right-aligned rule names, use a four-column grid (LHS, operator,
RHS, label) so `=` and $=>_beta$ stay vertically aligned:

```typst
#let derivation(..steps) = {
  set par(first-line-indent: 0em)
  let cells = ()
  for step in steps.pos() {
    let (lhs, op, rhs, label) = step
    cells.push(align(right, lhs))
    cells.push(op)
    cells.push(rhs)
    cells.push(align(right,
      text(size: 9pt, fill: luma(100))[#label]))
  }
  block(inset: (left: 0em, y: 0.3em))[
    #grid(columns: (auto, auto, 1fr, auto),
      column-gutter: 0.4em, row-gutter: 0.45em,
      ..cells)
  ]
}
```

#demo(
  [
    #example[$sem("Mary loves John")$

      #derivation(
        ($sem("loves John")$, $=$, $(lam("y", lam("x", "love"("x","y"))))(j)$, [by FA]),
        ([], $=>_beta$, $lam("x", "love"("x", j))$, [by $beta$-red.]),
        ($sem("Mary loves John")$, $=$, $(lam("x", "love"("x", j)))(m)$, [by FA]),
        ([], $=>_beta$, $"love"(m, j)$, [by $beta$-red.]),
      )
    ]
  ],
  ```typst
  #example[$sem("Mary loves John")$

    #derivation(
      ($sem("loves John")$, $=$,
       $(lam("y", lam("x", "love"("x","y"))))(j)$,
       [by FA]),
      ([], $=>_beta$,
       $lam("x", "love"("x", j))$,
       [by $beta$-red.]),
      ($sem("Mary loves John")$, $=$,
       $(lam("x", "love"("x", j)))(m)$,
       [by FA]),
      ([], $=>_beta$,
       $"love"(m, j)$,
       [by $beta$-red.]),
    )
  ]
  ```
)

== Hamblin / Alternative Sets

#example[Polar question Hamblin set:
  $ mat(delim: "{",
      "ate"("heidi","doner") ,;
      not "ate"("heidi","doner");
    ) $]

#example[Focus alternative set:
  $ mat(delim: "{",
      "ate"("heidi","doner") ,;
      "ate"("heidi","dolma") ,;
      "ate"("heidi","donut") ,;
      dots.v;
    ) $]

```typst
#example[Polar question:
  $ mat(delim: "{",
      "ate"("heidi","doner") ,;
      not "ate"("heidi","doner");
    ) $]
```

== Generalized Quantifiers

#example[
  $sem("every") = lam("P", lam("Q",
      forall x ["P"(x) -> "Q"(x)]))$ \
  $sem("some")  = lam("P", lam("Q",
      exists x ["P"(x) and "Q"(x)]))$ \
  $sem("no")    = lam("P", lam("Q",
      not exists x ["P"(x) and "Q"(x)]))$
]

== Type-Lifting

#example[$ "Lift" = lam("x", lam("P", "P"("x"))) : e -> ((e -> t) -> t) $]

== Answerhood Operators

Dayal's (1996) $italic("Ans")$:

#example[$sem("Ans")(Q) = lam("w", iota p in Q [p(w) and forall p' in Q [p(w) -> p subset.eq p']])$]

== Focus-to-Ordinary C Head

#example[$semo([C [T P]]) = semf("TP")$]

#example[$semf(Sigma_F) = {lam("p", "p"), quad lam("p", not "p")}$]


= Syntactic Trees <sec:trees>

The `syntree` package draws trees from bracket notation:

```typst
#import "@preview/syntree:0.2.1": syntree, tree
```

== Simple Trees

Pass a bracket string to `#syntree()`:

#demo(
  [
    #example[
      #syntree(
        nonterminal: (font: "Charis SIL"),
        terminal: (font: "Charis SIL", style: "italic"),
        child-spacing: 2em,
        layer-spacing: 2.3em,
        "[S [NP [D the] [N linguist]] [VP [V runs]]]"
      )
    ]
  ],
  ```typst
  #example[
    #syntree(
      nonterminal: (font: "Charis SIL"),
      terminal: (font: "Charis SIL", style: "italic"),
      child-spacing: 2em, layer-spacing: 2.3em,
      "[S [NP [D the] [N linguist]] [VP [V runs]]]"
    )
  ]
  ```
)

== A Turkish Polar Question Tree

DP and VP merge into a lower TP; this lower TP and ΣP merge into a
higher TP; C and the higher TP form CP:

#demo(
  [
    #example[
      #syntree(
        nonterminal: (font: "Charis SIL"),
        terminal: (font: "Charis SIL", style: "italic"),
        child-spacing: 1.5em,
        layer-spacing: 2.3em,
        "[CP [C] [TP [TP [DP Heidi] [VP [DP döneri] [V yedi]]] [ΣP [Σ] [=mI]]]]"
      )
    ]
  ],
  ```typst
  #example[
    #syntree(
      "[CP [C] [TP [TP [DP Heidi]
        [VP [DP döneri] [V yedi]]]
        [ΣP [Σ] [=mI]]]]"
    )
  ]
  ```
)

== Trees with Semantic Types on Nodes

The `tree()` function accepts arbitrary Typst content, so you can
put types and denotations directly on nodes:

#example[
  #tree(
    $t$,
    tree(
      $e$,
      [_Mary_ \ $m$],
    ),
    tree(
      $e -> t$,
      [_runs_ \ $lam("x", "run"("x"))$],
    ),
  )
]

```typst
#example[
  #tree(
    $t$,
    tree($e$, [_Mary_ \ $m$]),
    tree($e -> t$,
      [_runs_ \ $lam("x", "run"("x"))$]),
  )
]
```

== Semantic Derivation on a Tree

The composed result sits at the mother node:

#demo(
  [
    #example[
      #tree(
        [$t$ \ $"run"(m)$],
        tree(
          [$e$ \ $m$],
          [_Mary_],
        ),
        tree(
          [$e -> t$ \ $lam("x", "run"("x"))$],
          [_runs_],
        ),
      )
    ]
  ],
  ```typst
  #example[
    #tree(
      [$t$ \ $"run"(m)$],
      tree([$e$ \ $m$], [_Mary_]),
      tree([$e -> t$ \ $lam("x", "run"("x"))$],
        [_runs_]),
    )
  ]
  ```
)

== Movement

Mark the landing site and trace with subscripts. `syntree` uses
`$zws_i$` (zero-width space trick) for subscripts on nonterminals:

#demo(
  [
    #example[_Which linguist did Mary meet?_

      #syntree(
        nonterminal: (font: "Charis SIL"),
        terminal: (font: "Charis SIL", style: "italic"),
        child-spacing: 1.8em,
        layer-spacing: 2.3em,
        "[CP [DP$zws_i$ [D which] [N linguist]] [C' [C did] [TP [DP Mary] [VP [V meet] [DP$zws_i$ $t_i$]]]]]"
      )
    ]
  ],
  ```typst
  #example[_Which linguist did Mary meet?_

    #syntree(
      "[CP [DP$zws_i$ [D which] [N linguist]]
        [C' [C did] [TP [DP Mary]
          [VP [V meet] [DP$zws_i$ $t_i$]]]]]"
    )
  ]
  ```
)

For actual movement *arrows*, use `lingotree` with `mannot` and `cetz`:

#demo(
  [
    #example[
      #lrender(
        ltree(
          tag: [CP],
          ltree(tag: [DP#sub[i]],
            mark(tag: <landing>)[which linguist]),
          ltree(tag: [C'],
            ltree(tag: [C], [did]),
            ltree(tag: [TP],
              ltree(tag: [DP], [Mary]),
              ltree(tag: [VP],
                ltree(tag: [V], [meet]),
                ltree(tag: [DP],
                  mark(tag: <trace>)[$t_i$]),
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
            (rel: (x: -2, y: -1)),
            "landing.south",
            stroke: (dash: "dashed"),
            mark: (end: "straight"),
          )
        },
      )
    ]
  ],
  ```typst
  #import "@preview/lingotree:1.0.0": tree as ltree, render as lrender
  #import "@preview/mannot:0.3.0": mark, annot-cetz
  #import "@preview/cetz:0.4.2" as cetz

  #example[
    #lrender(
      ltree(
        tag: [CP],
        ltree(tag: [DP#sub[i]],
          mark(tag: <landing>)[which linguist]),
        ltree(tag: [C'],
          ltree(tag: [C], [did]),
          ltree(tag: [TP],
            ltree(tag: [DP], [Mary]),
            ltree(tag: [VP],
              ltree(tag: [V], [meet]),
              ltree(tag: [DP],
                mark(tag: <trace>)[$t_i$]),
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
          (rel: (x: -2, y: -1)),
          "landing.south",
          stroke: (dash: "dashed"),
          mark: (end: "straight"),
        )
      },
    )
  ]
  ```
)

This gives a dashed arrow from the trace to the landing site, like
`\draw` in TikZ with `forest`.

== Trees with Hamblin Sets

For alternative-semantics trees, put `mat(delim: "{")` in node labels:

#example[
  #tree(
    [$ty(s,t)$ \ $mat(delim: "{",
        "ate"("h","d") ,;
        not "ate"("h","d");
      )$],
    tree(
      [$ty(s,t)$ \ ${"ate"("h","d")}$],
      tree([$e$], [_Heidi_]),
      tree(
        [$ty(e, ty(s,t))$],
        tree([$e$], [_döneri_]),
        tree([$ty(e, ty(e, ty(s,t)))$], [_yedi_]),
      ),
    ),
    tree(
      [$ty("st","st")$ \ $mat(delim: "{",
          lam("p","p") ,;
          lam("p", not "p");
        )$],
      [$Sigma_F$ _=mI_],
    ),
  )
]

```typst
#example[
  #tree(
    [$ty(s,t)$ \ $mat(delim: "{",
        "ate"("h","d") ,;
        not "ate"("h","d");
      )$],
    tree(
      [$ty(s,t)$ \ ${"ate"("h","d")}$],
      tree([$e$], [_Heidi_]),
      tree([$ty(e,ty(s,t))$],
        tree([$e$], [_döneri_]),
        tree([$ty(e,ty(e,ty(s,t)))$], [_yedi_]),
      ),
    ),
    tree(
      [$ty("st","st")$ \ $mat(delim: "{",
          lam("p","p") ,;
          lam("p", not "p");
        )$],
      [$Sigma_F$ _=mI_],
    ),
  )
]
```


= Quick Reference <sec:ref>

#figure(
  table(
    columns: (1fr, 1fr),
    align: (left, left),
    stroke: none,
    inset: 4pt,
    table.header[*What you want*][*Code*],
    table.hline(stroke: 0.4pt),
    [$sem("runs")$],                      [`$sem("runs")$`],
    [$semo("TP")$ / $semf("TP")$],        [`$semo("TP")$` / `$semf("TP")$`],
    [$lam("x", phi(x))$],                [`$lam("x", phi(x))$`],
    [$e -> t$],                           [`$e -> t$`],
    [$ty(e, t)$],                         [`$ty(e, t)$`],
    [$forall x [P(x)]$],                 [`$forall x [P(x)]$`],
    [$exists x [P(x)]$],                 [`$exists x [P(x)]$`],
    [$phi["x" := "a"]$],                 [`$phi["x" := "a"]$`],
    [$(lam("x", phi)) ~>_beta phi$],     [`~>_beta`],
    [$square p$ / $diamond.stroked p$],   [`$square p$` / `$diamond.stroked p$`],
    [$iota x [P(x)]$],                   [`$iota x [P(x)]$`],
  ),
  caption: [Quick reference for semantic notation.],
) <tab:ref>

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    stroke: none,
    inset: 4pt,
    table.header[*Package*][*Use for*],
    table.hline(stroke: 0.4pt),
    [`eggs`],              [examples, sub-examples, judges, glosses, refs],
    [`leipzig-glossing`],  [alternative glossing package],
    [`syntree`],           [simple bracket-notation trees, `tree()` for rich nodes],
    [`lingotree`],         [trees with styling, colors, annotations],
    [`cetz`],              [general drawing (arrows, boxes, diagrams)],
    [`mannot`],            [movement arrows on trees],
  ),
  caption: [Useful packages for linguistics in Typst.],
) <tab:packages>

// #bibliography("refs.bib", style: "chicago-author-date")
