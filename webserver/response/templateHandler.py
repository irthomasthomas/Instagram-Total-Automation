from response.requestHandler import RequestHandler

class TemplateHandler(RequestHandler):
    def __init__(self):
        super().__init__()
        self.contentType = "text/html"

    def find(self, host, routeData):
        # print(f'tmplt find: sites/{host}/templates/{routeData["template"]}')
        try:
            template_file = open(
                f'sites/{host}/templates/{routeData["template"]}')
            self.contents = template_file
            self.setStatus(200)
            return True
        except:
            self.setStatus(404)
            return False