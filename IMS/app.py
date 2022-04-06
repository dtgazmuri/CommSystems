from flask import Flask, request, Response
import json

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello world'

@app.route('/cakes')
def cakes():
    return 'Yummy cakes!'

@app.route('/validateRFID', methods = ["GET", "POST"])
def RFID():
    rfid_number = request.args.get("RFID")
    return_string = "RFID number is: " + str(rfid_number)
    print(return_string)

    #return Response(return_string, status=201)
    return return_string

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
