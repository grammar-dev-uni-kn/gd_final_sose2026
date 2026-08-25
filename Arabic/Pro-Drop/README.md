# Arabic Pro-Drop in LFG

## Author
Ahmad Alatrash  
M.A. Speech and Language Processing  
University of Konstanz, SoSe 2026

## Language
Modern Standard Arabic (MSA)

## Linguistic Phenomenon
**Pro-drop** — the omission of overt subject pronouns, licensed by rich verb agreement morphology.

The grammar also covers:
- Subject-verb agreement (person, number, gender)
- VSO/SVO word order alternation via structural case
- Morphological definiteness (al- prefix)
- Transitive vs. intransitive verb valency

## Files

| File | Description |
|---|---|
| `arabic_prodrop.lfg` | Main grammar file |
| `arabic_prodrop.testsuite.lfg` | Testsuite (15 grammatical, 5 ungrammatical) |
| `common.templates.lfg` | ParGram common templates (required) |
| `.xlerc` | Auto-loads grammar on XLE startup |
| `Arabic_ProDrop_Report.pdf` | Project report with Leipzig glosses |
| `README.md` | This file |

## Loading the Grammar
Launch XLE in the project directory. The grammar can be compiled manually by running:

```bash
create-parser arabic_prodrop.lfg
