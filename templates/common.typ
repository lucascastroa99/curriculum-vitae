// =====================================================
// COMMON - Shared resume components
// =====================================================

// =====================================================
// 1. DATA & CONFIGURATION
// =====================================================

#let personal = yaml("../data/personal.yaml")
#let resume-data = yaml("../data/resume.yaml")
#let cover-letter-data = yaml("../data/cover-letter.yaml")

#let resume-experience-limit = 4
#let resume-education-limit = 1

#let primary-color = rgb("#2176FF")
#let text-color = rgb("#212121")
#let muted-color = rgb("#616161")

#let fa(icon) = text(font: "Font Awesome 7 Free Solid", size: 9pt)[#str.from-unicode(icon)]
#let fab(icon) = text(font: "Font Awesome 7 Brands", size: 9pt)[#str.from-unicode(icon)]

// =====================================================
// 2. UTILITIES
// =====================================================

#let month-maps = (
  "pt": (
    "01": "Janeiro",
    "02": "Fevereiro",
    "03": "Março",
    "04": "Abril",
    "05": "Maio",
    "06": "Junho",
    "07": "Julho",
    "08": "Agosto",
    "09": "Setembro",
    "10": "Outubro",
    "11": "Novembro",
    "12": "Dezembro",
  ),
  "en": (
    "01": "January",
    "02": "February",
    "03": "March",
    "04": "April",
    "05": "May",
    "06": "June",
    "07": "July",
    "08": "August",
    "09": "September",
    "10": "October",
    "11": "November",
    "12": "December",
  ),
)

#let format-phone(phone, lang) = {
  let digits = phone.replace("+", "")
  let country = digits.slice(0, 2)
  let area = digits.slice(2, 4)
  let number = digits.slice(4)
  let formatted = "(" + area + ") " + number.slice(0, 1) + " " + number.slice(1, 5) + "-" + number.slice(5)
  if lang == "en" { "+" + country + " " + formatted } else { formatted }
}

#let format-date(date, lang) = {
  if date == none { return "" }
  let parts = date.split("-")
  let year = parts.at(0)
  let month = month-maps.at(lang).at(parts.at(1), default: parts.at(1))
  return month + " " + year
}

#let format-today(lang) = {
  let today = datetime.today()
  let day = today.day()
  let month-num = today.month()
  let month-key = if month-num < 10 { "0" + str(month-num) } else { str(month-num) }
  let month = month-maps.at(lang).at(month-key)
  let year = today.year()
  if lang == "pt" {
    [#day de #month de #year]
  } else {
    [#month #day, #year]
  }
}

#let parse-bold(text) = {
  let result = ()
  let parts = text.split("**")
  for (i, part) in parts.enumerate() {
    if part == "" { continue }
    if calc.odd(i) {
      result.push(strong(part))
    } else {
      result.push(part)
    }
  }
  result.join()
}

// =====================================================
// 3. LAYOUT COMPONENTS
// =====================================================

#let section-header(title) = {
  v(8pt)
  block(width: 100%)[
    #set par(spacing: 8pt)
    #text(size: 14pt, weight: "bold", fill: primary-color)[#title]
    #line(length: 100%, stroke: 0.5pt + primary-color)
  ]
}

#let document-header(lang) = {
  align(center)[
    #stack(dir: ttb, spacing: 8pt)[
      #text(size: 30pt, weight: "bold", fill: primary-color)[
        #personal.firstname #personal.lastname
      ]
    ][
      #text(size: 12.5pt, fill: muted-color)[
        #personal.position.at(lang)
      ]
    ][
      #stack(dir: ttb, spacing: 3pt)[
        #text(size: 10.5pt, fill: muted-color)[
          #fa(0xf3c5) #h(0.3em) #link(
            "https://www.google.com/maps/search/" + personal.location.at(lang),
          )[#personal.location.at(lang)] #h(20pt)
          #fa(0xf0e0) #h(0.3em) #link("mailto:" + personal.email)[#personal.email] #h(20pt)
          #fa(0xf095) #h(0.3em) #link("tel:" + personal.phone)[#format-phone(personal.phone, lang)]
        ]
      ][
        #text(size: 10.5pt, fill: muted-color)[
          #fa(0xf0ac) #h(0.3em) #link(personal.website)[#(
            personal.website.replace("https://", "").replace("http://", "")
          )] #h(20pt)
          #fab(0xf08c) #h(0.3em) #link("https://linkedin.com/in/" + personal.linkedin)[linkedin.com/in/#personal.linkedin] #h(
            20pt,
          )
          #fab(0xf09b) #h(0.3em) #link("https://github.com/" + personal.github)[github.com/#personal.github]
        ]
      ]
    ]
  ]
}

#let experience-entry(entry, lang) = {
  let pos = entry.position.at(lang)
  let company = entry.company
  let start = format-date(entry.date.start, lang)
  let end = if entry.date.end == "present" {
    if lang == "pt" { "Presente" } else { "Present" }
  } else {
    format-date(entry.date.end, lang)
  }
  let loc = entry.location.at(lang)

  block(width: 100%)[
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [
        #set par(leading: 0.6em)
        #text(weight: "bold", size: 12pt)[#pos] \
        #text(style: "italic", size: 11.5pt, fill: muted-color)[#company]
      ],
      [
        #set par(leading: 0.6em)
        #text(size: 12pt, fill: muted-color)[#start – #end] \
        #text(size: 11.5pt, fill: muted-color)[#loc]
      ],
    )

    #set par(leading: 0.6em)
    #set list(marker: [•], body-indent: 0.8em, spacing: 0.6em)
    #for highlight in entry.highlights.at(lang) [
      - #parse-bold(highlight)
    ]
  ]
  v(6pt)
}

#let project-entry(entry, lang) = {
  let name = entry.name
  let start = format-date(entry.date.start, lang)
  let end = format-date(entry.date.end, lang)

  block(width: 100%)[
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [
        #set par(leading: 0.6em)
        #text(weight: "bold", size: 12pt)[#name]
      ],
      [
        #set par(leading: 0.6em)
        #text(size: 12pt, fill: muted-color)[#start – #end]
      ],
    )

    #set par(leading: 0.6em)
    #set list(marker: [•], body-indent: 0.8em, spacing: 0.6em)
    #for highlight in entry.highlights.at(lang) [
      - #parse-bold(highlight)
    ]
  ]
  v(6pt)
}

#let education-entry(entry, lang) = {
  let area = entry.area.at(lang)
  let institution = entry.institution.at(lang)
  let start = format-date(entry.date.start, lang)
  let end = format-date(entry.date.end, lang)
  let loc = entry.location.at(lang)

  block(width: 100%)[
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [
        #set par(leading: 0.4em)
        #text(weight: "bold", size: 12pt)[#area] \
        #text(style: "italic", size: 11.5pt, fill: muted-color)[#institution]
      ],
      [
        #set par(leading: 0.4em)
        #text(size: 12pt, fill: muted-color)[#start – #end] \
        #text(size: 11.5pt, fill: muted-color)[#loc]
      ],
    )
  ]
  v(6pt)
}

#let certification-entry(entry, lang) = {
  let area = entry.area
  let institution = entry.institution
  let start = format-date(entry.date.start, lang)
  let score = entry.score.at(lang)

  block(width: 100%)[
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [
        #set par(leading: 0.4em)
        #text(weight: "bold", size: 12pt)[#area] \
        #text(style: "italic", size: 11.5pt, fill: muted-color)[#institution]
      ],
      [
        #set par(leading: 0.4em)
        #text(size: 12pt, fill: muted-color)[#score] \
        #text(size: 11.5pt, fill: muted-color)[#start]
      ],
    )
  ]
  v(6pt)
}

#let skill-category(label, details, lang) = {
  let detail-text = if type(details) == dictionary {
    details.at(lang, default: "")
  } else {
    details
  }
  text(size: 12pt)[
    #text(weight: "bold")[#label:] #detail-text
  ]
  linebreak()
}

#let language-item(entry, lang) = {
  let label = entry.label.at(lang)
  let level = entry.level.at(lang)

  text(size: 12pt)[
    #text(weight: "bold")[#label:] #level
  ]
}
