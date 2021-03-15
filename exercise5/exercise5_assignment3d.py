import re
import json
from string import ascii_lowercase
from nltk import word_tokenize



def load_dict(file):
    with open(file, "r") as f:
        return json.load(f)


my_dict = load_dict("dictionary.txt").keys()
positional_index = load_dict("positional.txt")
#print(positional_index)


def autocorrect(word):
    print("in = {}".format(word))
    if word in my_dict:
        print("OUT: {} (already correct)".format(word))
        return

    # correct up to one error in the word
    suggestions1 = []
    for w in correct1(word):
        if w in my_dict:
            #print(w)
            suggestions1.append(w)
        if ' '  in w:
            if set(w.split()).issubset(set(my_dict)):
                #print(w)
                suggestions1.append(w)

    # suggest most probable corrections
    suggestions1 = list(set(suggestions1))
    sorted = []
    for word in suggestions1:
        if ' ' in word:
            w1 = word.split()[0]
            w2 = word.split()[1]
            curr_freq = (positional_index[w1][0] + positional_index[w2][0]) / 2
        else:
            curr_freq = positional_index[word][0]
        j = 0
        for i in range(len(sorted)):
            if ' ' in sorted[i]:
                w1 = sorted[i].split()[0]
                w2 = sorted[i].split()[1]
                i_freq = (positional_index[w1][0] + positional_index[w2][0])/2
            else:
                i_freq = positional_index[sorted[i]][0]
            if curr_freq < i_freq:
                j += 1
            else:
                break
        sorted = sorted[:j] + [word] + sorted[j:]
    #print(suggestions1)
    print("Suggested words with 1 edit necessary: {}".format(sorted))

    # correct up to two errors in the word
    suggestions2 = []
    for w in correct2(word):
        if w in my_dict and w not in suggestions1:
            # print(w)
            suggestions2.append(w)

    # suggest most probable corrections
    suggestions2 = list(set(suggestions2))
    sorted = []
    for word in suggestions2:
        if ' ' in word:
            w1 = word.split()[0]
            w2 = word.split()[1]
            curr_freq = (positional_index[w1][0] + positional_index[w2][0]) / 2
        else:
            curr_freq = positional_index[word][0]
        j = 0
        for i in range(len(sorted)):
            if ' ' in sorted[i]:
                w1 = sorted[i].split()[0]
                w2 = sorted[i].split()[1]
                i_freq = (positional_index[w1][0] + positional_index[w2][0]) / 2
            else:
                i_freq = positional_index[sorted[i]][0]
            if curr_freq < i_freq:
                j += 1
            else:
                break
        sorted = sorted[:j] + [word] + sorted[j:]
    #print(suggestions2)
    print("Suggested words with 2 edits necessary: {}".format(sorted))
    print()


def autocorrect_query(query):
    for word in word_tokenize(query):
        autocorrect(word)


def correct1(word):
    split = [word[:i] + " " + word[i:] for i in range(1, len(word))]
    replace = [word[:i] + c + word[i+1:] for i in range(len(word)) for c in ascii_lowercase]
    insert = [word[:i] + c + word[i:] for i in range(len(word)) for c in ascii_lowercase]
    remove = [word[:i] + word[i+1:] for i in range(len(word)) for c in ascii_lowercase]
    switch = [word[:i] + word[i+1] + word[i] + word[i+2:] for i in range(len(word)-1)]

    suggestions = set(split) | set(replace) | set(insert) | set(remove) | set(switch)
    return suggestions


def correct2(word):
    suggestions = set([two for one in correct1(word) for two in correct1(one)])
    return suggestions


autocorrect("seper ated")
autocorrect("twowords")
autocorrect("speling")
autocorrect("miscake")
autocorrect("disdko")
autocorrect("correct")
