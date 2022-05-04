from flask import Flask, render_template, request, Response
from flaskext.mysql import MySQL
import json

app = Flask(__name__)

mysql = MySQL()
 
# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'condorito'
app.config['MYSQL_DATABASE_DB'] = 'LibrarySystem'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)


@app.route('/')
def main():
    return render_template('index.html')
    # return 'Hello world'

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

@app.route('/signin')
def showSignIn():
    return render_template('signin.html')

@app.route('/api/signin', methods=["POST"])
def signIn():
    email = request.form["inputEmail"]   
    password = request.form["inputPassword"]
    print(email)
    print(password)

    if email and password:
        conn = mysql.connect()
        cursor = conn.cursor()

        query = "SELECT * FROM Users WHERE username=%s AND password=%s"
        values = (email, password)

        cursor.execute(query, values)
        data = cursor.fetchall()

        print(data)

        if len(data) is 1:
            print("Success")
            user1 = str(data[0][3])
            user2 = str(data[0][4])
            user = user1 + " " + user2
            print(user)
            return json.dumps({'message': user})
        else:
            print("No")
            return json.dumps({'message': 'Wrong credentials'})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
