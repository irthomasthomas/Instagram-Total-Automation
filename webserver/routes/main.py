def screenshot():
    print("screenshot")
    # with open("screen", "r") as img:
        # screen = img.read()
    # html := "HTTP/1.0 200 OK`r`n`r`n <img src='data:image/png;base64," screen "' width='700'/>"
    html = "HTTP/1.0 200 OK`r`n`r`n TESTING"
    return html

routes = {
    "/" : {
        "template" : "index.html"
    },
    "/goodbye" : {
        "template" : "goodbye.html"
    },
    "/sample" : {
        "template" : "sample.html"
    }
    # ,
    # "/screen" : {
    #     "template" : screenshot()
    # }
}




