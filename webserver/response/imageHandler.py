from response.requestHandler import RequestHandler
import sys
from urllib.parse import parse_qs, urlparse
import redis
#from app.tasks import scrape_tag
from datetime import datetime

r = redis.Redis()
# print(f'redis: {str(r)}')

class CacheHandler(RequestHandler):
    def __init__(self):
        super().__init__()
        self.contentType = "text/html"
    
    def send_cache(self, page):
        self.contents = page
        self.setStatus(200)

    def getContents(self):
        return self.contents