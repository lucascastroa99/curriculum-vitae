// =====================================================
// RESUME TEMPLATE - PORTUGUESE (BRAZIL)
// =====================================================

#import "common.typ": *

// =====================================================
// PAGE SETUP
// =====================================================

#set page(
  paper: "a4",
  margin: 1.5cm,
)

#set text(
  font: "Source Sans 3",
  size: 11pt,
  fill: text-color,
  lang: "pt",
)

#set par(
  justify: true,
  leading: 0.8em,
  spacing: 0.8em,
)

// =====================================================
// DOCUMENT BODY
// =====================================================

// --- Header ---
#document-header("pt")

// --- 1. Summary ---
#block(breakable: false)[
  #section-header("RESUMO")
  #parse-bold(resume-data.summary.pt)
]

// --- 2. Experience ---
#section-header("EXPERIÊNCIA")
#for entry in resume-data.experience.slice(0, resume-experience-limit) [
  #block(breakable: false)[
    #experience-entry(entry, "pt")
  ]
]

// --- 3. Projects ---
#block(breakable: false)[
  #section-header("PROJETOS")
  #for project in resume-data.projects [
    #project-entry(project, "pt")
  ]
]

// --- 4. Education ---
#block(breakable: false)[
  #section-header("EDUCAÇÃO")
  #for entry in resume-data.education.slice(0, resume-education-limit) [
    #education-entry(entry, "pt")
  ]
]

// --- 5. Certifications ---
#block(breakable: false)[
  #section-header("CERTIFICAÇÕES")
  #for entry in resume-data.certifications [
    #certification-entry(entry, "pt")
  ]
]

// --- 6. Skills ---
#section-header("HABILIDADES")
#for skill in resume-data.skills [
  #skill-category(skill.label.at("pt"), skill.details, "pt")
]

// --- 7. Languages ---
#block(breakable: false)[
  #section-header("IDIOMAS")
  #for lang in resume-data.languages [
    #language-item(lang, "pt") \
  ]
]
