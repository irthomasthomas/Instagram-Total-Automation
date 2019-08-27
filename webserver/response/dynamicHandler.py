from response.requestHandler import RequestHandler
import sys

class DynamicHandler(RequestHandler):
    def __init__(self):
        super().__init__()
        self.contentType = "text/html"

    def find(self, file_path):
        try:
            if file_path == "/screen":
                with open("public/screen1", "r") as img:
                    screen = img.read()
                    # html = "HTTP/1.0 200 OK`r`n`r`n <img src='data:image/png;base64,{}' width='700'/>".format(screen)
                # html = "HTTP/1.0 200 OK`r`n`r`n TESTING"
                self.contents = str(screen)
                self.setStatus(200)
                return True
        except:
            print(sys.exc_info()[0])
            self.setStatus(404)
            return False
    
    def getContents(self):
        return self.contents