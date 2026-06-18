// =====================================================
// RESUME TEMPLATE - ENGLISH (US)
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
  lang: "en",
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
#document-header("en")

// --- 1. Summary ---
#block(breakable: false)[
  #section-header("SUMMARY")
  #parse-bold(resume-data.summary.en)
]

// --- 2. Experience ---
#section-header("EXPERIENCE")
#for entry in resume-data.experience.slice(0, resume-experience-limit) [
  #block(breakable: false)[
    #experience-entry(entry, "en")
  ]
]

// --- 3. Projects ---
#block(breakable: false)[
  #section-header("PROJECTS")
  #for project in resume-data.projects [
    #project-entry(project, "en")
  ]
]

// --- 4. Education ---
#block(breakable: false)[
  #section-header("EDUCATION")
  #for entry in resume-data.education.slice(0, resume-education-limit) [
    #education-entry(entry, "en")
  ]
]

// --- 5. Certifications ---
#block(breakable: false)[
  #section-header("CERTIFICATIONS")
  #for entry in resume-data.certifications [
    #certification-entry(entry, "en")
  ]
]

// --- 6. Skills ---
#section-header("SKILLS")
#for skill in resume-data.skills [
  #skill-category(skill.label.at("en"), skill.details, "en")
]

// --- 7. Languages ---
#block(breakable: false)[
  #section-header("LANGUAGES")
  #for lang in resume-data.languages [
    #language-item(lang, "en") \
  ]
]
