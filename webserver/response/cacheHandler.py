from response.requestHandler import RequestHandler
import sys
from urllib.parse import parse_qs, urlparse
from app.tasks import scrape_tag
from datetime import datetime
from json import dumps

class CacheHandler(RequestHandler):
    def __init__(self):
        super().__init__()
        self.contentType = "text/html"
    
    def send_cache(self, page):
        # page = dumps(page)
        # print(f'CACHE HANDLER: {page}')
        self.contents = page
        self.setStatus(200)

    def getContents(self):
        return self.contents