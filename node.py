#!/usr/bin/env python3
from bottle import route, run, request, get, response, default_app
from paste import httpserver
import sqlite3
import json
from pathlib import Path

#Change the file path if needed
db_folder = Path('C:/Users/danny/Desktop/RFID Project/Testing temp/database/Documents.myDatabase.sqlite')

application = default_app()

@get('/user/isauthorized')
def message():
    rfid_tag = request.query.rfid_tag.lstrip().rstrip()
    length = len(rfid_tag)
    print(f"Received the following query parameter rfid_tag={rfid_tag}, length={length}")
    
    connect = sqlite3.connect(db_folder)
    cursor = connect.cursor()

    cursor.execute("SELECT COUNT(*) FROM LOGINTABLE WHERE RFID_TAG=?", (rfid_tag,))
    result = cursor.fetchone()
    row_count = result[0]
    print(f"query result: ", row_count)
    cursor.execute("SELECT * FROM LOGINTABLE WHERE RFID_TAG=?", (rfid_tag,))
    
    for row in cursor:
        data = row
    cursor.close()
    
    #Set Response Header to JSON
    response.headers['Content-Type'] = 'application/json'
    response.headers['Cached-Control'] = 'no-cache'

    if(row_count > 0):
        print(data)
        message_result = {"is_authorized" : "true", "email":data[4], "user":data[1]}
    else:
        message_result = {"is_authorized": "false"}
    print(f"message_result: {message_result}")
    return json.dumps(message_result)
 
httpserver.serve(application, host='0.0.0.0', port=8080)
