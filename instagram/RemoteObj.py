import socket
import time
import os
import json

class RemoteObj:
    def __init__(self, Addr, Obj):
        self.CONNECTION_LIST = []
        self.Obj = Obj    
        self.Sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.Sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.Sock.OnAccept = self.OnAccept.Bind(this)
        self.Sock.bind((host,port))
        print("Socket has been bounded")
        self.Sock.listen(10)
        self.CONNECTION_LIST.append(self.Sock)
        # self._conn =  TODO: connection
    
    def __enter__(self):
        return self
    
    def __exit__(self, ):
        # self.commit()
        self.connection.close()
    
    @property
    def connection(self):
        return self._conn
    



class RemoteObjClient:
    def __init__(self, Addr):
        self.__Addr = Addr

    def Get(self, Key):
        return RemoteObjSend(self.__Addr, {"Action": "__Get", "Key": Key})

    def Set(self, Key, Value):
        return RemoteObjSend(self.__Addr, {"Action": "__Set", "Key": Key, "Value": Value})

    def Call(self, Name, *args):
        return RemoteObjSend(self.__Addr, {"Action": "__Call", "Name": Name, "Params": args})

def RemoteObjSend(Addr, Obj):
    Sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    Sock.connect(Addr)
    Sock.sendall(bytes(json.dumps(Obj),'utf8'))
    time.sleep(1)
    data = json.loads(Sock.recv(1024))
    RetVal = str(data['RetVal'])
    Sock.close()
    return RetVal
    