from response.requestHandler import RequestHandler
from string import Template

class TemplateHandler(RequestHandler):
    def __init__(self):
        super().__init__()
        self.contentType = "text/html"

    def find(self, file_path, **kwargs):
        try:
            self.contents = self.render(file_path, **kwargs)
            self.setStatus(200)
            return True
        except Exception as e:
            print(f'exception {e}')
            self.setStatus(404)
            return False

    def _read_template(self, template_path):
        with open(template_path) as template:
            return template.read()

    def render(self, template_path, **kwargs):
        return Template(
            self._read_template(template_path)
        ).substitute(**kwargs)