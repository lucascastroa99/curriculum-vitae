// =====================================================
// COVER LETTER TEMPLATE - ENGLISH
// =====================================================

#import "common.typ": *

// =====================================================
// PAGE SETUP
// =====================================================

#set page(
  paper: "a4",
  margin: 2.5cm,
)

#set text(
  font: "Source Sans 3",
  size: 12pt,
  fill: text-color,
  lang: "en",
)

#set par(
  justify: true,
  leading: 1.1em,
  spacing: 1.2em,
)

// =====================================================
// DOCUMENT BODY
// =====================================================

// --- Header ---
#document-header("en")

// --- Date ---
#align(right)[
  #v(16pt)
  #text(size: 12pt, fill: text-color)[#format-today("en")]
]

// --- Greeting ---
#v(24pt)
#text(size: 12pt, weight: "bold")[Dear Hiring Manager,]

// --- Body Paragraphs ---
#for paragraph in cover-letter-data.at("en").paragraphs [
  #v(12pt)
  #text(size: 12pt)[#parse-bold(paragraph)]
]

// --- Closing ---
#v(24pt)
#text(size: 12pt)[Sincerely,]

#v(8pt)
#text(size: 16pt, weight: "bold", fill: primary-color)[
  #personal.firstname #personal.lastname
]
