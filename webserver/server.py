import os
import base64
from http.server import BaseHTTPRequestHandler

from routes.main import routes

from response.staticHandler import StaticHandler
from response.templateHandler import TemplateHandler
from response.badRequestHandler import BadRequestHandler
from response.dynamicHandler import DynamicHandler

class Server(BaseHTTPRequestHandler):
    def do_HEAD(self):
        return
    def do_POST(self):
        return

    def do_GET(self):
        split_path = os.path.splitext(self.path)
        request_extension = split_path[1]
        if self.path == "/screen":
            print("screen req")
            handler = DynamicHandler()
            handler.find(self.path)

        #     with open("screen", "r") as img:
        #         screen = img.read()
        #     html := "HTTP/1.0 200 OK`r`n`r`n <img src='data:image/png;base64," screen "' width='700'/>"

        #     print("screen request")
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
            # screen = base64.b64encode(content.encode())
            # screen = "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAYAAABccqhmAAAUA0lEQVR4Xu2dd6xvRRWFP8FeAwjYuyKgxq4R7L2gWLCABOyxlwh2rBhr1Nh7AxQVjLGgEDFRJGJBxYII9gY27IoKmoXnIsp77977ZubsPWfW/EPC+53ZM9/sve7MOTN7zoeLCZjAsATON2zP3XETMAEsAHYCExiYgAVg4MF3103AAmAfMIGBCVgABh58d90ELAD2ARMYmIAFYODBd9dNwAJgHzCBgQlYAAYefHfdBCwA9gETGJiABWDgwXfXTcACYB8wgYEJWAAGHnx33QQsAPYBExiYgAVg4MF3103AAmAfMIGBCVgABh58d90ELAD2ARMYmIAFYODBd9dNwAJgHzCBgQlYAAYefHfdBCwA9gETGJiABWDgwXfXTcACYB8wgYEJWAAGHnx33QQsAPYBExiYgAVg4MF3103AAmAfMIGBCVgABh58d90ELAD2ARMYmIAFYODBd9dNwAJgHzCBgQlYAAYefHfdBCwA9gETGJiABWDgwXfXTcACYB8wgYEJWAAGHnx33QQsAPYBExiYgAVg4MF3103AAmAfMIGBCVgABh58d90ELAD2ARMYmIAFYODBd9dNwAJgHzCBgQlYAAYefHfdBCwA9gETGJiABWDgwXfXTcACYB8wgYEJWAAGHnx33QQsAPYBExiYgAVg4MF3103AAmAfMIGBCVgAYAvgRsBNgWsClwYuBJjNsgLjX8AZwK+Ak4HjgOMB/f9hy8hOfi3gccADgW2H9YCxO34a8H7gdcApI6IYUQC2B14K7M1//vq7mMBZwLuAp08zhGGIjCYAuwHvBLYZZoTd0fUQ0PJgH+CI9TzU829HEoD9pr/8I/W5Z9+MartmA08BXhPVgDntjhIM+0/BPydb2+qbwJNGEIERBODewGF+q993NAa0XjOBewIfD7A9m8mlC8DlgW8AW81G1IaWRODXwHUAfS1YZFm6ABwCPGiRI+dOzUVAXwceMpexue0sWQCk3Cd46j+3Sy3OnpYCOwEnLa5nCw+ONwOPXOKguU+zE9BGocfPbnUGg0udAWgrr9Ztl5qBoU0sn8DpgDaQ/WNpXV2qAOjN/+FLGyz3J5SANpF9LLQFDYwvVQA+AOzRgJerHJeAXijvtbTuL1EALg78ErjI0gbL/Qkl8GdgO+Avoa2obHyJAiCVPqgyJ1dnAiKgk6OHLgnFEgVA67S7Fw7SM0Y9HlrILfPjOwAvKmzgR4DdC+tI9fjSBGBr4FTgAgWUtfvrMsCZBXX40XwE5BP6MlSyK1QJRfQ14Pf5urd5LVqaAOi7v77/l5S3ev9ACb7Uz+oo+L6FLXzodKS8sJocjy9NAD4D3KYQ7Z2Aowrr8OM5CdwV+ERh0+Qb8pFFlCUJwOWAnxRm+fH0fxFuvdFO1FgGaGmoQ2aLOCC0JAHQ+e1XFfqvp/+FADt4vMYyQNuCtT24+7IkAVCWV2X2LSme/pfQ6+PZGsuAY4Fd+ujuplu5FAG4eoXPdp7+L8GjV+9DjWWAUolfFfjR6uZy/2IpAvCsCt94Pf3P7as1W1djGaAMwsou3XVZigB8E9i5cCQ8/S8E2NHjNZYBXwNu0FGfN9jUJQiAEn8o7VdJ8fS/hF5/z9ZYBqjXOwLf6a/7/23xEgTgQOCZhYPg6X8hwA4fr7EMeAHw3A77fk6TlyAA3wOuVjgInv4XAuzw8RrLAN0xqCvmui29C8DNgC8U0vf0vxBgp4/XWgbcGPhKpwy6vwH31cATC+F7+l8IsOPHaywDXgk8tVcGPc8AdLHnT4HLFsL39L8QYMeP11gGyAev1Os14z0LwG2Bowudz9P/QoCdP15rGXBr4LM9suhZAN4CPKIQuqf/hQAX8HiNZcCbgEf3yKJXAZByK/GHEoCUFE//S+gt49kaywDNJLUU/WdvSHoVgHsAHy2E7el/IcCFPF5rGSAh+WRvTHoVgIOBPQthe/pfCHBBj9dYBrwH2Kc3Jj0KgNJ9K+230n+XFE//S+gt69kay4A/TmnD/9YTmh4F4P4VUjN7+t+Tl7Zva61lwP2Aw9o3t56FHgXgwxVSM3v6X8+HllJTjWWAgl8i0E3pTQB02adysenyz5Li6X8JvWU+W2MZoOm/0ob/oRdEvQnAQ4B3FML19L8Q4EIfr7UM0ItAvRDsovQmAEcCdywk6+l/IcAFP15jGXAEcLdeGPUkALqY8efAloVwPf0vBLjgx2ssA7QZSJuCNNNMX3oSgMdWSMXs6X96lwxtYK1lgLYFa3tw+tKTABxTIRWzp//pXTK8gTWWAToYpANC6UsvAqDjlj+E4vwFnv6nd8nwBtZYBihtuHxWR4VTl14EYP8KKZg9/U/timkaV2sZoCQhShaSuvQiAMdXSMHs6X9qV0zVuBrLAKUJU7qw1KUHAdihUuplT/9Tu2KqxtVYBqhDShiqxKFpSw8C8LwKqZc9/U/rgikbVmsZcADwwpQ9nBrVgwCcVCH1sqf/mb0wZ9tqLANOBHbK2b3/tCq7ANywUsplT/8ze2HOttVaBlwf+HrOLuYXgJdXSLns6X9W78vdrlrLAF0gqotEU5bMMwC1TdcvX7GQnKf/hQAHfrzGMkA+rKvEtTcgXcksALsCn6tAzNP/ChAHraLWMmAX4NiMDDMLwOuBxxRC8/S/EODgj9daBrwOeHxGllkF4PzTyb9tC6F5+l8I0I9TYxmgHJaXA87MxjOrANy5UoplT/+zeVx/7am1DEjpi1kFoIbqevrfX7BlbHGtZYAyWT0sWwczCoDy/Snvn/L/lRRP/0vo+dlzE6jxB+l3U77Av2dCm1EA7g0cXgFSyilXhX65ivkJ1FoG7A58ZP7mb9xiRgH4ALBHISRP/wsB+vH/IVBrGXAo8MBMbLMJwCWm6b9u/ykpnv6X0POzGyJQYxnwl+n2oD9nQZxNAB4MvLcCHJ3FVgYhFxOoRUC7+XQ2pbTsBRxSWkmt57MJwMeAu9fqnOsxgYQE5OO7ZWlXJgHYGjgV0HrLxQSWSuAf09eA0zN0MJMAPBJ4cwYoboMJNCbwCOBtjW2sqfpMAvAZ4DZrarV/ZAJ9EzgauH2GLmQRAO2T/gmwRQYoboMJNCZwFnAF4BeN7axafRYBeBLwqlVb6x+YwHIIyOdfE92dLAJwHHDTaBi2bwIzEpDP33xGexs0lUEArg6cEg3C9k0ggIB8//sBds8xmUEAngW8KBKCbZtAEAH5/ouDbJ9tNoMAfBPYORKCbZtAEAH5/nWDbKcRgJTJEiMHxbaHIhD6RzjU+DTMFoCh/N2d/T8CoTEYatwC4GAwgdhluAXAHmgCsQRCYzDUuGcAsZ5n6ykIhMZgqHELQAoHdCNiCYTGYKhxC0Cs59l6CgKhMRhq3AKQwgHdiFgCoTEYatwCEOt5tp6CQGgMhhq3AKRwQDcilkBoDIYaTyYAur/tZOA3gC5vuNh0n9u1gNIsxbEuNq51ZeH97nTuXpl4demMUs9pTEvvnaxFNTQGQ40nEABdP34QcOQmsgjrotIbT4kc9wauWGvkXU8TAj+aMkt/FFB26I1dyHk1QJfHKBO1ru+OKqExGGo8UACUmfUA4KvrHPUtgQcBLwSuss5n/fO2BHSs9tmALpZZ7y28EniN6V3aNnGDtYfGYKjxAAHQjUEPr3A9k5YEBwJPDnAYm/xfAjpL8opJ0P9WCOe+wFumZUJhVWt+PDQGQ43PLAAnTHcO/HTNQ7P6D+8DHAxcePWf+hcNCGiNr6u2NN2vVa4EHAHsVKvCVeoJjcFQ4zMKwPFTFlbd0Fq73Bb4hEWgNtZV61Pwa8qu9zi1i14UKkv19WpXvIH6QmMw1PhMAvBj4CaA3vK3KvcDPtiqctd7HgKa9t+r8l/+/zdyWeDL05eglkMQGoOhxmcQAL0M2hX4QssRnOp+NfDEGezYBLwc2H8GELeaZgIt09WHxmCo8RkEQGmXlX55jnJR4ERAa0iXdgT0tl8p5Epf+K21hW8CHrXWH2/G70JjMNR4YwH4I3BlYM472PYFdI20SzsCewLva1f9eWrWhiHtLWi1GSw0BkONNxYATcnn/kynTUO6lvzyMzroSKYUiEqlvd7v/KWMXg88prSSjTwfGoOhxhsLwPWBrzcatE1V+zJgvwC7I5hU+vjnBHRUl9boIo8WJTQGQ403FADdMxi1Fr8l8NkWnuI6uRnwxSAOurp++wa2Q2Mw1HhDATgE2KvBYK2lygsCev+g/7rUI6Dv/pcMmP6v9ECfefW5t3YJjcFQ4w0FQHvCtVU3qnwb2DHK+ELtfg24QWDfXtBo+REag6HGGwrAw4B3BDrLUcAdAu0v0bS2594tsGP6FKhPgrVLaAyGGm8oANoffmjtkVpHfR8Gdl/H7/3T1Ql8CNhj9Z81+4WWlDo6XruExmCo8YYCsA/wntojtY76PgnceR2/909XJ6ADP/dc/WfNfqFTpG9tUHtoDIYabygA+v6vfQBR5UtTEpEo+0u0+/lpW3dU354GvKSB8dAYDDXeUADe2HDjxlp8QKcOL7WWH/o3aybwK2C7Nf+6/g/fDjy0frW+GqzF5aDK9HPDBoO1lir19l9fAVzqE9AuQJ0FiCjfapQjIPSPcKjxhjOAs6ZjnKcFeIpOBEYuPwK6PJvJRzd6E79aB64AaHNZixIag6HGGwqAqtYpQJ0GnLtop5ryD7jUJxD1HkBHj19avztn1xgag6HGGwvAKcC1Z945dgtATurSjoDEVYk65ioXmNLF62RpixIag6HGGwuAqtdLmzmP534auF0LL3Gd5xCYe0OQlh1vaMg/NAZDjc8gAHpzrOSOygbcuuicuhKEurQnoD35h7U3c/bhHyV52aqhrdAYDDU+gwDIhBJ23gNo8bVhxS/0dlqXUPjTX8NIOVfVv53OBSjfY6uiNGCfmmFLd2gMhhqfSQBk5rXAExp5yqWndb+um3KZj4A+terotcSgRWmdCmylzaExGGp8RgFYEQF9oqs5E9DnIW37VY46l/kJ6K4HpQb/RUXT+suvNX/LPIDnbm5oDIYan1kAZE5TOt3vp3cDpUUv+7Tmv0xpRX6+iMDPp+vaaiRh0ZpfB37mPMkZGoOhxgMEQCZ1++8zpq8D/9wM15OTKNeAvjBk4LcZXVjcI9r4pYM6She2OeKuT3067KNxbfnCb0PgQ30o1HiQAKwMwg8AJXtUhln9FdlUESelo9IpQ2X+9VVgOTVEWYPeBbx7janDtITT1xsl/Gz1nX81UqExGGo8WABWBkbvBLTPW0kfdZe8ZghnABefsvtqb79eNkUeRFnNifzv5yWgbeC6Nkyf8X4G/GlK7b0NoBe2N2+0t3+9YxEag6HGkwjAegfMvzeBmgRCYzDUuAWgph+5rk4JhMZgqHELQKcu62bXJBAag6HGLQA1/ch1dUogNAZDjVsAOnVZN7smgdAYDDVuAajpR66rUwKhMRhq3ALQqcu62TUJhMZgqHELQE0/cl2dEgiNwVDjFoBOXdbNrkkgNAZDjVsAavqR6+qUQGgMhhq3AHTqsm52TQKhMRhq3AJQ049cV6cEQmMw1LgFoFOXdbNrEgiNwVDjFoCafuS6OiUQGoOhxi0Anbqsm12TQGgMhhq3ANT0I9fVKYHQGAw1bgHo1GXd7JoEQmMw1LgFoKYfua5OCYTGYKhxC0CnLutm1yQQGoOhxi0ANf3IdXVKIDQGQ41bADp1WTe7JoHQGAw1bgGo6Ueuq1MCoTEYatwC0KnLutk1CYTGYKhxC0BNP3JdnRIIjcFQ4xaATl3Wza5JIDQGQ41bAGr6kevqlEBoDIYatwB06rJudk0CoTEYatwCUNOPXFenBEJjMNS4BaBTl3WzaxIIjcFQ4xaAmn7kujolEBqDocYtAJ26rJtdk0BoDIYaTyIAh9YcTdfVHYEHBLc4NAZDjScRgAwMgn1waPP/Cu59qP+FGrcABLuezYuABSDYD4YegGD2Nm8BCPcBC0D4EAzdgKH9z0sAyMBg6AgM7rwFwAMQTMDmIwlYACLpj/4SJpi9zfsdQLgPDK3A4fTdgKH9L8P6d+gBcPyFExja/ywAfgkYHoHBDbAABA/AmcAWQW2Q7fMH2bbZHASG9r8MM4BfA9sE+YJsbxtk22ZzEBja/zIIwDHALkG+8DngVkG2bTYHgaH9L4MAPB84IMgXZPt5QbZtNgeBof0vgwBcAzgp4D3AWcAOwCk5/NCtCCIwtP9lEACN+0HAXjM7gGzuPbNNm8tJYFj/yyIA2wMnANvN5B+/BK4HnDaTPZvJTWBY/8siAHIPvQg8CrhIY1/5K3AnQC9/XExghcCQ/pdJAFZE4PCGMwH95b+vg99RvxECEoGh/C+bAGhcNB17BbBnxReDeuF3CLAfcKrd3wQ2QWAo/8soACtjo7ezDwZuB+wIbAVsuUbX1e6u04ETgaOBg4GT1/isf2YCIjCE/2UWALuhCZhAYwIWgMaAXb0JZCZgAcg8Om6bCTQmYAFoDNjVm0BmAhaAzKPjtplAYwIWgMaAXb0JZCZgAcg8Om6bCTQmYAFoDNjVm0BmAhaAzKPjtplAYwIWgMaAXb0JZCZgAcg8Om6bCTQmYAFoDNjVm0BmAhaAzKPjtplAYwIWgMaAXb0JZCZgAcg8Om6bCTQmYAFoDNjVm0BmAhaAzKPjtplAYwIWgMaAXb0JZCZgAcg8Om6bCTQmYAFoDNjVm0BmAhaAzKPjtplAYwIWgMaAXb0JZCZgAcg8Om6bCTQmYAFoDNjVm0BmAhaAzKPjtplAYwIWgMaAXb0JZCZgAcg8Om6bCTQmYAFoDNjVm0BmAhaAzKPjtplAYwIWgMaAXb0JZCZgAcg8Om6bCTQmYAFoDNjVm0BmAv8G9NB/H5npn+0AAAAASUVORK5CYII="
            # result = base64.b64encode(content).decode('ascii')
            html = "<img src='data:image/png;base64,{}' width='700'/>".format(content)
            return bytes(html,"ascii")

        elif isinstance( content, (bytes, bytearray) ):
            return content
        return bytes(content, "UTF-8")
        
    def respond(self, opts):
        content = self.handle_http(opts["handler"])
        self.wfile.write(content)

