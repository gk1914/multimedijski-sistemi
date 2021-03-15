from nltk.corpus import gutenberg
from nltk.tokenize import word_tokenize
import re
import numpy as np
import json



def filter_stop_words(list1):
    stop_words = ["", "a", "an", "and", "are", "as", "at", "be", "by", "for", "from", "has", "he", "in",
                  "is", "it", "its", "of", "on", "that", "the", "to", "was", "were", "will", "with"]
    return [re.sub(r'[^a-zA-Z0-9]', '', el) for el in list1 if re.sub(r'[^a-zA-Z0-9]', '', el) not in stop_words]





# ---------------------------------------------------------------------------------------------------------------------
# find all unique words contained in all texts from Gutenberg corpus
for id in gutenberg.fileids():
    text = gutenberg.raw(id).lower()
    tokens = word_tokenize(text)
    #print(id, len(tokens))
    filtered = filter_stop_words(tokens)
    with open("filtered_corpus/" + id, "w") as out:
        json.dump(filtered, out)
        print("saved to file")
