from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
import nltk

class FeatureExtractor():
    def __init__(self):
        self.stemmer = PorterStemmer()

    def tokenize(self, content):
        return word_tokenize(content)

    def filter_words(self, tokenized_content):
        # remove stopwords, punctuation and downacases
        filtered_words = []
        stop_words = set(stopwords.words("english"))
        ADDITIONAL_STOP_WORDS = {'january', 'please', 'download', 'https', 'email', 'detail', 'if', 'december', 'october', 'kb', 'february', 'within', 'november', 'may', 'please', '.mb', 'what', 'pdf', 'mach', 'good', 'august', 'september', 'html', 'july', 'june', 'beta', 'document', 'eg', 'published', 'april'}
        stop_words = stop_words | ADDITIONAL_STOP_WORDS

        punctuation = [ '\\', '>', '_', '`', '{', ']', '*', '[',
                        '^', '+', '!', '(', ':', ';', "'", "’",
                        '<', '|', '"', '?', '=', '}', '&', '/',
                        '$', ')', '~', '#', '%', ',' ]


        for word in tokenized_content:
            if word not in stop_words:
                if word not in punctuation and word.isalpha():
                    filtered_words.append(word.lower())

        return filtered_words

    def stem_words(self, words):

        return [self.stemmer.stem(word) for word in words]
