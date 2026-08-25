#!/usr/bin/env python3
import sys
import os
import re
from pythainlp.tokenize import Tokenizer

GRAMMAR_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'thai-lex.lfg')

def extract_lexicon_words(path):
    words = set()
    in_lexicon = False
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            if re.search(r'LEXICON\s*\(', line):
                in_lexicon = True
                continue
            if re.match(r'^----', line):
                in_lexicon = False
                continue
            if in_lexicon:
                m = re.match(r'^(\S+)\s+[A-Z_]', line)
                if m:
                    word = m.group(1)
                    if not word.startswith(('+', '-', '`', '[', ']', ',')):
                        words.add(word)
    return words

words = extract_lexicon_words(GRAMMAR_FILE)
thai_words = frozenset(w for w in words if re.search(r'[ก-๿]', w))

tokenizer = Tokenizer(thai_words)
text = sys.stdin.read().strip()
print(' '.join(tokenizer.word_tokenize(text)))
