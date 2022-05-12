from urllib import response
from flask import Flask, render_template, request, Response, jsonify, request, make_response
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
    # rfid_number = request.args.get("RFID")
    rfid_number = request.json["RFID"]
    return_string = "RFID number is: " + str(rfid_number)
    print(return_string)

    #return Response(return_string, status=201)
    return return_string

@app.route('/signin')
def showSignIn():
    return render_template('signin.html')

### USERS API ###

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

        if len(data) == 1:
            print("Success")
            user1 = str(data[0][3])
            user2 = str(data[0][4])
            user = user1 + " " + user2
            print(user)
            return json.dumps({'message': user})
        else:
            print("No")
            return json.dumps({'message': 'Wrong credentials'})

@app.route('/api/signInRFID', methods=["POST","OPTIONS"])
def signInRFID():
    # rfid = request.form["RFID"]
    print(request.user_agent)
    print(request.is_json)
    print(request.headers)
    #rfid = request.json["rfid"]
    #print(rfid)
    return "20"
    '''
    if rfid:
        conn = mysql.connect()
        cursor = conn.cursor()

        query = "SELECT * FROM Users WHERE rfid = %s"
        values = (rfid)

        cursor.execute(query, values)
        data = cursor.fetchall()

        if len(data) == 1:
            user1 = str(data[0][3])
            user2 = str(data[0][4])
            user = user1 + " " + user2
            response = make_response(jsonify(Success = str(user)),200)
            response.headers["Access-Control-Allow-Origin"] = "*"
            return response
            #return json.dumps({'Success': user})
        else:

            return json.dumps({'Error': 'RFID not found'})'''

@app.route('/api/users', methods=["GET"])
def getUsers():
    conn = mysql.connect()
    cursor = conn.cursor()

    query = "SELECT * FROM Users"
    cursor.execute(query)
    data = cursor.fetchall()

    print(data)
    users = []

    for elem in data:
        user_dict = {}
        user_dict["Id"] = elem[0]
        user_dict["Email"] = elem[2]
        user_dict["Name"] = elem[3] + " " + elem[4]
        user_dict["RFID"] = elem[5]
        users.append(user_dict)

    #return json.dumps(users)
    return jsonify(users)

@app.route('/api/users/<int:id>', methods=["GET"])
def getUserById(id):
    conn = mysql.connect()
    cursor = conn.cursor()

    query = "SELECT * FROM Users"
    cursor.execute(query)
    data = cursor.fetchall()

    print(data)
    users = []

    for elem in data:
        user_dict = {}
        user_dict["Id"] = elem[0]
        user_dict["Email"] = elem[2]
        user_dict["Name"] = elem[3] + " " + elem[4]
        user_dict["RFID"] = elem[5]
        users.append(user_dict)

    #return json.dumps(users)
    return jsonify(users)

### CUSTOMERS API ###

@app.route('/api/customers', methods=["GET"])
def getCustomers():
    conn = mysql.connect()
    cursor = conn.cursor()

    query = "SELECT * FROM Customers"
    cursor.execute(query)
    data = cursor.fetchall()

    customers = []

    for elem in data:
        customer_dict = {}
        customer_dict["Id"] = elem[0]
        customer_dict["Name"] = elem[1]
        customers.append(customer_dict)

    #return json.dumps(customers)
    return jsonify(customers)

@app.route('/api/customers/<int:id>', methods=["GET"])
def getCustomerById(id):
    #id = request.args.get("id")

    conn = mysql.connect()
    cursor = conn.cursor()

    query = "SELECT * FROM Customers WHERE CustomerId = %s"
    cursor.execute(query, id)
    data = cursor.fetchall()

    customer = []

    for elem in data:
        customer_dict = {}
        customer_dict["Id"] = elem[0]
        customer_dict["Name"] = elem[1]
        customer.append(customer_dict)

    return jsonify(customer)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
