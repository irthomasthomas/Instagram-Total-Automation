from response.requestHandler import RequestHandler
import sys
from urllib.parse import parse_qs, urlparse, parse_qsl
import redis
from app.tasks import scrape_tag
from datetime import datetime
from types import SimpleNamespace
from math import ceil
import json
from time import sleep, perf_counter
from redisbloom.client import Client

r = redis.Redis(decode_responses=True)
print(f'redis: {str(r)}')
rb = Client()

class TagQueueHandler(RequestHandler):
    
    page_cache = []

    def __init__(self):
        super().__init__()
        self.contentType = "text/html"
    
    
    def gettop10tags(self):
        # TODO: SANITIZE / AND #
        # TODO: top100:request
        # start1 = perf_counter()
        toplist = []
        # top10tags = rb.topkList('top10tags')
        top10tags = rb.topkList('top100tags')
        # TODO: mk RB top100tags
        for t in top10tags:
            stream = r.xread({f'tags:out:{t}': b"0-0"}, count=100)
            if stream:
                try:
                    top10dic = {
                        "postId": stream[0][1][0][1]['postId'],
                        "imgUrl": stream[0][1][0][1]['imgUrl'],
                        "link": f'http://thomasthomas.tk/enqueue?tag={t}&page=1',
                        "rootTag": stream[0][1][0][1]['rootTag']
                    }
                    toplist.append(top10dic)                    
                except:
                    print('index out of range')
                
        page_response = f'{{"total":1,"total_pages":1,"results":{json.dumps(toplist)}}}'
        r.set('/enqueue?tag=top10tags&page=1', page_response)
        # end1 = perf_counter()
        # print(f'time1: {end1 - start1}')
        return page_response


    def get_tags(self, tag):
        # TODO: SUBSCRIBE TO UPDATES FROM STREAM
        # TODO: RELATED RESULTS
        # TODO: DONE -SCRAPE 1 PAGE DEEP OF RELATED TAGS
        # TODO: MERGE RESULTS WITH RELATED TAGS
        # TODO: TIMER IS SLOWER WHEN RESULTS ARE NOT READ
        # TODO: PRODUCT DENSITY SCORE
        # TODO: # rb.topkAdd('topk:10requests', tag)

        # TODO: WRONG SETTING KEY TO KEY 
        # root_tag_key = f'rootTag:{tag}'
        # root_tag = r.get(root_tag_key)
        # if not root_tag:
        #     print(f'Setting new rootTag key')
        #     r.set(f'rootTag:{tag}', tag)
        #     root_tag = tag
        # TODO Need to change tagsin to set

        res = r.sadd('tagsin', tag) # TODO: Add rootTag
        print(f'sadd: {res}')
        if res > 0:
            r.lpush('list:tagsin', tag)
        
        stream_key = f'tags:out:{tag}'
        per_page = 28
        results = []

        stream = r.xread({stream_key:b"0-0"}, count=28, block=10000)
        if len(stream) == 1:
            print('requesting more from stream')
            sleep(1)
            stream = r.xread({stream_key:b"0-0"},count=10)
        
        start2 = perf_counter()
        if stream:
            try:
                stream = stream[0][1]
            except:
                print('index out of range')          

        for (_, post) in stream:
            results.append(
                {
                    "id": post['postId'],
                    "imgUrl": post['imgUrl'],
                    "link": post['link'],
                    "related": post['related_tag']
                })

        json_result = json.dumps(results)
        total = r.xlen(f'tags:out:{tag}')
        total_pages = ceil(total / per_page)
        # TODO: TEST DIC v F-String
        page_response = f'{{"total":{total},"total_pages":{total_pages},"results":{json_result}}}'
        
        end2 = perf_counter()
        print(f'timer2: {end2 - start2}')

        return page_response


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
        except:
            print(f'ENQUEUE ERROR counld not split path')
            # handler = BadRequestHandler()
            self.setStatus(404)
            raise Exception(f'Bad request to queue service. Echo:{query}')

        if tag == 'top10tags':
            message = self.gettop10tags()
        else:
            message = self.get_tags(tag)
        r.lpush('cache:queue', tag)

        self.contents = message
        self.setStatus(200)
        return True

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