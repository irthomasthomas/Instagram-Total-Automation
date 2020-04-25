import time
from http.server import HTTPServer
from server import Webserver

HOST_NAME = '157.52.255.203'
# HOST_NAME = '172.26.72.73'
PORT = 9090

if __name__ == '__main__':
    httpd = HTTPServer((HOST_NAME, PORT), Webserver)
    print(time.asctime(), 'Server UP - %s:%s' % (HOST_NAME, PORT))
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()

