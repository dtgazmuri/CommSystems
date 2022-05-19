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

#################
### USERS API ###
################

@app.route('/api/signIn', methods=["POST"])
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
            user = []
            for elem in data:
                user_dict = {}
                user_dict["Id"] = elem[0]
                user_dict["Email"] = elem[2]
                user_dict["Name"] = elem[3] + " " + elem[4]
                user_dict["RFID"] = elem[5]
                user.append(user_dict)
            return jsonify(user)
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

@app.route('/api/users/<int:id>', methods=["GET", "DELETE"])
def getUserById(id):
    conn = mysql.connect()
    cursor = conn.cursor()

    if request.method == "GET":

        query = "SELECT * FROM Users WHERE USERID = %s"
        cursor.execute(query, id)
        data = cursor.fetchall()

        users = []

        for elem in data:
            user_dict = {}
            user_dict["Id"] = elem[0]
            user_dict["Email"] = elem[2]
            user_dict["Name"] = elem[3] + " " + elem[4]
            user_dict["RFID"] = elem[5]
            users.append(user_dict)

        return jsonify(users)
    
    elif request.method == "DELETE":

        query = "DELETE FROM Users WHERE USERID = %s"
        cursor.execute(query, id)
        conn.commit()

        return "200: User deleted"

@app.route('/api/users/email', methods=["GET"])
def getUserByEmail():
    conn = mysql.connect()
    cursor = conn.cursor()

    email = request.json["email"]
    query = "SELECT * FROM Users WHERE USERNAME = %s"
    values = (email)
    cursor.execute(query,values)
    data = cursor.fetchall()

    users = []
    if len(data) == 1:
        for elem in data:
            user_dict = {}
            user_dict["Id"] = elem[0]
            user_dict["Email"] = elem[2]
            user_dict["Name"] = elem[3] + " " + elem[4]
            user_dict["RFID"] = elem[5]
            users.append(user_dict)

    return jsonify(users) 

## New user
@app.route('/api/users/register', methods=["POST"])
def createUser():
    conn = mysql.connect()
    cursor = conn.cursor()

    if request.json["password"] and request.json["email"] and request.json["name"] and request.json["surname"] and request.json["rfid"]:
        query = "INSERT INTO USERS(password, username, name, surname, rfid) VALUES(%s, %s, %s, %s, %s)"
        cursor.execute(query, (request.json["password"], request.json["email"], request.json["name"], request.json["surname"], request.json["rfid"]))
        conn.commit()

        return "200: User created"
    
    else:

        return "400: Bad request"
    

#####################
### CUSTOMERS API ###
#####################

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

@app.route('/api/customers/<int:id>', methods=["GET", "DELETE"])
def getCustomerById(id):
    conn = mysql.connect()
    cursor = conn.cursor()

    if request.method == "GET":
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
    
    elif request.method == "DELETE":
        query = "DELETE FROM Customers WHERE CustomerId = %s"
        cursor.execute(query, id)
        conn.commit()

        return "200: Customer deleted"

## New customer
@app.route('/api/customers/register', methods=["POST"])
def createCustomer():
    conn = mysql.connect()
    cursor = conn.cursor()

    if request.json["name"]:
        query = "INSERT INTO CUSTOMERS(name) VALUES(%s)"
        cursor.execute(query, (request.json["name"]))
        conn.commit()

        return "200: Customer created"
    else:
        return "400: Bad request"

#################
### ITEMS API ###
#################

@app.route('/api/items', methods=["GET"])
def getAllItems():
    conn = mysql.connect()
    cursor = conn.cursor()

    query = "SELECT * FROM Items"
    cursor.execute(query)
    data = cursor.fetchall()

    items = []

    for elem in data:
        item_dict = {}
        item_dict["ItemId"] = elem[0]
        item_dict["Description"] = elem[1]
        item_dict["Name"] = elem[2]
        item_dict["Category"] = elem[3]
        item_dict["Customer"] = elem[4]
        item_dict["Present"] = elem[5]
        item_dict["Loaned"] = elem[6]
        item_dict["RFID"] = elem[7]
        items.append(item_dict)

    return jsonify(items)

@app.route('/api/items/<int:id>', methods=["GET", "DELETE"])
def getItemById(id):
    conn = mysql.connect()
    cursor = conn.cursor()

    if request.method == "GET":
        query = "SELECT * FROM Items WHERE ITEMID = %s"
        cursor.execute(query, id)
        data = cursor.fetchall()

        items = []

        for elem in data:
            item_dict = {}
            item_dict["ItemId"] = elem[0]
            item_dict["Description"] = elem[1]
            item_dict["Name"] = elem[2]
            item_dict["Category"] = elem[3]
            item_dict["Customer"] = elem[4]
            item_dict["Present"] = elem[5]
            item_dict["Loaned"] = elem[6]
            item_dict["RFID"] = elem[7]
            items.append(item_dict)

        return jsonify(items)
    
    elif request.method == "DELETE":
        query = "DELETE FROM ITEMS WHERE itemId = %s"
        cursor.execute(query, id)
        conn.commit()

        return "200: Item deleted"

## New item
@app.route('/api/items/create', methods=["POST"])
def createItem():
    conn = mysql.connect()
    cursor = conn.cursor()

    if request.json["description"] and request.json["name"] and request.json["category"] and request.json["customer"] and request.json["rfid"]:
        query = "INSERT INTO ITEMS(description, name, category, customer, rfid) VALUES(%s, %s, %s, %s, %s)"
        cursor.execute(query, (request.json["description"], request.json["name"], request.json["category"], request.json["customer"], request.json["rfid"]))
        conn.commit()

        return "200: Item created"
    else:
        return "400: Bad request"

@app.route('/api/items/isRented/<int:itemId>', methods=["GET"])
def isItemRented(itemId):
    conn = mysql.connect()
    cursor = conn.cursor()

    query = "SELECT LOANED FROM ITEMS WHERE itemId = %s"
    cursor.execute(query, itemId)
    data = cursor.fetchall()

    if len(data) == 0:
        return "404: Item does not exist"
    else:
        if data[0][0] == 0:
            return "0"
        else:
            return "1"


## Rent item with item id
@app.route('/api/items/rent', methods=["PUT"])
def rentItemToUser():
    conn = mysql.connect()
    cursor = conn.cursor()

    if request.json["userId"] and request.json["itemId"]:
        userId = request.json["userId"]
        itemId = request.json["itemId"]
        if isItemRented(itemId) == 0:

            query = "UPDATE ITEMS SET PRESENT = 0, LOANED = %s WHERE itemId = %s"
            values = (userId, itemId)
            cursor.execute(query, values)
            conn.commit()

            return "200: Success"
        else:
            return "400: Item rented already"
    else:
        return "400: Bad request"

## Rent item with item RFID
@app.route('/api/items/rentRFID', methods=["PUT"])
def rentItemToUserWithRFID():
    conn = mysql.connect()
    cursor = conn.cursor()

    if request.json["userId"] and request.json["itemRFID"]:
        userId = request.json["userId"]
        itemRFID = request.json["itemRFID"]

        query = "UPDATE ITEMS SET PRESENT = 0, LOANED = %s WHERE rfid = %s"
        values = (userId, itemRFID)
        cursor.execute(query, values)
        conn.commit()

        return "200: Success"
    else:
        return "400: Bad request"

## Return item with item id
@app.route('/api/items/return/<int:itemId>', methods=["PUT"])
def returnItem(itemId):
    conn = mysql.connect()
    cursor = conn.cursor()

    if itemId and isItemRented(itemId) == "1":
        query = "UPDATE ITEMS SET PRESENT = 1, LOANED = 0 WHERE itemId = %s"
        cursor.execute(query, itemId)
        conn.commit()

        return "200: Item returned"
    else:
        return "400: Bad request"

## Return item with item RFID
@app.route('/api/items/returnRFID/<int:itemRFID>', methods=["PUT"])
def returnItemRFID(itemRFID):
    conn = mysql.connect()
    cursor = conn.cursor()

    if itemRFID:
        query = "UPDATE ITEMS SET PRESENT = 1, LOANED = 0 WHERE rfid = %s"
        cursor.execute(query, itemRFID)
        conn.commit()

        return "200: Item returned"
    else:
        return "400: Bad request"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
