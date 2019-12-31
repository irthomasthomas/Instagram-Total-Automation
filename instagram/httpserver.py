from http.server import BaseHTTPRequestHandler, HTTPServer
from os import curdir, sep

port = 80
STATUS = "TEST"
class myHandler(BaseHTTPRequestHandler):

    def __init__(self, *args):
        with open("sample.html", "r") as html:
            self.data = html.readline()
            self.data = self.data.format(STATUS)

    def do_GET(self):
        if self.path == "/":
            self.path = "/sample.html"

        try:
            sendReply = False
            if self.path.endswith(".html"):
                mimetype="text/html"
                sendReply = True
            if self.path.endswith(".jpg"):
                mimetype="image/jpg"
                sendReply = True
            if self.path.endswith(".gif"):
                mimetype="image/gif"
                sendReply = True
            if self.path.endswith(".js"):
                mimetype="application/javascript"
                sendReply = True
            if self.path.endswith(".css"):
                mimetype = "text/css"
                sendReply = True
            if self.path == "/status":
                self.send_response(200)
                self.send_header("Content-type","text/html")
                self.end_headers()
                self.wfile.write(bytes(STATUS, "utf-8"))
                sendReply = True
            
            
            if sendReply == True:
                # f = open(curdir + sep + self.path)
                self.send_response(200)
                self.send_header("Content-type", mimetype)
                self.end_headers()
                self.wfile.write(bytes(self.data,"utf-8"))
                # self.wfile.write(bytes(f.read(),"utf-8"))
                # f.close()
            return

        except IOError:
            self.send_error(404, "File Not Found: {}".format(self.path))
        
try:
    server = HTTPServer(("", port), myHandler)
    print("Started httpserver on port ", port)
    server.serve_forever()

except KeyboardInterrupt:
    print("^c received, shutting down the web server")
    server.socket.close()

