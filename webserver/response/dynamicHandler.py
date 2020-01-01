from response.requestHandler import RequestHandler
import sys

class DynamicHandler(RequestHandler):
    def __init__(self):
        super().__init__()
        self.contentType = 'text/html'

    def find(self, host, file_path):
        try:
            # print(f'DynamicHandler: Find: path: {file_path}')
            if file_path == '/screen':
                # print(f'sites/{host}/public{file_path}')
                with open(f'sites/{host}/public{file_path}', "r") as img:
                    screen = img.read()
                self.contents = str(screen)
                self.setStatus(200)
                return True
        except:
            print(f'Error: {sys.exc_info()[0]}')
            self.setStatus(404)
            return False
    
    def getContents(self):
        return self.contents