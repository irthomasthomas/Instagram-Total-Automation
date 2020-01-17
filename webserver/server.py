import os

from http.server import BaseHTTPRequestHandler

from routes.hosts import hosts

from response.staticHandler import StaticHandler
from response.templateHandler import TemplateHandler
from response.badRequestHandler import BadRequestHandler
from response.dynamicHandler import DynamicHandler
from response.tagQueueHandler import TagQueueHandler
from response.requestHandler import RequestHandler
from response.cacheHandler import CacheHandler

# from urllib.parse import parse_qs, urlparse
import json
from redis import Redis

r = Redis(host="localhost", port=6379, db=0, decode_responses=True)

class Webserver(BaseHTTPRequestHandler):

    routes = {}
    for host in hosts:
        print('HOSTS READ LOOP')
        with open("routes/{}.json".format(hosts[host]['name']), "rb") as f:
            routes[host] = json.loads(f.read())

    def do_HEAD(self):
        return
    def do_POST(self):
        return

    def do_GET(self):
        # print(f'self.path: {self.path}') # /enqueue?tag=bubblecap # /enqueue?tag=bubblecap&page=22
        # TODO: CHECK request is from ecsta.tk
        # Check if the requested host is valid.
        self.host = self.headers.get('Host')
        if self.host not in hosts:
            print(f'ERROR: Invalid Host Req to: {self.host} from {self.client_address}')
            handler = BadRequestHandler()
            return
        self.path = self.path.lower().strip('#')
        print(f'PATH: {self.path}')
        try:
            path, query = self.path.split('?')
        except:
            path = self.path
        request_extension = os.path.splitext(self.path)[1]
        
        # CHECK CACHE
        hash = r.get(self.path)
        if hash:
            print(f'FOUND CACHE FOR: {self.path}')
            handler = CacheHandler()      
            handler.send_cache(hash)

        elif path == "/enqueue":
            # TODO: HANDLE '#'
            print(f'NO CACHE:{self.path}')
            handler = TagQueueHandler()
            handler.enqueue(query)
            
        elif path == "/screen":
            host = hosts[self.host]['name'] # thomasthomas
            print("screen req")
            handler = DynamicHandler()
            handler.find(host, path)

        elif request_extension in ["", ".html"]:
            if self.path in self.routes[self.host]['routes']: # Error
                host = hosts[self.host]['name'] # thomasthomas
                routeData = self.routes[self.host]['routes'][self.path]
                if host == 'ecsta':
                    file_path = f'sites/{host}/public/{routeData["template"]}'
                else:
                    file_path = f'sites/{host}/templates/{routeData["template"]}'
                
                handler = TemplateHandler()
                handler.find(file_path, URL='TESTING')
                # pageData = handler.render(file_path, URL='TESTING')
            else:
                print(f'badrequest {self.host}')
                handler = BadRequestHandler()
        elif request_extension not in [
            '.html', '.htm', '.css',
            '.jpg', '.jpeg', '.png',
            '.bmp', '.js', '.ico']:
            handler = BadRequestHandler()
        else:
            handler = StaticHandler()
            handler.find(
                hosts[self.host]['name'],
                self.path,
                request_extension)

        self.respond({
            'handler': handler
        })
        
    def handle_http(self, handler):
        status_code = handler.getStatus()
        self.send_response(status_code)
        self.send_header('Access-Control-Allow-Origin', '*')

        if status_code is 200:
            if isinstance( handler, (TemplateHandler)):
                content = handler.read()
            else:
                content = handler.getContents()
            self.send_header("Content-type", handler.getContentType())
        else:
            # TODO: bundle.js
            print(f'404: handler {handler}')
            content = "404. Page Not Found."

        self.end_headers()
        if isinstance( handler, (DynamicHandler)):
            html = "<img src='data:image/png;base64,{}' width='700'/>".format(content)
            return bytes(html,"ascii")

        elif isinstance( content, (bytes, bytearray) ):
            return content
        return bytes(content, "UTF-8")
        
    def respond(self, opts):
        content = self.handle_http(opts["handler"])
        self.wfile.write(content)

