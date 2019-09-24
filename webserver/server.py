import os
import base64
from http.server import BaseHTTPRequestHandler

from routes.main import routes

from response.staticHandler import StaticHandler
from response.templateHandler import TemplateHandler
from response.badRequestHandler import BadRequestHandler
from response.dynamicHandler import DynamicHandler
from response.tagQueueHandler import TagQueueHandler
from urllib.parse import parse_qs, urlparse

class Server(BaseHTTPRequestHandler):
    def do_HEAD(self):
        return
    def do_POST(self):
        return

    def do_GET(self):
        split_path = os.path.splitext(self.path)
        request_extension = split_path[1]
        o = urlparse(self.path)
        print(str(o.path))
        print(str(o.params))
        print(str(o.query))
        if o.path == "/enqueue":
            print("ENQUEUE")
            handler = TagQueueHandler()
            handler.enqueue(o.path,o.query)
            # handler.find(self.path)

        elif self.path == "/screen":
            print("screen req")
            handler = DynamicHandler()
            handler.find(self.path)
        
        elif request_extension is "" or request_extension is ".html":
            if self.path in routes:
                handler = TemplateHandler()
                handler.find(routes[self.path])
            else:
                handler = BadRequestHandler()
        elif request_extension is ".py":
            handler = BadRequestHandler()
        else:
            handler = StaticHandler()
            handler.find(self.path)  

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

        if isinstance( handler, (DynamicHandler)):
            html = "<img src='data:image/png;base64,{}' width='700'/>".format(content)
            return bytes(html,"ascii")

        elif isinstance( content, (bytes, bytearray) ):
            return content
        return bytes(content, "UTF-8")
        
    def respond(self, opts):
        content = self.handle_http(opts["handler"])
        self.wfile.write(content)

