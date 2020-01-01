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
print(f'redis: {str(r)}')

class TagQueueHandler(RequestHandler):

    page_cache = []

    def __init__(self):
        super().__init__()
        self.contentType = "text/html"

    def enqueue(self, query):
        try:
            _, tag, _page = query.split('=')
        except:
            _, tag = query.split('=')
            # page = 1
        try:
            tag = tag.split('&')[0]
            # tag = tag.split('#')[0]
            print(f'TAG: {tag}')
            r.lpush('tagsin',tag)
        except:
                print(f'ENQUEUE ERROR counld not split path')
                # handler = BadRequestHandler()
                raise Exception(f'Bad request to queue service. Echo:{query}')

        try:
            per_page = 28
            # r.lpush('tagsin',tag)
            stream = f'tags:out:{tag}'
            # when blocking xread, count = 1
            result = r.xread({stream:b"0-0"}, count=16, block=10000)
            # print(f'result len: {len(result[0][1])}')
            print('ONE')
            if len(result) == 1:
                print('two')
                print('requesting more from stream')
                sleep(1)
                result = r.xread({stream:b"0-0"},count=10)
                print('3')
                print(f'2nd result size: {len(result[0][1])}')
                print('4')
            if result:
                result = result[0][1]
                print('5')
            results = []
            for (_,i) in result:
                results.append(i)

            json_result = json.dumps(results)

            total = r.xlen(f'tags:out:{tag}')
            
            total_pages = ceil(total / per_page)
            print('6')
            message = f'{{"total":{total},"total_pages":{total_pages},"results":{json_result}}}'
            # print(f'message:{message}')
            # TODO: CACHE 
            # ADD URL AND DATA TO DICT/LIST
            # RETURN A DICT/LIST TO CACHE
            # SET A FLAG TO CACHE RESULT
            r.lpush('cache:queue', tag)

            self.contents = message
            self.setStatus(200)
            return True
        except Exception as e:
            print(f'exception: tagQueue: {str(e)}')
            self.setStatus(404)
            return False

    def find(self, file_path):
        # print(f'find {file_path}')
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