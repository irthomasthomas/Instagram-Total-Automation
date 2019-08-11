import socket
import time
import subprocess
import pickle
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient import http
from _thread import *
import sys

def putphotojpg():
    """Shows basic usage of the Drive v3 API.
    Prints the names and ids of the first 10 files the user has access to.
    """
    creds = None
    SCOPES = ['https://www.googleapis.com/auth/drive']  

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

    #pdb.set_trace() #python 3.7 breakpoint()
    #https://drive.google.com/uc?export=view&id=1iWu9zlzu7fQBY8rYUsfgrm_ttc5Yd9WK
    file_metadata = {'name': 'photo.jpg','parents':['1TGaLmoesZJBdGX5w7tfiX6XQHf3k6OxT']}
    media = http.MediaFileUpload('photo.jpg')
    #media = http.MediaFileUpload('photo.jpg', mimetype='image/jpeg')
    file = service.files().create(body=file_metadata,media_body=media,fields='id').execute()

    print('File ID: %s' % file.get('id'))
    return file.get('id')

host = ''
port = 1337

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print("Socket created")

try:
    s.bind((host,port))
except socket.error as e:
    print(str(e))
    sys.exit()

print("Socket has been bounded")

s.listen(10)

print('Socket is ready. Waiting for connection')

def threaded_client(conn):
    #conn.send(str.encode('Welcome, type your info\n'))

    while True:
        data = conn.recv(1024)
        reply = 'Server output: '+ data.decode()
        if not data:
            break;
        
        print(data.decode())
        print(reply)
        #conn.sendall(str.encode(reply))

        if (data.decode() == "photo upload"):
            print("processing command: photo upload")
            fileId = putphotojpg()
            conn.sendall(str.encode(fileId))
        elif (data.decode() == "Hello server"):
            print("Received: Hello server")
            conn.sendall(str.encode("Hello client!"))

    conn.close()

while True:
    conn, addr = s.accept()
    print('connected to: '+addr[0]+':'+str(addr[1]))
    start_new_thread(threaded_client,(conn,))
    