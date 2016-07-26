Requirements:

- Python3
- pip3 http://askubuntu.com/questions/412178/how-to-install-pip-for-python-3-in-ubuntu-12-04-lts

Install packages:

`sudo pip3 install -r requirements.py`

You will need to import nltk data, like this:
```
import nltk
nltk.download('punkt')
nltk.download('stopwords')
```
