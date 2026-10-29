#let src-file = sys.inputs.at("src", default: "/cv-mtdefelice.txt")
#let raw-text = read(if src-file.starts-with("/") { src-file } else { "/" + src-file })
#let lines = raw-text.split("\n").map(l => l.trim(at: end, "\r"))

// Parse header (Line 0: Name, Line 1: Email)
#let author-name = lines.at(0, default: "Michael DeFelice").trim()
#let author-email = lines.at(1, default: "michael.defelice@gmail.com").trim()

// Pure Black & White Palette
#let ink = rgb("#000000")
#let body-ink = rgb("#000000")
#let muted = rgb("#000000")
#let accent = rgb("#000000")
#let rule-color = rgb("#000000")
#set document(
  title: author-name + " - Resume",
  author: author-name,
  date: none,
)

#set page(
  paper: "us-letter",
  margin: (top: 0.65in, bottom: 0.65in, x: 0.72in),
  footer: context {
    let pg = counter(page).get().first()
    let total = counter(page).final().first()
    if total > 1 {
      v(0.2em)
      block(width: 100%)[
        #text(size: 8.5pt, fill: ink)[#author-name]#h(1fr)#text(size: 8.5pt, fill: ink)[Page #pg of #total]
      ]
    }
  }
)

#set text(
  font: ("Open Sans", "Liberation Sans", "Noto Sans"),
  size: 9.5pt,
  fill: body-ink,
  lang: "en",
)

#set par(
  justify: false,
  leading: 0.58em,
  spacing: 0.78em,
)

#set list(
  marker: text(fill: accent, size: 8.5pt)[•],
  indent: 0.35em,
  body-indent: 0.55em,
  spacing: 0.55em,
)

// Section heading with horizontal line, sticky to next block, generous padding
#let section-heading(title) = {
  v(1.4em)
  block(
    width: 100%,
    sticky: true,
    below: 1.0em,
    stroke: (bottom: 0.4pt + rule-color),
    inset: (bottom: 5pt),
    text(
      size: 10pt,
      weight: "bold",
      fill: ink,
      tracking: 0.07em,
      upper(title),
    )
  )
}

// Render Header
#block(width: 100%, below: 2.0em)[
  #align(center)[
    #block(below: 12pt)[
      #text(size: 21pt, weight: "bold", fill: ink, tracking: 0.04em)[#upper(author-name)]
    ]
    #text(size: 8.5pt, fill: muted)[
      #link("mailto:" + author-email)[#author-email]
      #h(0.75em) #text(fill: rule-color)[|] #h(0.75em)
      #link("https://mtdefelice.github.io")[mtdefelice.github.io]
      #h(0.75em) #text(fill: rule-color)[|] #h(0.75em)
      #link("https://www.linkedin.com/in/mtdefelice")[linkedin.com/in/mtdefelice]
    ]
  ]
]

// Parse body lines starting from line 2
#{
  let section = ""
  let first-role = true
  let i = 2
  let n = lines.len()
  let date-regex = regex("^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\\s+\\d{4}\\s+-\\s+.*")

  while i < n {
    let line = lines.at(i)
    let trimmed = line.trim()

    if trimmed == "" {
      i += 1
      continue
    }

    // Top-level section header (starts at column 0, ends with ':', not "Key contributions...")
    if not line.starts-with(" ") and not line.starts-with("\t") and trimmed.ends-with(":") and not trimmed.starts-with("Key contributions") {
      section = trimmed.slice(0, -1)
      if section == "Work Experience" { first-role = true }
      section-heading(section)
      i += 1
      continue
    }

    if section == "Summary" or section == "Skills" {
      block(
        width: 100%,
        below: 0.6em,
        text(size: 9.5pt, fill: body-ink)[#trimmed]
      )
      i += 1
    } else if section == "Core Technical Stack" or section.starts-with("Languages") {
      if trimmed.ends-with(":") {
        let sub-label = trimmed.slice(0, -1)
        let detail = ""
        if i + 1 < n and lines.at(i + 1).trim() != "" and (lines.at(i + 1).starts-with(" ") or lines.at(i + 1).starts-with("\t")) {
          detail = lines.at(i + 1).trim()
          i += 2
        } else {
          i += 1
        }
        block(width: 100%, below: 0.9em)[
          #block(width: 100%, below: 0.55em)[#text(weight: "bold", fill: ink)[#sub-label:]]
          #detail
        ]
      } else {
        par[#trimmed]
        i += 1
      }
    } else if section == "Work Experience" {
      if trimmed.matches(date-regex).len() > 0 {
        let date-str = trimmed
        let company-str = if i + 1 < n { lines.at(i + 1).trim() } else { "" }
        i += 2

        // Collect role paragraphs and bullets for this role
        let summary-paras = ()
        let bullets = ()

        while i < n {
          let rl = lines.at(i)
          let rt = rl.trim()
          if rt == "" {
            i += 1
            continue
          }
          // Stop if next section or next job date
          if (not rl.starts-with(" ") and not rl.starts-with("\t") and rt.ends-with(":") and not rt.starts-with("Key contributions")) or rt.matches(date-regex).len() > 0 {
            break
          }
          if rt.starts-with("Key contributions") {
            i += 1
            continue
          }
          if rt.starts-with("* ") {
            bullets.push(rt.slice(2))
          } else {
            summary-paras.push(rt)
          }
          i += 1
        }

        // Render entire role (header + summary + bullets) as an unbreakable block so bullets never split across pages
        let top-gap = if first-role { 1.0em } else { 1.55em }
        first-role = false
        block(width: 100%, above: top-gap, below: 1.2em, breakable: false)[
          #block(width: 100%, below: 0.72em)[
            #text(weight: "bold", size: 10.5pt, fill: ink)[#company-str]#h(1fr)#text(weight: "regular", size: 9pt, fill: ink)[#date-str]
          ]
          #for (idx, sp) in summary-paras.enumerate() [
            #block(width: 100%, below: if bullets.len() > 0 or idx + 1 < summary-paras.len() { 0.68em } else { 0em })[#sp]
          ]
          #if bullets.len() > 0 [
            #for b in bullets {
              list.item[#b]
            }
          ]
        ]
      } else {
        par[#trimmed]
        i += 1
      }
    } else if section == "Patents" or section == "Education" or section == "Volunteer Experience" {
      let colon-idx = trimmed.position(":")
      if colon-idx != none {
        let left-part = trimmed.slice(0, colon-idx)
        let right-part = trimmed.slice(colon-idx + 1).trim()
        if section == "Patents" {
          list.item[#link("https://patents.google.com/patent/" + left-part)[#text(weight: "bold", fill: accent)[#left-part]]: #right-part]
        } else {
          list.item[#text(weight: "bold", fill: ink)[#left-part]: #right-part]
        }
      } else {
        list.item[#trimmed]
      }
      i += 1
    } else {
      par[#trimmed]
      i += 1
    }
  }
}
