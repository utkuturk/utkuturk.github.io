// Utku Turk — Research Details

// ---- Style controls ---------------------------------------------------------
#let body-font   = ("Source Serif Pro", "Source Serif 4", "Libertinus Serif")
#let body-size   = 10.5pt
#let line-leading = 5.5pt  // space between lines within a paragraph
#let para-gap    = 9pt     // space between paragraphs, and after a project's info line
#let project-gap = 20pt    // space above each project title
#let part-gap    = 30pt    // space above each part (Dissertation, Psycholinguistics, ...)
#let info-gap    = 4pt     // space between a project title and its info line
#let navy        = rgb("000080")
#let muted       = rgb("555555")
// -----------------------------------------------------------------------------

#set document(title: "Utku Turk — Research Details", author: "Utku Turk")
#set page(paper: "a4", margin: (x: 25mm, y: 22mm), numbering: "1", number-align: center)
#set text(font: body-font, size: body-size, lang: "en", hyphenate: true)
#set par(leading: line-leading, spacing: para-gap, justify: true)
#set block(spacing: para-gap)
#show link: set text(fill: navy)
#set enum(indent: 0.5em, body-indent: 0.6em, spacing: para-gap)

#set heading(numbering: "1.1")

// Part headings: large, with a rule underneath.
#show heading.where(level: 1): it => block(above: part-gap, below: 12pt, sticky: true, width: 100%)[
  #set text(size: 14pt, weight: "bold")
  #counter(heading).display(it.numbering)#h(0.6em)#it.body
  #v(-6pt)
  #line(length: 100%, stroke: 0.7pt)
]

// Project headings: bold title, number in grey.
#show heading.where(level: 2): it => block(above: project-gap, below: info-gap, sticky: true)[
  #set par(justify: false)
  #set text(size: 11.5pt, weight: "bold")
  #text(fill: muted, weight: "regular", counter(heading).display(it.numbering))#h(0.6em)#it.body
]

// Sub-project headings.
#show heading.where(level: 3): it => block(above: 14pt, below: info-gap, sticky: true)[
  #set text(size: body-size, weight: "bold", style: "italic")
  #it.body
]

// Contents: parts in bold with a little space above each.
#show outline.entry.where(level: 1): it => {
  v(6pt, weak: true)
  strong(it)
}

// Info line under a project title: status tag · collaborators · links.
#let tag(label) = box(
  inset: (x: 4pt, y: 1.5pt), outset: (y: 1pt), radius: 2pt,
  stroke: 0.5pt + muted,
  text(size: 8pt, fill: muted, tracking: 0.3pt, upper(label)),
)

#let info(status: none, with: none, links: ()) = block(above: info-gap, below: para-gap, sticky: true)[
  #set par(justify: false)
  #set text(size: 9pt, fill: muted)
  #let parts = ()
  #if status != none { parts.push(tag(status)) }
  #if with != none { parts.push([with #with]) }
  #if links.len() > 0 { parts.push(links.map(((label, url)) => link(url, label)).join(h(0.8em))) }
  #parts.join(h(0.5em) + [·] + h(0.5em))
]

// Small bracketed links for use inside a paragraph.
#let inline-links(..items) = text(size: 9pt)[\[#items.pos().map(((label, url)) => link(url, emph(label))).join(", ")\]]


// ---- Title ------------------------------------------------------------------
#align(center)[
  #text(size: 18pt, weight: "bold")[Utku Turk]
  #v(-4pt)
  #text(size: 12pt, fill: muted)[Research Details]
]
#v(10pt)

#outline(title: none, depth: 2, indent: 1.2em)


// =============================================================================
= Dissertation

== Agreement planning

*Agreement can be informative about morphological planning by investigating three questions.*

#set enum(numbering: "(i)")
+ *Representational question.* Does the planning of agreement is parasitic on verbs or can a syntactic representation contain a verb without agreement features? Existing models of production are not clear on whether all information with respect to a lexical item is committed as soon as that lexical item is retrieved. Existing lemma based models are consistent with both eager (planning agreement as soon as you have the verb) and lazy (planning agreement only when it is needed) agreement processes (though see Eberhard et al. 2005).

+ *Timing questions.* Given that this gap is architecturally possible, do speakers exploit it? Do they leave agreement unspecified until a dependency forces them to commit (lazy planning), or do they compute it as soon as they have the opportunity (eager planning)? Prior work has shown that speakers plan unaccusative verbs before sentence onset, together with the subject head (Momma & Ferreira, 2019), while unergative verbs are planned later. This creates a natural test: if agreement is eager, unaccusative sentences should show reduced or absent agreement attraction (because the attractor noun has not yet been planned when the verb's number is set). If agreement is lazy, attraction should be comparable across verb types.

+ *Dissociating subprocesses of morphosyntax and morphophonology.* Even if agreement features are assigned early in the syntax, this may not be detectable in the surface form if phonological encoding happens late. One possible set of results is that agreement error rates are comparable between two verb types; however, sentence onset is still sensitive to number mismatch but only in unaccusatives. This would, in turn, mean that we can dissociate two subprocesses of morphology: assigning the morphosyntactic feature and retrieving the correct morphophonological form.

#set enum(numbering: "1.")

== Tense planning

Temporal reference is an important element of discourse, not only marking an event's specific time, but also the relationship between the time of speaking and event time, as well as the temporal distribution of an event irrespective of when it occurred. This chapter asks the representation question from a different angle.

In agreement, the relevant information (number) enters the verb through a linguistic mediator — the subject noun. The discourse determines the noun's number, and the noun determines the verb's number. In tense, there is no mediator. The discourse/message directly determines the verb's tense. The speaker knows, from their communicative intention, whether they are talking about the past or the future. This information is available from the very start of planning. Since tense information is available earlier than agreement information (it doesn't wait for another linguistic element), speakers could in principle begin building tense-marked syntactic structure immediately. Or do they maintain an underspecified skeleton and defer tense specification until closer to articulation?

In three scene description experiments, I test the timing of conceptual priming (with a task without a linguistic output), (morpho)syntactic priming (scene description and manipulation of Future/Past tense), and (morpho)phonological planning (scene description and manipulation of regularity). This manipulation also creates an informative contrast with agreement. In agreement, the "bifurcation" of information comes from two different lexical items (two nouns with potentially mismatching number) affecting a single closed-class item (the auxiliary). In tense with irregularity, a single piece of information (past tense) hits the verb, and the verb's lexical identity creates the bifurcation between regular and irregular surface forms. The verb becomes a "prism" that refracts a single input into different morphophonological outputs.

== Case planning

Case information presents an interplay between the "default" structural behavior and a lexicon-specific information. Certain verbs (e.g., psych verbs, experiencer verbs) assign non-default cases to their objects. This is a lexical property of the verb that the speaker must know in advance. Cross-linguistically, Beth Levin has argued that verbs assigning lexical case form a coherent class tied to high-level conceptual properties (non-core argument roles). But for any individual verb, the speaker must still have learned its case-assignment behavior, which is argued to be syntactically local. On the other hand, the structural accusative case is assigned to the object by the syntactic structure itself, independently of which verb is used. Whatever syntactic theory one adopts, the structural case follows automatically from the syntactic configuration with no reference to verb. Moreover, this assignment is not local.

These two sources of case create a natural test of the eager/lazy planning question. Structural case requires no knowledge of the verb, whereas lexical case requires knowing something about the verb, but potentially not everything (for which we have evidence from active/passive alternation and psych-verb selection literature that suggests speakers know enough about the verb early to determine argument structure). If speakers know the verb's case-assignment class early, do they immediately begin computing the case on the object? Or do they defer until the object must be produced? I test these possibilities in Turkish using eye-tracking and production methodologies together.

== Pipelines

Across my dissertation, I have created pipelines for transcribing and aligning produced sentences, along with creating visually and audio-wise consistent experimental materials and instructions for English. I utilized already existing technologies and extended them to investigate morphological and phonemic level. Moreover, I extended such methodologies to Turkish, training my own forced aligner and phonetic transcription. Moreover, due to existing variability in transcriptions and the minuteness of the morphological data, I created a pipeline that uses several agents to settle on more stable transcriptions and timings. Lastly, I investigated advanced-planning methodologies that do not depend on written word forms, such as codability of an action, sentence initial and phrase initial F0 Pitch, and Transformer based attention metrics.


// =============================================================================
= Other work in Psycholinguistics

== LLMs explainability of cross-linguistic syncretism in agreement attraction
#info(status: "Published", with: [Eva Neu],
  links: (([ACL Paper], "https://aclanthology.org/2026.scil-main.16/"),))

Agreement attraction errors, in which a verb erroneously agrees with an intervening noun rather than its grammatical head, are amplified by morphological syncretism in some languages (English, German, Russian) but not others (Turkish, Armenian), a cross-linguistic pattern without a principled account. We use surprisal and attention entropy measures from large language models as processing proxies to investigate this variation across four languages. LLM-derived measures replicate behavioral findings in English and German (syncretism modulates attraction), align with Turkish null results (no modulation), and partially capture Russian patterns.

== Frequency's effect on syntactic choices: Suspended Affixation
#info(status: "Published", with: [Eva Neu, Ozge Bakay, Brian Dillon, and Gaja Jarosz],
  links: (([ACL Paper], "https://aclanthology.org/2026.scil-main.32/"),))

Previous literature in suspended affixation, a phenomenon in which a suffix is interpreted for both conjuncts but only visible in a single one, argued that derivational suffixes in Turkish do not participate in such morphological processes. However, the distinction between derivational and inflectional suffixes are less clear in recent theoretical frameworks. Yet, the facts with respect to acceptability of derivational suffixes in suspended affixation is quite clear. We point out that the token frequency of coordinants affects the acceptability within derivational suffixes. Following our results and using multinomial processing trees, we argue that while the grammar is categorical, the difference between seemingly derivational-inflection affixes and token-frequency surface from two latent processes: (i) likelihood of different parses as a function of bare \[N1 and N2\] frequency and (ii) boundedness of suffixes, respectively.

== Mental objects and index problem
#info(status: "Preprint", with: [Xinchi Yu, Allison Dods, Ellen Lau],
  links: (([BioArxiv Paper], "https://www.biorxiv.org/content/10.1101/2025.05.02.651748v1"),))

In daily life, we can construct mental objects from various modalities: we can create a cat in the mind from visual experience, or from what someone says or signs linguistically. Do mental objects derived from different input sources share the same set of 'slots' (or pointers, indexicals)? Our EEG experiment shows that mental indexical mirrors the signals found in previous visual work.

== Turkish Register Agreement
#info(status: "In writing",
  links: (([Abstract], "https://www.utkuturk.com/files/abstracts/TurkHSP2025.pdf"),))

Turkish verbs can agree with non-thematic arguments, non-subject honorific addressees, that can occur as a parenthetical at any surface position without any discourse effect. However, this non-thematic agreement only occurs with a subset of honorifics. We manipulated the grammaticality of the sentence, the number of the attractors, and the type of the honorific in a speeded acceptability judgment task. Our results suggest that participants show attraction effects in grammatical sentences without between-subject response-bias manipulation and we can induce symmetrical attraction effects by manipulating uncertainty in the probe of the agreement.

== Surface Level Heuristics
#info(status: "Submitted",
  links: (([Submitted Paper], "https://osf.io/preprints/psyarxiv/dwh8v"),))

Linguistic illusion literature debates what information accesses memory representations. Prior work tests whether structural, semantic, or discourse cues guide subject-verb dependencies; however, it remains unclear whether native speakers rely on surface level heuristics, such as phonological information during dependency resolution. Contra Slioussar (2018), I argue that accidental phonological overlap cannot induce attraction, rather syncretism or other phonological similarity-like effects are parasitic to attractors' likelihood of being a possible controller.

== Bias Manipulation
#info(status: "In writing",
  links: (([Abstract], "https://www.utkuturk.com/files/abstracts/hsp-2023-bias.pdf"),))

Agreement attraction, an illusion in which agreement with the subject was interfered by other nominals, was previously argued to be repair-based phenomenon, namely only surfacing in ungrammatical sentences. Recently, Hammerly et al. (2019) argued that symmetrical effects in ungrammatical and grammatical sentences surface when participants' a priori 'yes' bias is decreased through experiment instructions. However, their bias calculation was circular and its calculation included experimental sentences, which can derive or amplify the bias parameters.

Our results showed that instruction-based manipulation did not affect participants' attraction in grammatical and ungrammatical sentences. However, filler-based bias parameters supported their theoretical contribution. On the other hand, reanalysis of their data and other agreement acceptability data using filler-only bias does not fully warrant their findings: the attraction in grammatical sentences were inconsistent. Such qualitative difference is expected in repair-based models, but not in marking and morphing or percolation models.

== Sentence Recall
#info(status: "In writing", with: [Allison Dods, Sebastian Mancha, Allison MacDonald],
  links: (([Abstract], "https://www.utkuturk.com/files/abstracts/hsp-2024-task.pdf"),))

We failed to replicate the early unaccusative planning related findings of Momma and Ferreira (2019) in three sentence-word interference recall experiments. We believe that visual event inference in detecting patienthood (à la Hafri et al. 2018) might have played a bigger role than the syntactic early planning in the previous advanced planning literature.

== Lexical status of prefixes in B/C/M/S(erbian)
#info(status: "In writing", with: [Maša Beslin],
  links: (([Abstract], "https://www.utkuturk.com/files/abstracts/fasl-35.pdf"),))

This auditory priming study tests whether BCMS speakers decompose lexically prefixed verbs into prefixes and stems by comparing semantically transparent and opaque prefixation with pseudo-morphological and purely phonological stem overlap.

== Probabilistic rational inference in agreement
#info(links: (([Abstract], "https://www.utkuturk.com/files/abstracts/hsp-2026-structural-cues.pdf"),))

Rational inference accounts argue that speakers sometimes 'correct' what they heard with what they think they should have heard by calculating likelihood of possible different strings. In the case of agreement attraction, they argue that participants can correct 'the key to the cabinets' as 'the keys to the cabinets' in their memory since the second string is more likely. This would lead to increased acceptance of ungrammatical sentences like 'The key to the cabinets are rusty'. We show that similar grammaticality illusions still arise even with cases where the possible corrected value is less likely to occur, or even ungrammatical.


// =============================================================================
= Other work in Analytical Linguistics

== Question semantics
#info(with: [Aron Hirsch],
  links: (([Proceedings 1], "https://ling.auf.net/lingbuzz/009763"),
          ([Proceedings 2], "https://ling.auf.net/lingbuzz/009762")))

Though many assume shared representations for question semantics and focus-alternative semantics, the mechanisms behind forming such meaning is often not unified. Using Turkish polar questions which strictly follow sentential F-marking and only-question embedding verbs, we argue that not only final representations, i.e. alternatives in formal semantics, but how such alternatives are formed should be unified.

== Language variation in Turkish Allocutive Agreement
#info(status: "In writing")

Allocutivity refers to agreement between the verb and non-thematic arguments. A subgroup of Turkish speakers can use 3rd person plural marking to agree with the addressee, instead of the subject of the sentence even when the subject is not a formal addressee. Another subgroup of speakers do not accept the agreement with addressee, however, they use the same morphology to agree with a honorific subjects, as in Mr. Kemal. I show experimentally that these two populations have different patterns in acceptability. I also model a unified syntax for both of these phenomena.

== Syntax of multiple wh-questions
#info(with: [Sadira Lewis],
  links: (([Paper], "https://www.utkuturk.com/files/papers/LewisTurk2025.pdf"),))

It is not clear from the syntactic literature whether the forces of wh-superiority is a language-specific phenomenon or omnipresent in all languages but only available in certain constructions. Turkish, along with other languages, previously argued to lack such superiority effects, suggesting language-specificity. However, we show instances of superiority violating wh-questions with adjuncts, which is previously shown to be more sensitive to other movement related phenomenon, such as islands.

== Russian Exceptives in Heritage Speakers
#info(with: [Masha Polinsky])

We manipulated the environments in which exceptives surface in terms of their downward entailment. We found that Heritage speakers were not sensitive to this manipulation, while the native speakers were. We also showed that participants' continuous Heritageness score derived from their signal detection theoretic sensitivity to other structures known to be accepted more often by Heritage speakers predicted the cut between grammars.

== Language Infrastructure development

=== Treebanking work

As a part of a bigger project in which a set of treebanks were to be introduced for the Anatolian Sprachbund, I led the annotation in Laz Treebanking. The aim was to create additional treebanks for Cappadocian Greek, Romeika, Sason Arabic, Judeo-Espanyol (Istanbul), Istanbul Greek, Pomak, Western Armenia, and Homshetsi Georgian. #inline-links(([proceedings], "https://www.utkuturk.com/files/papers/TurkEtAl2020.pdf"))

I also led the tool development and unifying Turkish treebanking practices within a linguistically oriented framework. We also initiated an extensive new treebank. #inline-links(
  ([paper], "https://link.springer.com/article/10.1007/s10579-021-09558-0"),
  ([proceedings1], "https://aclanthology.org/W19-4019.pdf"),
  ([proceedings2], "https://aclanthology.org/W19-8013.pdf"),
)

=== Tutorials

+ #link("https://www.utkuturk.com/posts/aws-s3-pcibex/")[How to use AWS to collect recording data]
+ #link("https://www.utkuturk.com/posts/mfa/")[How to align sentences to sounds automatically]
+ #link("https://www.utkuturk.com/posts/generate-items/")[Generating consistent images for picture description studies]
+ #link("https://www.utkuturk.com/posts/audio-gen/")[Generating audio-recordings for instructions]
+ #link("https://www.utkuturk.com/posts/clip/")[Controlling for picture difficulty with Visual LLMs]
