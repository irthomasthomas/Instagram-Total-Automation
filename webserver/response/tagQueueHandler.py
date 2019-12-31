from response.requestHandler import RequestHandler
import sys
from urllib.parse import parse_qs, urlparse, parse_qsl
import redis
from app.tasks import scrape_tag
from datetime import datetime
from types import SimpleNamespace
from math import ceil
import json
from time import sleep

r = redis.Redis(decode_responses=True)
print(str(r))

class TagQueueHandler(RequestHandler):

    page_cache = []

    def __init__(self):
        super().__init__()
        self.contentType = "text/html"

    def chunk_result(self, lst, size):
        ''' Yield n-sized chunks from list '''
        for i in range(0, len(lst), size):
            yield lst[i:i + size]

    def enqueue(self, path, query):
        try:
            qd = dict(parse_qsl(query))            
            tag = qd['tag']
            if 'page' in qd:
                page = qd['page']
            else: page = 1               
            per_page = 28
            r.lpush('tagsin',tag)
            stream = f'tags:out:{tag}'
            # when blocking xread, count = 1
            result = r.xread({stream:b"0-0"},count=18, block=10000)[0][1]
            if len(result) == 1:
                print('requesting more from stream')
                sleep(1)
                result = r.xread({stream:b"0-0"},count=18)[0][1]
                print(len(result))
            results = []
            for (_,i) in result:
                results.append(i)

            json_result = json.dumps(results)

            total = r.xlen(f'tags:out:{tag}')
            
            total_pages = ceil(total / per_page)

            message = f'{{"total":{total},"total_pages":{total_pages},"results":{json_result}}}'
            # TODO: CACHE 
            # ADD URL AND DATA TO DICT/LIST
            # RETURN A DICT/LIST TO CACHE

            self.contents = message
            self.setStatus(200)
            return True
        except Exception as e:
            print(f'exception: tagQueue: {str(e)}')
            self.setStatus(404)
            return False

    def find(self, file_path):
        print(f'find {file_path}')
        try:
            if file_path == "/enqueue":
                self.setStatus(200)
                return True
        except:
            print(f'exception: tagqueue {sys.exc_info()[0]}')
            self.setStatus(404)
            return False
    
    def getContents(self):
        return self.contents