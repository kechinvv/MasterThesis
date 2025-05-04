#let settings(doc) = [
  // Page settings
  #set page(
    paper: "a4",
    margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
    numbering: "1",
    number-align: center,
  )

  // Font and language settings
  #set text(
    font: "Times New Roman",
    size: 14pt,
    lang: "ru"
  )

  // Paragraph settings
  #set par(
    first-line-indent: 1.25cm,
    justify: true,
    leading: 1.5em,  // Equivalent to 1.5 line spacing
  )

  // Chapter heading style (equivalent to \chapter)
  #show heading.where(level: 1): it => [
    #set align(center)
    #set text(weight: "bold")
    #pagebreak()
    #block(spacing: 20pt)[
      #upper(it)
    ]
  ]

  // Section heading style (equivalent to \section)
  #show heading.where(level: 2): it => [
    #set align(left)
    #set text(weight: "bold")
    #block(spacing: 20pt)[
      #it
    ]
  ]

  // Subsection heading style (equivalent to \subsection)
  #show heading.where(level: 3): it => [
    #set align(left)
    #set text(weight: "bold")
    #block(spacing: 20pt) #it
  ]

  // Configure headings for numbering
  #set heading(
    numbering: "1.1.1",
    // Only number up to level 3 (subsection)
    depth: 3
  )

  // Figure caption styling
  #show figure.caption: it => context [
    #set align(center)
    #set text(size: 12pt)
    Рисунок #it.counter.display() --- #it.body
  ]

  // Table caption styling
  #show figure.where(kind: table) : it => [
    #set align(left)
    #set text(size: 12pt)
    Таблица #it.counter.display() --- #it.caption.body
  ]

  // Table caption styling
  #show figure.where(kind: raw) : it => [
    #set align(center)
    #set text(size: 12pt)
    #it.body
    Листинг #it.counter.display() --- #it.caption.body
  ]

  // Configure figure and table numbering
  #set figure(
    numbering: "1",  // Continuous numbering across document
  )

  // Unordered list with dash instead of bullet
  #set list(
    indent: 1.25cm,
    body-indent: 0em,
    marker: [-- #sym.space],
  )

  // Ordered list with custom numbering
  #set enum(
    indent: 1.25cm,
    body-indent: 0em,
    full: true,
    numbering: (..nums) => {
      let level = nums.pos().len()
      let current = nums.pos().last()
      if level == 1 {
        // First level: Arabic numerals with parenthesis
        [#current) #sym.space]
      } else if level == 2 {
        // Second level: Cyrillic letters (skipping forbidden chars)
        let letters = ("а", "б", "в", "г", "д", "е", "ж",
                      "и", "к", "л", "м", "н", "п", "р",
                      "с", "т", "у", "ф", "х", "ц", "ш",
                      "щ", "э", "ю", "я")
        if current <= letters.len() {
          [ #letters.at(current - 1)) #sym.space]
        } else {
          [ #current) #sym.space]
        }
      } else {
        // Third level: Arabic numerals with parenthesis
        [ #current)  #sym.space]
      }
    }
  )

  // Styling for code blocks
  #let style-code-line-number(number) = text(gray)[#number]
  #show raw.where(block: true): it => block(
    width: 100%,
    fill: white,
    stroke: 0.5pt,
    inset: 10pt,
    radius: 0pt,
    // добавляет нумерацию строк
    [ #set text(font: "JetBrains Mono")
      #grid(
      columns: (1em, 1fr),
      align: (right, left),
      column-gutter: 0.7em,
      row-gutter: 0.6em,
        ..it.lines
        .enumerate()
        .map(((i, line)) => (style-code-line-number(i + 1), line))
        .flatten())]
  )

  // Configure equation numbering
  #set math.equation(
    numbering: "(1)",
  )
  // Custom table of contents
  #let custom-toc() = [
    #set text(weight: "regular")
    #align(center)[СОДЕРЖАНИЕ]
    #v(20pt)

    #set par(first-line-indent: 0pt)
    #outline(
      depth: 3,
      title: none,
      indent: auto
    )
    #pagebreak(weak: true)
  ]
  // Import the indenta package to fix first paragraph indentation
  #import "@preview/indenta:0.0.3": fix-indent
  #show: fix-indent()

  #show selector(<nonumber>): set heading(numbering: none)

  #custom-toc()
  #doc
]
