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
total_count = {word: 0 for word in invertedIndex.keys()}
for i in range(num_of_texts):
    for token in tokenized_corpus[text_names[i]]:
        if freq_by_text[i][token] == 0:
            appears_in[token] += 1
        freq_by_text[i][token] += 1
        total_count[token] += 1

# frite word frequencies to file
with open("freq.txt", "w") as out:
    json.dump(total_count, out)

# TFIDF
for i in range(num_of_texts):
    for word in tfidf[i]:
        tfidf[i][word] = freq_by_text[i][word] * math.log10(num_of_texts/appears_in[word])


print("----------------------------------")
print("TFIDF words in 'austen-emma.txt'")
print("emma", tfidf[0]["emma"])
print("village", tfidf[0]["village"])
print("town", tfidf[0]["town"])
print("love", tfidf[0]["love"])
print("hate", tfidf[0]["hate"])

