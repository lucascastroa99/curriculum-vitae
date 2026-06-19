// =====================================================
// COVER LETTER TEMPLATE - PORTUGUESE (BRAZIL)
// =====================================================

#import "common.typ": *

#set document(
  title: personal.firstname + " " + personal.lastname + " - Carta de Apresentação",
  author: personal.firstname + " " + personal.lastname,
  description: "Carta de apresentação para " + personal.position.pt,
  keywords: ("carta de apresentação", personal.position.pt),
  date: datetime.today(),
)

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
  lang: "pt",
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
#document-header("pt")

// --- Date ---
#align(right)[
  #v(16pt)
  #text(size: 12pt, fill: text-color)[#format-today("pt")]
]

// --- Greeting ---
#v(24pt)
#text(size: 12pt, weight: "bold")[Prezados(as),]

// --- Body Paragraphs ---
#for paragraph in cover-letter-data.at("pt").paragraphs [
  #v(12pt)
  #text(size: 12pt)[#parse-bold(paragraph)]
]

// --- Closing ---
#v(24pt)
#text(size: 12pt)[Atenciosamente,]

#v(8pt)
#text(size: 16pt, weight: "bold", fill: primary-color)[
  #personal.firstname #personal.lastname
]
