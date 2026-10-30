// Content lives in data/*.yaml; presentation lives in template.typ.

// ---- Spacing controls -------------------------------------------------------
#let line-leading = 3pt     // space between lines within a paragraph (whole document)
#let entry-gap    = 10pt    // space between numbered entries (papers, talks, projects)
#let title-gap    = 4pt     // space between an entry's title and its author/venue line
#let bullet-gap   = 4pt     // space between items in bullet and service sections
#let group-gap    = 7pt     // space after each service group
#let school-gap   = 10pt    // space between institutions in teaching
#let section-gap  = 12pt    // space above each section heading
#let use-page-breaks = false // false = ignore page-break-before in sections.yaml
// -----------------------------------------------------------------------------

#let navy = rgb("000080")
#let body-inset = 20mm
#let visible(items) = items.filter(item => type(item) != dictionary or item.at("enabled", default: true))

// A field may be a plain string or a list of strings and styled/link runs.
#let rich(value) = {
  if type(value) == str { value }
  else if type(value) == array { value.map(rich).join() }
  else if value.at("break", default: false) { linebreak() }
  else {
    let body = rich(value.text)
    if value.at("italic", default: false) { body = emph(body) }
    if value.at("bold", default: false) { body = strong(body) }
    if value.at("smallcaps", default: false) { body = smallcaps(body) }
    if value.at("mono", default: false) { body = text(font: "DejaVu Sans Mono", size: 0.9em, body) }
    if "url" in value { body = link(value.url, body) }
    body
  }
}

#let icon(kind) = {
  if type(kind) == array { return kind.map(icon).join(h(0.2em)) }

  // Sites with no glyph in either font: rendered as content.
    let custom = (
    lingbuzz: box(
      fill: navy, radius: 1.8pt,
      inset: (x: 1pt, top: 0.5pt, bottom: 2pt), baseline: -1.5pt,
      text(fill: white, size: 0.75em, smallcaps[*lingbuzz*]),
    ),
  )
  if kind in custom { return custom.at(kind) }

  let fa-solid = ("Font Awesome 7 Free Solid", "black")
  let fa-brands = ("Font Awesome 7 Brands", "regular")
  let ai = ("Academicons", "regular")

  let glyphs = (
    // Academicons
    doi:      (ai, "\u{e97e}"),
    biorxiv:  (ai, "\u{e9a2}"),
    psyarxiv: (ai, "\u{e90e}"),
    arxiv:    (ai, "\u{e974}"),
    // Font Awesome Solid
    openmaterial:     (ai, "\u{e968}"), 
    pdf:      (fa-solid, "\u{f1c1}"),
    preprint: (fa-solid, "\u{f471}"),
    website:  (fa-solid, "\u{f0c1}"),
    abstract: (fa-solid, "\u{f249}"),
    slides:   (fa-solid, "\u{f26c}"),
    poster:   (fa-solid, "\u{f03e}"),
    handout:  (fa-solid, "\u{f15b}"),
    data:     (fa-solid, "\u{f1c0}"),
    // Font Awesome Brands
    github:   (fa-brands, "\u{f09b}"),
    twitter:  (fa-brands, "\u{f099}"),
  )
  assert(kind in glyphs, message: "Unknown link kind: " + kind)
  let ((font, weight), glyph) = glyphs.at(kind)
  text(font: font, weight: weight, style: "normal", size: 0.92em, glyph)
}

// kind only → icon(s); text only → text; both → icon(s) followed by text.
#let resource-link(item) = {
  let parts = ()
  if "kind" in item { parts.push(icon(item.kind)) }
  if "text" in item { parts.push(rich(item.text)) }
  link(item.url, parts.join(h(0.3em)))
}

#let resources(items) = items.map(resource-link).join(h(0.35em))

#let cv-style(profile: (:), body) = {
  set document(title: profile.name + " — " + profile.document-title, author: profile.name)
  set page(
    paper: "a4",
    margin: (top: 20mm, bottom: 20mm, left: 40mm, right: 20mm),
    footer-descent: 10mm,
    footer: context align(center, move(dx: -10mm, counter(page).display("1 of 1", both: true))),
  )
  set text(font: ("Source Serif Pro", "Source Serif 4"), size: 10pt, lang: "en", hyphenate: true,
    top-edge: 0.8em, bottom-edge: 0.2em)
  set par(leading: line-leading, spacing: 0pt, justify: true)
  set smartquote(enabled: false)
  set list(indent: 0pt, body-indent: 1.5em, spacing: 3pt)
  show link: set text(fill: navy)
  // Headings retain PDF bookmarks while their visible labels sit in the margin.
  show heading: it => block(above: section-gap, below: 0pt, sticky: true)[
    #place(dx: -body-inset, box(width: 19mm)[
      #set par(justify: false, leading: 4.4pt)
      #set text(size: 10pt, hyphenate: false, weight: "regular")
      #smallcaps(it.body)
    ])
  ]
  body
}

#let cv-header(profile) = {
  let date = sys.inputs.at("date", default: profile.at("date", default: "auto"))
  if date == "auto" { date = datetime.today().display("[month repr:long] [day], [year]") }
  block(width: 170mm, inset: (bottom: 0pt), above: 0pt, below: 9pt)[
    #move(dx: -body-inset)[
      #grid(columns: (1fr, auto), align: (left, right),
        text(size: 12pt, weight: "bold", profile.name),
        text(size: 9pt, weight: "bold")[C.V. (#date)],
      )
      #v(7pt)
      #line(length: 100%, stroke: 1pt)
    ]
  ]
  grid(columns: (1fr, 1.85in), gutter: 20pt,
    profile.address.map(line => [#line]).join(linebreak()),
    [
      #set par(justify: false)
      #grid(columns: (auto, 1fr), column-gutter: 0.7em, row-gutter: 4pt,
        emph[Website:], resource-link(profile.website),
        emph[Social:], profile.social.map(resource-link).join([#h(0.4em)|#h(0.4em)]),
        emph[E-mail:], link("mailto:" + profile.email, profile.email),
      )
    ],
  )
}

#let author-line(authors, name) = {
  let parts = authors.split(name)
  parts.enumerate().map(((index, part)) => [#if index > 0 { strong(name) }#part]).join()
}

// Title on its own line (semibold, with links); authors/year/venue below in smaller text.
#let bibliography-entry(entry, profile) = {
  let title = if entry.at("title-italic", default: false) { emph(entry.title) } else { entry.title }
  block(above: 0pt, below: 0pt)[
    #set par(justify: false)
    #text(weight: "semibold", title)
    #if "links" in entry { h(0.4em) + resources(entry.links) }
  ]
  block(above: title-gap, below: 0pt)[
    #set text(size: 9pt)
    #set par(justify: false, hanging-indent: 1em)
    #author-line(entry.authors, profile.author-name).
    #if "year" in entry { [#entry.year.] }
    #if "status" in entry { [#entry.status.] }
    #if "venue" in entry { emph(entry.venue) }
  ]
  if "notes" in entry {
    block(above: 3pt, below: 0pt, inset: (left: 1em))[
      #set text(size: 8pt)
      #list(..visible(entry.notes).map(note => [#rich(note.text) #resources(note.at("links", default: ()))]))
    ]
  }
}

#let numbered(entries, render, start: 1) = {
  for (index, entry) in entries.enumerate() {
    block(above: 0pt, below: entry-gap, breakable: false)[
      #grid(columns: (1.65em, 1fr), column-gutter: 0.5em,
        align(right)[\[#(start + index)\]],
        render(entry),
      )
    ]
  }
}

#let dated-line(left, date) = grid(columns: (1fr, auto), gutter: 0.8em, left, date)

#let education(entries) = {
  for entry in entries {
    block(above: 0pt, below: 11pt, breakable: false)[
      #grid(columns: (1fr,), row-gutter: 4pt,
        dated-line([#strong(if "url" in entry { link(entry.url, entry.institution) } else { entry.institution }), #entry.location], entry.dates),
        ..entry.details.map(rich),
      )
    ]
  }
}

#let project(entry) = [
  #par(hanging-indent: 1em)[
    Project title: #link(entry.url, text(weight: "semibold", entry.title)) #entry.funding \
    #rich(entry.collaborators)
  ]
  #block(above: 3pt, inset: (left: 1.5em))[#emph(entry.description)]
]

// Space only between institutions, not after the last one.
#let teaching(entries) = {
  for (i, school) in entries.enumerate() {
    if i > 0 { v(school-gap) }
    block(above: 0pt, below: 10pt, sticky: true)[#strong(school.institution), #school.location]
    for role in visible(school.roles) {
      block(above: 0pt, below: 5pt, sticky: true)[
        #grid(columns: (1em, 1fr), gutter: 0.5em,
          [•], dated-line([#emph(role.role) #role.department], role.dates),
        )
      ]
      for course in visible(role.courses) {
        block(above: 0pt, below: 7pt, breakable: false, inset: (left: 2em))[
          #grid(columns: (6.8em, 1fr), column-gutter: 0.5em,
            smallcaps(course.term),
            [#course.title#if "links" in course { [ \[#resources(course.links)\]] }],
          )
        ]
      }
    }
  }
}

#let bullet-item(entry, indent: 0pt) = block(
  above: 0pt, below: bullet-gap, breakable: false, inset: (left: indent),
  grid(columns: (1em, 1fr), gutter: 0.5em, [•], rich(entry.text)),
)

#let bullet-items(entries) = {
  for entry in entries { bullet-item(entry) }
}

#let skills(entries) = grid(
  columns: (1fr, 1fr), gutter: 12pt,
  ..entries.map(group => [
    #list([#group.title])
    #block(inset: (left: 1.5em), above: 2pt)[
      #list(marker: [◇], ..visible(group.items).map(rich))
    ]
  ]),
)

// Items are laid out one by one (no wrapper block), so a group can split
// across pages and only its title is kept with its first item.
#let service(entries) = {
  for group in entries {
    block(above: 0pt, below: 3pt, sticky: true)[#list(group.title)]
    for entry in visible(group.items) { bullet-item(entry, indent: 1.5em) }
    v(group-gap, weak: true)
  }
}

#let render-section(section, entries, profile: (:), start: 1, honor-page-breaks: true) = {
  if honor-page-breaks and use-page-breaks and section.at("page-break-before", default: false) {
    pagebreak(weak: true)
  }
  heading(level: 1, numbering: none, section.title)
  if "subtitle" in section {
    block(sticky: true, above: 0pt, below: 5pt)[#strong(section.subtitle)]
  }
  if section.type == "interests" { emph(entries.map(rich).join(", ")) }
  else if section.type == "education" { education(entries) }
  else if section.type == "bibliography" { numbered(entries, entry => bibliography-entry(entry, profile), start: start) }
  else if section.type == "projects" { numbered(entries, project, start: start) }
  else if section.type == "teaching" { teaching(entries) }
  else if section.type == "skills" { skills(entries) }
  else if section.type == "bullets" { bullet-items(entries) }
  else if section.type == "service" { service(entries) }
  else { panic("Unknown section type: " + section.type) }
}


#let profile = yaml("data/profile.yaml")
#let sections = yaml("data/sections.yaml")
#let requested = sys.inputs.at("sections", default: "all")
#let selected = if requested == "all" { none } else {
  requested.split(",").map(value => value.trim())
}
#if selected != none {
  for id in selected {
    assert(sections.any(section => section.id == id), message: "Unknown CV section: " + id)
  }
}

#show: cv-style.with(profile: profile)
#cv-header(profile)

#let counts = (:)
#for section in visible(sections) {
  if selected == none or section.id in selected {
    let entries = visible(yaml(section.file))
    if entries.len() > 0 {
      let group = section.at("numbering-group", default: section.id)
      let start = counts.at(group, default: 0) + 1
      render-section(section, entries, profile: profile, start: start,
        honor-page-breaks: selected == none)
      counts.insert(group, start + entries.len() - 1)
    }
  }
}
