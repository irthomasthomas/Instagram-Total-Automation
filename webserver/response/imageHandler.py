from response.requestHandler import RequestHandler
import sys
from urllib.parse import parse_qs, urlparse
import redis
from app.tasks import scrape_tag
from datetime import datetime

r = redis.Redis()
print(str(r))

class TagQueueHandler(RequestHandler):
    def __init__(self):
        super().__init__()
        self.contentType = "text/html"

    def enqueue(self, path, query):
        try:
            print("NEW")
            query_string = parse_qs(query)
            tag = query_string['tag'][0]
            print(scrape_tag(tag))
            r.lpush('tagsin',tag)
            # TODO: RESULT FROM REDIS
            # PUSH TO REDIS
            # DO SOMETHING IN GUI WHILE WAITING 
            # SHOW RESULT IN GRID
            q_len = r.llen('tagsin')
            message = f"Tag Scrape Task queueue at {tag}. {q_len} jobs queued"
            self.contents = message
            self.setStatus(200)
            return True
        except Exception as e:
            print(f'Error: {str(e)}')
            self.setStatus(404)
            return False

    def find(self, file_path):
        print(f'find {file_path}')
        try:
            if file_path == "/enqueue":
                self.setStatus(200)
                return True
        except:
            print(f'exception:imageHandler: {sys.exc_info()[0]}')
            self.setStatus(404)
            return False
    
    def getContents(self):
        return self.contents