import os
import base64
from http.server import BaseHTTPRequestHandler

from routes.hosts import hosts
# import routes
from response.staticHandler import StaticHandler
from response.templateHandler import TemplateHandler
from response.badRequestHandler import BadRequestHandler
from response.dynamicHandler import DynamicHandler
from response.tagQueueHandler import TagQueueHandler
from urllib.parse import parse_qs, urlparse
import json

class Webserver(BaseHTTPRequestHandler):
    # TODO: If 404 add ip to redis list > gears > expiring key block
    # TODO: Load all files to memory

    routes = {}
    for host in hosts:
        with open("routes/{}.json".format(hosts[host]['name']), "rb") as f:
            routes[host] = json.loads(f.read())

    def do_HEAD(self):
        return
    def do_POST(self):
        return

    def do_GET(self):
        self.host = self.headers.get('Host')
        if self.host not in hosts:
            print(f'ERROR: Invalid Host: {self.host}')
            return
        # if self.host in hosts:
        # TODO: Merge host:path .eg. with open(f'sites/{host}/public{file_path}', "r") as img:

        request_extension = os.path.splitext(self.path)[1]
        o = urlparse(self.path)
        if o.path == "/enqueue":
            print("ENQUEUE")
            handler = TagQueueHandler()
            handler.enqueue(o.path,o.query)

        elif o.path == "/screen":
            print("screen req")
            handler = DynamicHandler()
            handler.find(hosts[self.host]['name'], o.path)

        elif request_extension in ["", ".html"]:
            # print(self.path)
            # print(self.routes[self.host]['routes'])
            # print(f"find: {hosts[self.host]['name']} path: {self.routes[self.host]['routes'][self.path]}")

            if self.path in self.routes[self.host]['routes']: # Error
                handler = TemplateHandler()
                handler.find(hosts[self.host]['name'], self.routes[self.host]['routes'][self.path])
            else:
                print(f'badrequest {self.host}')
                handler = BadRequestHandler()
        elif request_extension not in ['.html', '.htm', '.css', '.jpg', '.jpeg', '.png', '.bmp']:
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
        
        if status_code is 200:
            content = handler.getContents()
            self.send_header("Content-type", handler.getContentType())
        else:
            content = "404 Not Found"
        self.end_headers()
        # TODO: Handle TAG images
        if isinstance( handler, (DynamicHandler)):
            html = "<img src='data:image/png;base64,{}' width='700'/>".format(content)
            return bytes(html,"ascii")

        elif isinstance( content, (bytes, bytearray) ):
            return content
        return bytes(content, "UTF-8")
        
    def respond(self, opts):
        content = self.handle_http(opts["handler"])
        self.wfile.write(content)

