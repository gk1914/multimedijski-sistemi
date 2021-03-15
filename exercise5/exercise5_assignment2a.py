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


# Func: return list entry from inverted index (arg -> 'inverted_index') for some word (arg -> 'word')
#   or empty list if word isn't in the index
def ii(inverted_index, word):
    try:
        return inverted_index[word]
    except:
        return []


# Func: parse search query (arg -> 'input') in the form of a list of words
def parse(input, inverted_index):
    operation = None
    negated = False
    skip = False
    # handle case where query begins with parenthesis expression
    if input[0] == "(":
        input = ["!NONEXISTENT!", "OR"] + input
    elif input[0] == "NOT" and input[1] == "(":
        input = ["!NONEXISTENT!", "OR"] + input
    elif input[0] == "NOT":
        negated = True
        input = input[1:]
    # create set containing query result and resolve first word in query
    curr_set = set(ii(inverted_index, input[0]))
    if negated:
        curr_set = complement(curr_set)
        negated = False
    input = input[1:]

    index = -1
    subexp_start, subexp_end = 0, 0
    # loop across words in query
    for word in input:
        index += 1
        if word == "(":
            subexp_start = index
            skip = True
            continue
        if word == ")":
            subexp_end = index
            skip = False
            # resolve expression surrounded by parenthases
            if negated:
                word_set = complement(parse(input[subexp_start+1:subexp_end], inverted_index))
            else:
                word_set = parse(input[subexp_start+1:subexp_end], inverted_index)
        if skip:
            continue
        if word in ["AND", "OR"]:
            operation = word
            continue
        if word == "NOT":
            negated = True
            continue
        # operation ready to be executed
        if operation:
            # create set of documents containing word
            if word != ")":
                if negated:
                    word_set = complement(set(ii(inverted_index, word)))
                else:
                    word_set = set(ii(inverted_index, word))
            # execute operation
            if operation == "AND":
                # AND
                curr_set = curr_set & word_set
            elif operation == "OR":
                # OR
                curr_set = curr_set | word_set
        operation = None
        negated = False
    return curr_set


def complement(s):
    return set(gutenberg.fileids()) - s




# ---------------------------------------------------------------------------------------------------------------------
# find all unique words contained in all texts from Gutenberg corpus
all_tokens = {id: [] for id in gutenberg.fileids()}
filtered_texts = {}
all_words = set()
inverted_index = {}
for id in gutenberg.fileids():
    text = gutenberg.raw(id).lower()
    tokens = word_tokenize(text)
    #print(id, len(tokens))
    filtered = filter_stop_words(tokens)
    filtered_texts[id] = filtered
    #with open("filtered_corpus/" + id, "w") as out:
        #json.dump(filtered, out)
        #print("saved to file")
    uniq = make_unique(filtered)
    #print(len(uniq))
    all_tokens[id].extend(uniq)
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




dictionary = inverted_index
print("----------------------- QUERIES--------------------------------------")
print("Blue: {}".format(dictionary["blue"]))
print("Yellow: {}".format(dictionary["yellow"]))
print("Blue OR yellow: {}".format(set(dictionary["blue"]) | set(dictionary["yellow"])))

print()
query = "dog AND cat AND NOT (blue OR yellow)"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))
query = "dog AND cat"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))
query = "NOT (blue OR yellow)"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))
query = "blue OR yellow"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))

print()
query = "NOT (war OR kill) AND (smiling OR happy)"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))
query = "war AND kill AND sword"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))
query = "NOT (happy AND NOT war) AND (NOT sunshine OR pistol)"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))
query = "NOT (happy AND NOT war)"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))
query = "happy AND NOT war"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))
query = "NOT sunshine OR pistol"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))

print()
query = "forest AND NOT (city OR town) OR (rabbit AND cow AND bear)"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))
query = "forest AND NOT (city AND town) OR (rabbit AND cow AND bear)"
res = list(sorted(parse(word_tokenize(query), inverted_index)))
print("{}: len={} {} ".format(query, len(res), res))




print()
print("end")
