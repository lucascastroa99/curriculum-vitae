const fs = require("fs");
const path = require("path");
const YAML = require("yaml");
const nunjucks = require("nunjucks");

const ROOT = path.resolve(__dirname, "..");
const PERSONAL_FILE = path.join(ROOT, "data", "personal.yaml");
const RESUME_FILE = path.join(ROOT, "data", "resume.yaml");
const COVER_LETTER_FILE = path.join(ROOT, "data", "cover-letter.yaml");
const EMAIL_FILE = path.join(ROOT, "data", "email.yaml");
const TEMPLATES_DIR = path.join(ROOT, "templates");
const OUTPUT_DIR = path.join(ROOT, "output");

const MONTHS = {
  pt: {
    "01": "Janeiro", "02": "Fevereiro", "03": "Março", "04": "Abril",
    "05": "Maio", "06": "Junho", "07": "Julho", "08": "Agosto",
    "09": "Setembro", "10": "Outubro", "11": "Novembro", "12": "Dezembro",
  },
  en: {
    "01": "January", "02": "February", "03": "March", "04": "April",
    "05": "May", "06": "June", "07": "July", "08": "August",
    "09": "September", "10": "October", "11": "November", "12": "December",
  },
};

const TYPE_CONFIG = {
  cover: {
    template: (lang) => `cover-letter-${lang}.njk`,
    outputs: {
      pt: "LucasCastro_DesenvolvedorFullStack_CartaApresentacaoMarkdown.md",
      en: "LucasCastro_FullStackDeveloper_MarkdownCoverLetter.md",
    },
  },
  resume: {
    template: (lang) => `resume-${lang}.njk`,
    outputs: {
      pt: "LucasCastro_DesenvolvedorFullStack_CurriculoMarkdownCompleto.md",
      en: "LucasCastro_FullStackDeveloper_FullMarkdownResume.md",
    },
  },
  email: {
    template: (lang) => `email-${lang}.njk`,
    outputs: {
      pt: "LucasCastro_DesenvolvedorFullStack_EmailMarkDown.md",
      en: "LucasCastro_FullStackDeveloper_EmailMarkDown.md",
    },
  },
};

function get(field, lang) {
  if (field == null) return "";
  if (typeof field === "string") return field;
  if (typeof field === "object" && field[lang] !== undefined) return field[lang];
  return "";
}

function formatPhone(phone, lang) {
  const digits = phone.replace(/\+/g, "");
  const country = digits.slice(0, 2);
  const area = digits.slice(2, 4);
  const number = digits.slice(4);
  const formatted = `(${area}) ${number.slice(0, 1)} ${number.slice(1, 5)}-${number.slice(5)}`;
  return lang === "en" ? `+${country} ${formatted}` : formatted;
}

function formatDate(dateStr, lang) {
  if (!dateStr || dateStr === "present") {
    if (dateStr === "present") return lang === "pt" ? "Presente" : "Present";
    return "";
  }
  const [year, month] = dateStr.split("-");
  const monthName = MONTHS[lang]?.[month] || month;
  return `${monthName} ${year}`;
}

function getTodayFormatted(lang) {
  const today = new Date();
  const day = today.getDate();
  const month = String(today.getMonth() + 1).padStart(2, "0");
  const year = today.getFullYear();
  const monthName = MONTHS[lang][month];
  return lang === "pt" ? `${day} de ${monthName} de ${year}` : `${monthName} ${day}, ${year}`;
}

function loadData() {
  const personal = YAML.parse(fs.readFileSync(PERSONAL_FILE, "utf8"));
  const resume = YAML.parse(fs.readFileSync(RESUME_FILE, "utf8"));
  const coverLetter = YAML.parse(fs.readFileSync(COVER_LETTER_FILE, "utf8"));
  const email = YAML.parse(fs.readFileSync(EMAIL_FILE, "utf8"));
  return { personal, ...resume, coverLetter, email };
}

function createEnv() {
  const env = new nunjucks.Environment(new nunjucks.FileSystemLoader(TEMPLATES_DIR), {
    autoescape: false,
  });

  env.addFilter("field", function (field, lang) {
    return get(field, lang);
  });

  env.addFilter("phone", function (phone, lang) {
    return formatPhone(phone, lang);
  });

  env.addFilter("formatDate", function (dateStr, lang) {
    return formatDate(dateStr, lang);
  });

  env.addFilter("skillDetails", function (details, lang) {
    if (details == null) return "";
    if (typeof details === "string") return details;
    if (typeof details === "object") return details[lang] || "";
    return "";
  });

  return env;
}

function parseFlag(name) {
  const flag = process.argv.find((arg) => arg.startsWith(`--${name}=`));
  return flag ? flag.split("=")[1] : null;
}

function main() {
  const type = parseFlag("type");
  const lang = parseFlag("lang");

  if (!type || !TYPE_CONFIG[type]) {
    console.error("Usage: node scripts/generate-markdown.js --type=<cover|resume|email> [--lang=<en|pt>]");
    process.exit(1);
  }

  const config = TYPE_CONFIG[type];
  const languages = [
    { lang: "pt", filename: config.outputs.pt },
    { lang: "en", filename: config.outputs.en },
  ];

  const filtered = lang ? languages.filter((l) => l.lang === lang) : languages;

  if (lang && filtered.length === 0) {
    console.error(`Unknown language: ${lang}. Use --lang=en or --lang=pt.`);
    process.exit(1);
  }

  const data = loadData();
  const env = createEnv();

  for (const { lang: l, filename } of filtered) {
    const context = type === "cover" ? { lang: l, date: getTodayFormatted(l) } : { lang: l };
    const rendered = env.render(config.template(l), { data, ...context });
    const outPath = path.join(OUTPUT_DIR, filename);
    fs.writeFileSync(outPath, rendered, "utf8");
    console.log(`  -> output/${filename}`);
  }

  console.log("\nDone!");
}

main();
