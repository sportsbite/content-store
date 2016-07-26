import pdb
from pymongo import MongoClient

from feature_extractor import FeatureExtractor
extractor = FeatureExtractor()

client = MongoClient('mongodb://localhost/test')
db = client.content_store_development
collection = db.content_items
# items with content
content_items = collection.find({ 'content': {'$ne': None} })

print(content_items.count())
count = 0
for i in content_items:
    count = count + 1

    content = i['content']

    # tokenize
    tokenized_content = extractor.tokenize(content)

    # remove stopwords
    filtered_content = extractor.filter_words(tokenized_content)

    # stem
    parsed_content = extractor.stem_words(filtered_content)

    i['parsed_content'] = parsed_content

    db.content_items.save(i)

    if count % 250 == 0:
        print("processed #" + str(count) + " of " + str(content_items.count()))
