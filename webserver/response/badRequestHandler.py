from response.requestHandler import RequestHandler

class BadRequestHandler(RequestHandler):
    def __init__(self):
        super().__init__()
        print(f'BadRequestHandler init()')
        self.contentType = "text/plain"
        self.setStatus(404)
        