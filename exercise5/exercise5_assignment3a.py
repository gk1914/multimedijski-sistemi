import json
import re
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
appears_in = {word: 0 for word in invertedIndex.keys()}
for i in range(num_of_texts):
    curr_set = set([])
    for token in tokenized_corpus[text_names[i]]:
        if freq_by_text[i][token] == 0:
            appears_in[token] += 1
        freq_by_text[i][token] += 1




print("-----------------------------------------------------------------")
print("god: {}".format(appears_in["god"]))
print("cat: {}".format(appears_in["cat"]))
print("dog: {}".format(appears_in["dog"]))
print("pistol: {}".format(appears_in["pistol"]))
print("murder: {}".format(appears_in["murder"]))
print("love: {}".format(appears_in["love"]))

print("god (freq in bible): {}".format(freq_by_text[3]["god"]))
print("devil (freq in bible): {}".format(freq_by_text[3]["devil"]))