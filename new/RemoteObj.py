import socket
import time
import os
import json


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
    RetVal = Sock.recv(1024)
    Sock.close()
    return RetVal
    
host = "192.168.0.31"
port = 1339
bot = RemoteObjClient((host,port))
time.sleep(1)

print(str(bot))
time.sleep(1)
print(str(bot.Get("STATUS"))) # NEW
bot = RemoteObjClient((host,port))
print(str(bot.Call("shortRoutine","noplacetosit","fast")))

# print(str(bot.Call("MessageBox",("noplacetosit")))) # working
while True:
    time.sleep(5)
    print(str(bot.Get("STATUS"))) # NEW

# print(str(r.Call("Test"))) # working

# s.sendall(b'{"Action":"__Call","Name":"MessageBox","Params":["HELLO FROM PYTHON"]}')
