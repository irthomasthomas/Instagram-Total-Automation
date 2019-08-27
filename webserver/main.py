import time
from http.server import HTTPServer
from server import Server

HOST_NAME = 'localhost'
PORT = 80

if __name__ == '__main__':
    httpd = HTTPServer((HOST_NAME, PORT), Server)
    print(time.asctime(), 'Server UP - %s:%s' % (HOST_NAME, PORT))
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()

