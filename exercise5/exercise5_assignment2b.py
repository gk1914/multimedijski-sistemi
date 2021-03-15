from nltk.corpus import gutenberg
from nltk.tokenize import word_tokenize
import re
import numpy as np
import json
from collections import Counter


def make_unique(list1):
    return list(set(list1))


def filter_stop_words(list1):
    stop_words = ["", "a", "an", "and", "are", "as", "at", "be", "by", "for", "from", "has", "he", "in",
                  "is", "it", "its", "of", "on", "that", "the", "to", "was", "were", "will", "with"]
    return [re.sub(r'[^a-zA-Z0-9]', '', el) for el in list1 if re.sub(r'[^a-zA-Z0-9]', '', el) not in stop_words]


# Func: add text names/ids (arg -> 'id') to inverted index (arg -> 'd')  for some word (arg -> 'word')
def add_to_dict(d, word, id):
    try:
        d[word].append(id)
    except:
        d[word] = [id]


# Func: add text names/ids (arg -> 'id') to inverted index (arg -> 'd')  for some word (arg -> 'word')
def add_to_positional(pos_ind, word, id, i):
    try:
        pos_ind[word].append(id)
    except:
        pos_ind[word] = [id]


# Func: return list entry from inverted index (arg -> 'inverted_index') for some word (arg -> 'word')
#   or empty list if word isn't in the index
def ii(inverted_index, word):
    try:
        return inverted_index[word]
    except:
        return []




# ---------------------------------------------------------------------------------------------------------------------
# find all unique words contained in all texts from Gutenberg corpus
text_names = gutenberg.fileids()
all_tokens = {id: [] for id in text_names}
filtered_texts = {}
all_words = set()
inverted_index = {}
positional_index = [{} for id in text_names]
for id in gutenberg.fileids():
    text = gutenberg.raw(id).lower()
    tokens = word_tokenize(text)
    print(id, len(tokens))
    filtered = filter_stop_words(tokens)
    for i in range(len(filtered)):
        add_to_dict(positional_index[text_names.index(id)], filtered[i], i)
    filtered_texts[id] = filtered
    with open("filtered_corpus/" + id, "w") as out:
        json.dump(filtered, out)
        print("saved to file")
    uniq = make_unique(filtered)
    print(len(uniq))
    all_tokens[id].extend(uniq)
    #print(Counter(uniq))
    for word in uniq:
        add_to_dict(inverted_index, word, id)
    all_words = all_words | set(uniq)
print("Number of unique tokens in whole corpus: {}".format(len(all_words)))
print()

# save dictionary to file
with open("dictionary.txt", "w") as out:
    json.dump(inverted_index, out)
    print("saved to file")
    print(len(inverted_index))



print(positional_index[3]["king"])
print(positional_index[3]["god"])



print("end")
