'''with open('s1.txt') as f:
    content=f.readlines()


l=[line.strip() for line in content]
print(l) '''

import re
import nltk


def preprocess(text):
    # Basic cleaning
    text = text.strip()
    text = re.sub(r'[^\w\s]', '', text)
    text = text.lower()

    # token single comment
    tokens = nltk.word_tokenize(text)
    return tokens


def read_txt(file):
    with open(file, 'r') as f:
        return f.readlines()


if __name__ == '__main__':
    '''s1=read_txt('s1.txt')
    s2=read_txt('s2.txt')'''
    x = preprocess(read_txt('s1.txt')[0])
    y = preprocess(read_txt('s2.txt')[0])
    print(x)
    print(y)
    print(list(set(x).intersection(y)))