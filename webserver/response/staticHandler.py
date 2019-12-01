import os
from response.requestHandler import RequestHandler

class StaticHandler(RequestHandler):
    def __init__(self):
        self.filetypes = {
            ".js" : "text/javascript",
            ".css" : "text/css",
            ".jpg" : "image/jpeg",
            ".png" : "image/png",
            "notfound" : "text/plain"
        }
    
    def find(self, host, file_path, extension):
        try:
            print(f'sites/{host}/public{file_path}')
            if extension in (".jpg", ".jpeg", ".png"):
                self.contents = open(f'sites/{host}/public{file_path}', "rb")
                # TODO: IS FILE BEING CLOSED?
                # with open(f'sites/{host}/public{file_path}', "rb") as f:
                #     self.contents = f
                #     print(self.contents)
            else:
                self.contents = open(f'sites/{host}/public{file_path}', "r")
            self.setContentType(extension)
            self.setStatus(200)
            return True
        except:
            self.setContentType("notfound")
            self.setStatus(404)
            return False
            
    def setContentType(self, ext):
        self.contentType = self.filetypes[ext]    

