import requests

def count_words(url):
    resp = requests.get(url)
    return len(resp.text.split())
