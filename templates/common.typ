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
  v(10pt)
  heading(title, level: 2, outlined: false)
  pdf.artifact(line(length: 100%, stroke: 0.5pt + primary-color))
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
      #text(size: 10.5pt, fill: muted-color)[
        #link("https://www.google.com/maps/search/" + personal.location.at(lang))[#personal.location.at(lang)] #h(12pt) | #h(12pt)
        #link("mailto:" + personal.email)[#personal.email] #h(12pt) | #h(12pt)
        #link("tel:" + personal.phone)[#format-phone(personal.phone, lang)] \
        #link(personal.website)[#(personal.website.replace("https://", "").replace("http://", ""))] #h(12pt) | #h(12pt)
        #link("https://linkedin.com/in/" + personal.linkedin)[linkedin.com/in/#personal.linkedin] #h(12pt) | #h(12pt)
        #link("https://github.com/" + personal.github)[github.com/#personal.github]
      ]
    ]
  ]
}

#let section-entry(
  primary,
  secondary: none,
  start,
  end: none,
  right-line2: none,
  highlights: (),
  leading: 0.6em,
) = {
  let date-str = if end != none { [#start - #end] } else { start }
  
  block(width: 100%)[
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [
        #set par(leading: leading)
        #text(weight: "bold", size: 12pt)[#primary]
        #if secondary != none [
          \ #text(style: "italic", size: 11.5pt, fill: muted-color)[#secondary]
        ]
      ],
      [
        #set par(leading: leading)
        #text(size: 12pt, fill: muted-color)[#date-str]
        #if right-line2 != none [
          \ #text(size: 11.5pt, fill: muted-color)[#right-line2]
        ]
      ],
    )
    
    #if highlights.len() > 0 [
      #set par(leading: leading)
      #set list(marker: [•], body-indent: 0.8em, spacing: 0.6em)
      #for highlight in highlights [
        - #parse-bold(highlight)
      ]
    ]
  ]
  v(14pt, weak: true)
}

#let experience-entry(entry, lang) = {
  let end = if entry.date.end == "present" {
    if lang == "pt" { "Presente" } else { "Present" }
  } else {
    format-date(entry.date.end, lang)
  }
  
  section-entry(
    entry.position.at(lang),
    format-date(entry.date.start, lang),
    secondary: entry.company,
    end: end,
    right-line2: entry.location.at(lang),
    highlights: entry.highlights.at(lang),
    leading: 0.6em,
  )
}

#let project-entry(entry, lang) = {
  section-entry(
    entry.name,
    format-date(entry.date.start, lang),
    end: format-date(entry.date.end, lang),
    highlights: entry.highlights.at(lang),
    leading: 0.6em,
  )
}

#let education-entry(entry, lang) = {
  section-entry(
    entry.area.at(lang),
    format-date(entry.date.start, lang),
    secondary: entry.institution.at(lang),
    end: format-date(entry.date.end, lang),
    right-line2: entry.location.at(lang),
    leading: 0.4em,
  )
}

#let certification-entry(entry, lang) = {
  section-entry(
    entry.area,
    format-date(entry.date.start, lang),
    secondary: entry.institution,
    right-line2: entry.score.at(lang),
    leading: 0.4em,
  )
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
