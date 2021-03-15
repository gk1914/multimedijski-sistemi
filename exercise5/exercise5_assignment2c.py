from nltk.corpus import gutenberg
from nltk.tokenize import word_tokenize
import re
import numpy as np
import json
from collections import Counter


def make_unique(list1):
    return list(set(list1))


# Func: remove stop words from list (arg -> list1) of word tokens and clean them of non-alphanumeric chars
def filter_stop_words(list1):
    stop_words = ["", "a", "an", "and", "are", "as", "at", "be", "by", "for", "from", "has", "he", "in",
                  "is", "it", "its", "of", "on", "that", "the", "to", "was", "were", "will", "with"]
    filtered_list = []
    idx_list = []
    for i in range(len(list1)):
        word = list1[i]
        if re.sub(r'[^a-zA-Z0-9]', '', word) not in stop_words:
            filtered_list.append(re.sub(r'[^a-zA-Z0-9]', '', word))
            idx_list.append(i)
    return filtered_list, idx_list


# Func: remove stop words from string (arg -> 's')     [used for cleaning query]
def remove_stop(s):
    stop_words = ["", "a", "an", "and", "are", "as", "at", "be", "by", "for", "from", "has", "he", "in",
                  "is", "it", "its", "of", "on", "that", "the", "to", "was", "were", "will", "with"]
    filtered = ""
    for word in word_tokenize(s):
        if word not in stop_words:
            filtered += word + " "
    return filtered



# Func: add text names/ids (arg -> 'id') to inverted index (arg -> 'd')  for some word (arg -> 'word')
def add_to_dict(d, word, id):
    try:
        d[word].append(id)
    except:
        d[word] = [id]


# Func: add text names/ids (arg -> 'id') to inverted index (arg -> 'd')  for some word (arg -> 'word')
def add_positional(positional_index, word, id, p):
    try:
        count, dict = positional_index[word]
        add_to_dict(dict, id, p)
        positional_index[word] = count+1, dict
    except KeyError:
        positional_index[word] = (1, {id: [p]})


# Func: return list entry from inverted index (arg -> 'inverted_index') for some word (arg -> 'word')
#   or empty list if word isn't in the index
def ii(inverted_index, word):
    try:
        return inverted_index[word]
    except:
        return []


# Func: return list entry from positional index (arg -> 'positional_index') containging positions
#   of some word (arg -> 'word') in a specified document (arg -> 'id')
def pos(positional_index, word, id):
    try:
        return positional_index[word][1][id]
    except:
        return []


def in_range(a, b, k):
    return abs(a - b) <= k


# Func: find positions where words from the query (arg - 'phrase') appear within a certain distance (arg -> 'k')
#   of each other in a document (arg -> 'id')
def phrase_query(phrase, id, positional_index, k=5):
    tokens = word_tokenize(phrase)
    i = gutenberg.fileids().index(id)

    # test if all words are contained in document - to catch KeyError exception
    for word in tokens:
        if len(pos(positional_index, word, id)) == 0:
            print("One of the words in the query is not contained in the document")
            return []

    # first pair of words
    w1 = tokens[0]
    w2 = tokens[1]
    tokens = tokens[1:]
    result = []
    for p1 in pos(positional_index, w1, id):
        for p2 in pos(positional_index, w2, id):
            if in_range(p1, p2, k):
                result.append([p1, p2])

    # loop across rest of the words in the query
    for a, b in zip(tokens, tokens[1:]):
        previous = [r[-1] for r in result]
        new_result = []
        for p1 in pos(positional_index, a, id):
            if p1 in previous:
                for p2 in pos(positional_index, b, id):
                    if in_range(p1, p2, k):
                        for r in result:
                            # if the position of the 1st word of the current pair of words being queried is the same as
                            #   the last word of the already processed part of the query -> add position of 2nd word
                            #   to the end of that result set and save for use in processing rest of query
                            if r[-1] == p1:
                                new_result.append(r + [p2])
        result = new_result
        print("res: ", new_result)
    return result


# Func: find and print the text from a document (arg -> 'original') at a certain position (arg -> 'positions')
def find_in_org(original, positions, org_idx, padding=10):
    start = org_idx[positions[0]] - padding
    end = org_idx[positions[-1]] + padding
    punctuation = [',', ';', '.', '!', '?']
    result = ""
    for word in original[start:end]:
        if word not in punctuation:
            result += " " + word
        else:
            result += word
    print(result)
    return original[start:end]


# Func: query the phrase (arg -> 'query') in document (arg -> 'id') and print the results
def output(id, query, positional_index, ext=3):
    query = remove_stop(query)
    print("---> {}: \'{}\'".format(id, query))
    # execute query of the phrase
    out = phrase_query(query, id, positional_index, 7)
    # print results of the query
    for positions in out:
        p = sorted(positions)
        print(filtered_texts[id][p[0] - ext:p[-1] + ext + 1])
        find_in_org(tokenized_texts[id], p, org_index_list[id])





# ---------------------------------------------------------------------------------------------------------------------
# find all unique words contained in all texts from Gutenberg corpus
text_names = gutenberg.fileids()
all_tokens = {id: [] for id in text_names}
tokenized_texts  = {}
filtered_texts = {}
org_index_list = {}
all_words = set()
inverted_index = {}
positional_index = {}
for id in gutenberg.fileids():
    text = gutenberg.raw(id).lower()
    tokens = word_tokenize(text)
    tokenized_texts[id] = tokens
    filtered, org_idx = filter_stop_words(tokens)
    for i in range(len(filtered)):
        add_positional(positional_index, filtered[i], id, i)
    filtered_texts[id] = filtered
    org_index_list[id] = org_idx
    #with open("filtered_corpus/" + id, "w") as out:
    #    json.dump(filtered, out)
    #    print("saved to file")
    uniq = make_unique(filtered)
    all_tokens[id].extend(uniq)
    for word in uniq:
        add_to_dict(inverted_index, word, id)
    all_words = all_words | set(uniq)
print("Number of unique tokens in whole corpus: {}".format(len(all_words)))
print()

# save dictionary to file
with open("dictionary.txt", "w") as out:
    json.dump(inverted_index, out)
with open("positional.txt", "w") as out:
    json.dump(positional_index, out)
print("saved to file")

print("POSITIONAL INDEX ('word'):", positional_index["word"])


# ---------------------------------------------- QUERIES --------------------------------------------------------------
print()
print("----------------------------------------- QUERIES ------------------------------------------------------")
ext = 3
id = "bible-kjv.txt"
q = "jesus said disciples"
q = remove_stop(q)
output(id, q, positional_index)

q = "third day rose"
q = remove_stop(q)
output(id, q, positional_index)

id = "shakespeare-hamlet.txt"
q = "to be or not to be"
q = remove_stop(q)
output(id, q, positional_index)

id = "blake-poems.txt"
q = "sleep bed"
q = remove_stop(q)
output(id, q, positional_index)
q = "father mother"
q = remove_stop(q)
output(id, q, positional_index)


