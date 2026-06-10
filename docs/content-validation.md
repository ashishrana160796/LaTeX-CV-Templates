# Content Validation Ledger

## Ground Truth

The sole factual source for this update is:

```text
/Users/filewalker/Downloads/ashish_rana_two_column_cv
```

The source was read without modification. Its primary file SHA-256 values at migration time were:

- `cv.tex`: `6130ec7fd4ac79cf78d5a8b79d150012a14906bf9d862be797e7eae0599b3867`
- `section_experience_short.tex`: `e463e6bf0516d2dcd94852caaea4d5fe9fdca7969f54d2ac648650d5de6ebda2`
- `section_publications.tex`: `34c4bda6b2725673b03817eeefdd537518ddfc48e94ead4bf8e7d4226c998d26`
- `section_projets.tex`: `c3695abf673942194b94f6a0cbd26320e3ecd2fc56b1228fdd0bd16a2f2b9eb1`
- `section_scolarite.tex`: `517d5261477b9df06240028e3d88bca41aa51ed3cd967d30bd4561a062bf8377`

## Active Content Mapping

| Source content | English dual column | German dual column | Single-column handling |
| --- | --- | --- | --- |
| Header, contact details, profile tagline | `dual-column-cv/english/cv.tex` | `dual-column-cv/german/cv.tex` | Reproduced without a photograph in each single-column `cv.tex` |
| Education | English education section | German education section | Same language section is imported |
| Professional experience | English experience section | German experience section | Same language section is imported |
| Selected research work | English publications section | German publications section | Same language section is imported |
| Selected project achievements | English projects section | German projects section | Same language section is imported |
| References | English references section | German references section | Same language section is imported |
| Languages and interests | English languages section | German languages section | Same language section is imported |

Only content reached by the source `cv.tex` input sequence is active. Commented inputs and material enclosed by `\iffalse ... \fi` remain available but disabled.

## Permitted Source Corrections

No factual claims were added. The following unambiguous errors were corrected:

| Source text | Corrected text |
| --- | --- |
| `Profession Experience` | `Professional Experience` |
| `MLfLow` | `MLflow` |
| `BeautifulSoap` | `Beautiful Soup` |
| `congnitively-inspired` | `cognitively-inspired` |
| `Deutsche (B1)` | `German (B1)` in English and `Deutsch (B1)` in German |

German address typography uses `Marianne-Cohn-Straße` and `Deutschland`; this is localization of the same source address, not a factual change.

## Translation Policy

- German prose is translated naturally while retaining the exact source meaning.
- Sentence order may change for German grammar.
- Employer, institution, publication, and project names remain unchanged.
- Citations, dates, numerical values, URLs, email addresses, and telephone numbers remain unchanged.
- Technical names and acronyms remain in their established forms.
- Disabled German examples are translated but remain inside disabled blocks.

## Automated Checks

`make verify`:

1. Confirms that all four PDFs and eight page previews exist and are non-empty.
2. Scans all LaTeX logs for fatal errors, undefined commands, and missing glyphs.
3. Extracts text from every PDF.
4. Confirms common active markers including Ashish Rana, NEC Laboratories Europe, Oblivion, and American Express.
5. Confirms selected disabled examples do not appear in any PDF.

Visual page inspection is performed on the generated preview images and final PDFs after each clean build.
