from response.requestHandler import RequestHandler
import sys
from urllib.parse import parse_qs, urlparse
import redis
from rq import Queue
from app.tasks import scrape_tag
from datetime import datetime

r = redis.Redis()
print(str(r))
q = Queue(connection=r)

class TagQueueHandler(RequestHandler):
    def __init__(self):
        super().__init__()
        self.contentType = "text/html"

    def enqueue(self, path, query):
        try:
            qs = parse_qs(query)
            tag = qs['tag'][0]
            print(scrape_tag(tag))
            task = q.enqueue(scrape_tag, tag)
            jobs = q.jobs
            q_len = len(q)
            message = f"Tag Scrape Task queueue at {tag}. {q_len} jobs queued"
            self.contents = message
            self.setStatus(200)
            return True
        except Exception as e:
            print(str(e))
            self.setStatus(404)
            return False

    def find(self, file_path):
        print(f'find {file_path}')
        try:
            if file_path == "/enqueue":
                self.setStatus(200)
                return True
        except:
            print(sys.exc_info()[0])
            self.setStatus(404)
            return False
    
    def getContents(self):
        return self.contents