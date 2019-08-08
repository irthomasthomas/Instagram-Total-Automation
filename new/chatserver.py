from __future__ import with_statement
from instapy_cli import client
import socket
import time
import subprocess
import pickle
import os
import datetime
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient import http
from _thread import *
import sys
from InstagramAPI import InstagramAPI
import credentials
from PIL import Image
import threading
import sqlite3
from sqlite3 import Error


def access_instagram(module, action):
    global instagram_active
    lock = threading.RLock()
    with lock:
        print("CURRENT ACTIVE MODULE: " + str(instagram_active))
        if not instagram_active:
            instagram_active = module
            print("INSTAGRAM CONNECTION REQUEST FROM: " + module)
            return module
        elif (instagram_active == module) and (action == "start"):
            print("INSTAGRAM START REQUEST FROM: " + module)
            return module
        elif (instagram_active == module) and (action == "end"):
            instagram_active = False
            print("INSTAGRAM DISCONNECT FROM: " + module)
            return module
        else:
            print("REJECTED INSTAGRAM CONNECTION REQ FROM: " + module)
            return False

def sendToGdrive(filePath):
    creds = None
    SCOPES = ['https://www.googleapis.com/auth/drive']  
    print("putphotojpg")
    print(filePath)
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server()
        # Save the credentials for the next run
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

    service = build('drive', 'v3', credentials=creds)

    # Call the Drive v3 API

    file_metadata = {'name': 'photo.jpg','parents':['1TGaLmoesZJBdGX5w7tfiX6XQHf3k6OxT']}
    media = http.MediaFileUpload(filePath)
    #media = http.MediaFileUpload('photo.jpg', mimetype='image/jpeg')
    file = service.files().create(body=file_metadata,media_body=media,fields='id').execute()

    print('File ID: %s' % file.get('id'))
    return file.get('id')

def InstagramPostPhoto(account, photo_path, caption):
    # TODO: Instagram = InstagramAPI(account, password)
    filePath = os.path.join(os.getcwd(),'instagramQueue', photo_path)
    image = Image.open(filePath)
    image.save(filePath)
    time.sleep(5)
    password = credentials.PASSWORDS[account]
    with open("INTERRUPT", "w+") as f:
        time.sleep(1)
    while not os.path.exists("READY"):
        time.sleep(5)
        count += 1
        if count > 10:
            break

    time.sleep(5)
    with client(account, password) as cli:
        cli.upload(filePath, caption)

    # Instagram = InstagramAPI(account, password)
    # Instagram.login()
    # Instagram.uploadPhoto(filePath, caption=caption)
    
    print("FINISHED POSTING TO INSTAGRAM")

def threaded_client(conn):
    while True:
        data = conn.recv(1024)
        if not data:
            break;
        
        print(datetime.datetime.now())

        dataArray = data.decode().split(';')
        if dataArray[0] == 'instaPhotoUpload':
            print("processing command: instagram photo upload")
            InstagramPostPhoto(dataArray[1],dataArray[2],dataArray[3])
        elif dataArray[0] == 'gDriveJpgUpload':
            print("processing command: gDrive photo upload")
            print(dataArray[1])
            fileId = sendToGdrive(dataArray[1])
            conn.sendall(str.encode(fileId))  
        elif dataArray[0] == 'print_to_terminal':
            print(str(dataArray[1]))
        elif dataArray[0] == 'instagram_conn':
            print("received command: " + dataArray[0])
            conn_status = access_instagram(dataArray[1],dataArray[2])
            conn.sendall(str.encode(str(conn_status)))
        elif dataArray[0] == 'get_totals':
            totals = get_totals()
            print(str(totals))
            return totals
    conn.close()

def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

global instagram_active 
instagram_active = False

host = "192.168.0.31"
# host = "192.168.0.30"
port = 1339
# port = 1337
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
print(str(s))
# s.sendall(b'HELLO FROM PYTHON')

s.sendall(b'{"Action":"__Call","Name":"MessageBox","Params":["HELLO FROM PYTHON"]}')
time.sleep(5)
data = s.recv(1024)
print('Received', repr(data))
s.close()
time.sleep(5)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.sendall(b'{"Action":"__Get","Key":"STATUS"}')
time.sleep(1)
data = s.recv(1024)
print(str(data))
s.close()



host = ''
port = 1338
CONNECTION_LIST = []
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
scriptPath = os.getcwd()
print("Socket created")

try:
    s.bind((host,port))
except socket.error as e:
    print(str(e))
    sys.exit()

print("Socket has been bounded")

s.listen(10)
CONNECTION_LIST.append(s)
print('Socket is ready. Waiting for connection ')
print(str(get_ip()))


while True:
    conn, addr = s.accept()
    print('connected to: '+addr[0]+':'+str(addr[1]))
    start_new_thread(threaded_client,(conn,))
    print(str(CONNECTION_LIST))