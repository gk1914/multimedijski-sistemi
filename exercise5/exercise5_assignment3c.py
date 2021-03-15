import json
import re
import math
from collections import Counter
from nltk.corpus import gutenberg
from nltk.tokenize import word_tokenize


def filter_stop_words(list1):
    stop_words = ["", "a", "an", "and", "are", "as", "at", "be", "by", "for", "from", "has", "he", "in",
                  "is", "it", "its", "of", "on", "that", "the", "to", "was", "were", "will", "with"]
    return [re.sub(r'[^a-zA-Z0-9]', '', el) for el in list1 if re.sub(r'[^a-zA-Z0-9]', '', el) not in stop_words]


def load_dict(file):
    with open(file, "r") as f:
        return json.load(f)


def my_tfidf(query):
    query = word_tokenize(query)
    scores = {id: 0 for id in gutenberg.fileids()}
    for document in scores.keys():
        for term in query:
            scores[document] += get_tfidf(document, term)
    sorted_scores = sorted(scores.items(), key=lambda x: x[1])[::-1]
    return sorted_scores[0:5]


def get_tfidf(text_name, term):
    ids = gutenberg.fileids()
    try:
        ret = tfidf[ids.index(text_name)][term]
        #print("{} (in {}) TFIDF: {}".format(term, text_name, ret))
    except:
        ret = 0
        #print("{} (in {}) TFIDF: 0   (term doesn't appear in document or may be a removed stop word)".format(term, text_name))
    return ret


#----------------------------------------------------------------------------------------------------------------------
text_names = gutenberg.fileids()
num_of_texts = len(text_names)
# build inverted index
invertedIndex = load_dict("dictionary.txt")

# tokenize texts - create list containing tokenized texts
tokenized_corpus = {id: [] for id in text_names}
for id in text_names:
    text = word_tokenize(gutenberg.raw(id).lower())
    text = filter_stop_words(text)
    tokenized_corpus[id].extend(text)
    print("Text \'{}\': length={} and {}".format(id, len(tokenized_corpus[id]), len(set(tokenized_corpus[id]))))

# word frequency - count occurances of all unique words in each text from the corpus
freq_by_text = [{word: 0 for word in invertedIndex.keys()} for id in text_names]
tfidf = [{word: 0 for word in invertedIndex.keys()} for id in text_names]
appears_in = {word: 0 for word in invertedIndex.keys()}
for i in range(num_of_texts):
    for token in tokenized_corpus[text_names[i]]:
        if freq_by_text[i][token] == 0:
            appears_in[token] += 1
        freq_by_text[i][token] += 1

# TFIDF
for i in range(num_of_texts):
    for word in tfidf[i]:
        tfidf[i][word] = freq_by_text[i][word] * math.log10(num_of_texts/appears_in[word])


print()
print("-----------------------------------------------------------------------------------")
print(tfidf[0]["emma"])
word = "emma"
id = "austen-emma.txt"
print("{} in {}: TFIDF={}".format(word, id, get_tfidf(id, word)))
word = "love"
id = "austen-emma.txt"
print("{} in {}: TFIDF={}".format(word, id, get_tfidf(id, word)))
word = "hate"
id = "austen-emma.txt"
print("{} in {}: TFIDF={}".format(word, id, get_tfidf(id, word)))
word = "love"
id = "shakespeare-hamlet.txt"
print("{} in {}: TFIDF={}".format(word, id, get_tfidf(id, word)))
word = "hate"
id = "shakespeare-hamlet.txt"
print("{} in {}: TFIDF={}".format(word, id, get_tfidf(id, word)))
word = "forest"
id = "burgess-busterbrown.txt"
print("{} in {}: TFIDF={}".format(word, id, get_tfidf(id, word)))
word = "bear"
id = "burgess-busterbrown.txt"
print("{} in {}: TFIDF={}".format(word, id, get_tfidf(id, word)))

print()
print("... multiple word queries ...")
q = "gun pistol"
print("{}: TFIDF={}".format(q, my_tfidf(q)))
q = "love joy happy"
print("{}: TFIDF={}".format(q, my_tfidf(q)))
q = "laughing children school"
print("{}: TFIDF={}".format(q, my_tfidf(q)))
q = "tragedy horrible evil"
print("{}: TFIDF={}".format(q, my_tfidf(q)))
q = "sea boat fish sail"
print("{}: TFIDF={}".format(q, my_tfidf(q)))


