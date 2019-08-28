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
import RemoteObj
from RemoteObj import RemoteObjClient
import random

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
    # TODO: 
    print('File ID: %s' % file.get('id'))
    return file.get('id')

def InstagramPostPhoto(account, photo_path, caption):
    # TODO: Need to create properties for account
    filePath = os.path.join(os.getcwd(),'instagramQueue', photo_path)
    image = Image.open(filePath)
    image.save(filePath)
    time.sleep(5)
    password = credentials.PASSWORDS[account]
    # TODO: IS RIGHT ACCOUNT BEING USED 
    # instagram(account)
    time.sleep(5)
    print("INSTAGRAM UPLOAD")
    # with client(account, password) as cli:
    #     cli.upload(filePath, caption)
    # TODO: cli upload
    # instagram(account)
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
            print("TEST " + str(fileId))
            # print("TEST 2 " + str.encode(fileId))
            # conn.sendall(str.encode(fileId))  
            conn.sendall(str.encode(fileId))
        elif dataArray[0] == 'print_to_terminal':
            print(str(dataArray[1]))
        elif dataArray[0] == 'instagram_conn':
            print("received command: " + dataArray[0])
            # conn_status = access_instagram(dataArray[1],dataArray[2])
            # conn.sendall(str.encode(str(conn_status)))
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

def instagramTest(account):
    print("trying insta automation")
    host = "192.168.0.36"
    port = 8337
    bot = RemoteObjClient((host,port))
    print(str(bot))
    bot.Call("session", account)
    print("trying browse hashtags")
    bot.Call("browseRandomHashtag")

def instagram(account):   
    print("trying insta automation")
    host = "192.168.0.36"
    port = 8337
    bot = RemoteObjClient((host,port))
    time.sleep(1)
    print(str(bot))
    session = bot.Call("session", account)
    time.sleep(1)
    print(str(session))
    print("status")
    print(str(bot.Get("STATUS"))) #NEW
    time.sleep(1)
    bot.Call("browseFeed",5)
    print(str(bot.Get("STATUS"))) #NEW
    time.sleep(1)
    bot.Call("browseRandomHashtag")
    time.sleep(10)
    bot.Call("browseFeed",5)
    # bot = RemoteObjClient((host,port))
    # print(str(bot.Call("shortRoutine",account,"fast")))
    time.sleep(5)
    while not (bot.Get("STATUS") == "READY"):
        time.sleep(5)
        print(str(bot.Get("STATUS"))) # NEW
        print(str(bot.Get("ACTIVITY")))
    bot.Call("closeBrowser")
    print("sleeping instagram")
    print(str(datetime.datetime.now()))
    time.sleep(6)
    print("finished")

host = ''
port = 2338
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

# TODO: Fetch usernames 
# TODO: Make default auto mode
# TODO: test insta automation
# TODO: test post to instagram
# TODO: Allow interrupt and post image during auto mode