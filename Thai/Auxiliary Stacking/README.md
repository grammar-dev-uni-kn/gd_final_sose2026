# Thai Auxiliary Stacking
Author: **Piyapath T Spencer**
Language under study: **Thai**
Phenomena: **Functional Heads, Auxiliary/Modal Stacking**


This repository provides an XLE grammar fragment for Thai's fixed-order auxiliary and modal stacking: fifteen preverbal and postverbal positions spanning mood, modality, tense and aspect, four of them heterosemous. No c-structure node is built for a position whose word is absent.

## How to

Start XLE from this folder. `xlerc` loads automatically and ends by calling `create-parser thai.lfg`.

```tcl
parse "เขาควรทำ"          ;# tokenizer, then parser
_xle_parse "เขา ควร ทำ"   ;# parser only, pre-segmented input
print-fs-as-prolog out.pl ;# c- and f-structure of the last parse
```

## Requirements

- **XLE** — obtained separately, under PARC's own license terms.
- **Python 3** on `PATH`, plus `pip install pythainlp`.
- **macOS GUI only** — Put Aqua **Tcl/Tk 8.6 (`tcltk/`, `tcl8.6/`, `tk8.6-aqua/`)** in the XLE binary; then run `utils/setup.sh` once to avoid XQuartz. Windows: `utils/setup.ps1`, untested.

## Files

| File | Description |
| --- | --- |
| `thai.lfg` | main entry file, `FILES`-includes the rest |
| `thai-rules.lfg` | `RULES` — the stacking and SVC machinery |
| `thai-templates.lfg` | `TEMPLATES` |
| `thai-features.lfg` | `FEATURES` — the `TAME` geometry |
| `thai-lex.lfg` | `LEXICON` |
| `testsuite.lfg` | 45 sentences: 35 grammatical, 10 ungrammatical |
| `common.features.lfg`, `common.templates.lfg` | shared `(STANDARD COMMON)` declarations |
| `xlerc` | XLE runtime config; instantiate the tokeniser, loads the grammar |
| `utils/th-tok.py` | Thai segmenter; its dictionary is derived from `thai-lex.lfg` |
| `utils/setup.sh`, `utils/setup.ps1` | one-time environment setup (macOS / Windows) |
| `utils/bin/` | contains Tcl/Tk 8.6, to be put in the XLE binary |
| `documentation.pdf` | a project documentation |


## Scope

Syntax only: no semantics, no discourse, and no disambiguation of readings that are genuinely ambiguous at the syntax level (postverbal ได้, completive vs. abilitative). The lexicon exists to exercise the auxiliary system and nothing more — six verbs, one object-control verb, one pronoun, two nouns, one complementizer, eleven auxiliary/modal forms.
