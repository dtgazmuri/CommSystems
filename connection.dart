import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert' as convert;

String URL = 'http://192.168.137.165:5000/';
String URL_totem = 'http://192.168.137.145:5000/';

User empty_usr = const User(
    rfidNum: '0',
    id: '0',
    cst_id: '0',
    email: '0',
    name: '0',
    surname: '0',
    type: '0');
RFID empty_rfid = const RFID(rfidNum: '0');
CST empty_cst = const CST(cst_id: '0', name: '0');

class RFID {
  final String rfidNum;

  const RFID({
    required this.rfidNum,
  });

  factory RFID.fromJson(Map<String, dynamic> json) {
    return RFID(
      rfidNum: json['rfid'],
    );
  }
}

/*Future<RFID> fetchRFID() async {
  final res2 = await http.post(Uri.parse('http://192.168.137.168:5000/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'rfid': '1234578'}));
  print('inviato');

  final _response = await http.get(Uri.parse('http://192.168.137.168:5000/'));

  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var jsonResponse = convert.jsonDecode(_response.body);
    var itemCount = jsonResponse['rfid'];
    print('rfid number: $itemCount');

    //body: '');
    print('done');
    if (res2.statusCode == 200) {
    } else {
      print('errore' + res2.statusCode.toString());
    }
    return RFID.fromJson(convert.jsonDecode(_response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load RFID');
  }
}
*/
//user functions

class User {
  final String rfidNum, id, email, name, surname, type, cst_id;

  const User(
      {required this.rfidNum,
      required this.id,
      required this.cst_id,
      required this.email,
      required this.name,
      required this.surname,
      required this.type});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      rfidNum: json['RFID'],
      id: json['Id'],
      email: json['Email'],
      name: json['Name'],
      surname: json['Surname'],
      type: json['Type'], // 0 usr, 1 cst_admin, 2 superadmin
      cst_id: json['CustomerId'],
    );
  }
}

class CST {
  final String cst_id, name;

  const CST({required this.cst_id, required this.name});

  factory CST.fromJson(Map<String, dynamic> json) {
    return CST(cst_id: json['Id'], name: json['Name']);
  }
}

class item {
  final String rfidNum,
      description,
      name,
      category,
      customer,
      present,
      loaned,
      id;

  const item(
      {required this.rfidNum,
      required this.category,
      required this.customer,
      required this.description,
      required this.loaned,
      required this.name,
      required this.present,
      required this.id});

  factory item.fromJson(Map<String, dynamic> json) {
    return item(
        description: json['Description'],
        rfidNum: json['RFID'],
        name: json['Name'],
        category: json['Category'],
        customer: json['Customer'],
        present: json['Present'],
        loaned: json['Loaned'],
        id: json['ItemId']);
  }
}

Future<User> signInUser(String email, String password) async {
  final _response = await sendUser(email, password);

  print(User.fromJson(convert.jsonDecode(_response.body)).name);

  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(convert.jsonDecode(_response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load User'); // void User?
    return empty_usr;
  }
}

sendUser(String email, String password) async {
  final res = await http.post(Uri.parse(URL + 'api/signIn'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body:
          convert.jsonEncode({'inputEmail': email, 'inputPassword': password}));

  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Signin');
    return res;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to send User'); // void User?
  }
}

/*SignInUser(String email, String pwd) async {
  //send the info of email and password to Login
  final _response = await http.post(Uri.parse(URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert
          .jsonEncode({'inputEmail': '1234578', 'inputPassword': 'qwerty'}));

  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var jsonResponse = convert.jsonDecode(_response.body);
    var itemCount = jsonResponse['rfid'];
    //print('rfid number: $itemCount');

    //body: '');
    //print('done');
    if (_response.statusCode == 200) {
    } else {
      print('errore' + _response.statusCode.toString());
    }
    return RFID.fromJson(convert.jsonDecode(_response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load RFID');
  }
}*/

Future<User> signInRFID() async {
  String rfid_str = '';
  RFID tmp = await fetchRFID();

  if (tmp.rfidNum != '') {
    print(tmp.rfidNum);
    final _response = await sendRFID(tmp.rfidNum);

    if (_response.statusCode == 200) {
      print('ok');
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(convert.jsonDecode(_response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Failed to load User');
      return empty_usr;
    }
  } else {
    return empty_usr;
  }
}

sendRFID(String rfid) async {
  final res = await http.post(Uri.parse(URL + 'api/signInRFID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'itemRFID': rfid}));
  return res;
}

Future<RFID> fetchRFID() async {
  final _response = await http.get(Uri.parse(URL_totem));

  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var jsonResponse = convert.jsonDecode(_response.body);
    var itemCount = jsonResponse['rfid'];
    print('rfid number: $itemCount');

    return RFID.fromJson(convert.jsonDecode(_response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load RFID');
    //return '';
  }
}

Future<User> getUser(String email) async {
  final _response = await sendemail(email);
  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(convert.jsonDecode(_response.body));

    return User.fromJson(convert.jsonDecode(_response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load User'); // void User?
    return empty_usr;
  }
}

Future<User> getUserId(String id) async {
  final _response = await sendId(id);
  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(convert.jsonDecode(_response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load User'); // void User?
    return empty_usr;
  }
}

sendemail(String email) async {
  //add ID search
  final res = await http.post(Uri.parse(URL + 'api/users/email'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'email': email}));
  return res;
}

sendId(String id) async {
  //add ID search
  final res = await http.get(
    Uri.parse(URL + 'api/users/' + id),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //body: convert.jsonEncode({'email': email})
  );
  return res;
}

add_user(String email, String password, String name, String type,
    String surname, String cst_ID, String rfid) async {
  if (rfid == '') {
    RFID tmp = await fetchRFID();
    rfid = tmp.rfidNum;
  }
  final res = await http.post(Uri.parse(URL + 'api/users/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({
        'password': password,
        'email': email,
        'name': name,
        'surname': surname,
        'rfid': rfid,
        'type': type,
        'customerId': cst_ID
      }));
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Added well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to add User'); // void User?
  }
  return res;
}

Future<List<dynamic>> get_users() async {
  // null string to get all the users of the entire app
  final _response = await http.get(
    Uri.parse(URL + 'api/users'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return CST.fromJson(convert.jsonDecode(_response.body));
    var dict = new Map();
    var list = [];
    var list_final = [];
    list = convert.jsonDecode(_response.body);

    for (int i = 0; i < list.length; i++) {
      User tmp = User.fromJson(list[i]);
      list_final.add(tmp);
    }
    return list_final; //list of users objects
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load User'); // void User?
    return [];
  }
}

remove_user(String id) async {
  final res = await http.delete(
    Uri.parse(URL + 'api/users/' + id),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //body: convert.jsonEncode({'Email': email})
  );
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('removed well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to remove User'); // void User?
  }
  return res;
}

add_cst(String name) async {
  final res = await http.post(Uri.parse(URL + 'api/customers/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'name': name}));
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Added well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to add User'); // void User?
  }
  return res;
}

Future<List<dynamic>> get_cst(String cstId) async {
  // String null to get all the possible customers
  final _response = await http.get(
    Uri.parse(URL + 'api/customers/' + cstId),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //body: convert.jsonEncode({'email': email})
  );
  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return CST.fromJson(convert.jsonDecode(_response.body));
    var dict = new Map();
    var list_cst = [];
    list_cst = convert.jsonDecode(_response.body);

    return list_cst;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load User'); // void User?
    return [];
  }
}

Future<List<dynamic>> get_csts() async {
  // String null to get all the possible customers
  final _response = await http.get(
    Uri.parse(URL + 'api/customers'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //body: convert.jsonEncode({'email': email})
  );
  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return CST.fromJson(convert.jsonDecode(_response.body));
    var dict = new Map();
    var list_cst = [];
    var list_final = [];
    list_cst = convert.jsonDecode(_response.body);
    for (int i = 0; i < list_cst.length; i++) {
      CST tmp = CST.fromJson(list_cst[i]);
      list_final.add(tmp);
    }

    return list_cst;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load CSTs'); // void User?
    return [];
  }
}

remove_cst(String id) async {
  final res = await http.delete(
    Uri.parse(URL + 'api/customers/' + id),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //body: convert.jsonEncode({'Name': name})
  );
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Removed well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to remove customer'); // void User?
  }
  return res;
}

add_item(String name, String description, String category, String cst,
    String rfid) async {
  if (rfid == '') {
    RFID tmp = await fetchRFID();
    rfid = tmp.rfidNum;
  }
  final res = await http.post(Uri.parse(URL + 'api/items/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({
        'description': description,
        'name': name,
        'category': category,
        'customer': cst,
        'rfid': rfid,
      }));
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Added well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to add item');
  }
  return res;
}

Future<List<dynamic>> get_item(String cstId) async {
  //null String ??
  final _response = await http.get(
    Uri.parse(URL + 'api/items/' + cstId), //check the url
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return CST.fromJson(convert.jsonDecode(_response.body));
    var dict = new Map();
    var list_item = [];
    list_item = convert.jsonDecode(_response.body);
    /*for (int i = 0; i < dict.length; i++) {
      item tmp = item.fromJson(dict["$i"]);
      list_item.add(tmp);
    }*/
    item tmp = item.fromJson(list_item[0]);
    print(tmp.category);
    return list_item;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load items'); // void User?
    return [];
  }
}

Future<List<dynamic>> get_items() async {
  //null String ??
  final _response = await http.get(
    Uri.parse(URL + 'api/items'), //check the url
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return CST.fromJson(convert.jsonDecode(_response.body));
    var dict = new Map();
    var list_item = [];
    var list_final = [];
    list_item = convert.jsonDecode(_response.body);

    for (int i = 0; i < list_item.length; i++) {
      item tmp = item.fromJson(list_item[i]);
      list_final.add(tmp);
    }
    return list_final;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load items'); // void User?
    return [];
  }
}

//controllare
remove_item(String id) async {
  final res = await http.delete(
    Uri.parse(URL + 'api/items/' + id),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //body: convert.jsonEncode({'Name': name})
  );
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Removed well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to remove item');
  }
  return res;
}

//item rent
item_rent(String itemId, String userId) async {
  final res = await http.put(Uri.parse(URL + 'api/items/rent'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'itemId': itemId, 'userId': userId}));

  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Rented well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to rent item');
  }
  return res;
}

item_rentRFID(String userId) async {
  RFID tmp = await fetchRFID();
  final res = await http.put(Uri.parse(URL + 'api/items/rentRFID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'userId': userId, 'itemRFID': tmp.rfidNum}));

  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Rented well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to rent item');
  }
  return res;
}

//item return, return RFID
item_return(String itemId) async {
  final res = await http.put(
    Uri.parse(URL + 'api/items/return/' + itemId),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //body: convert.jsonEncode({'itemId': itemId})
  );

  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Returned well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to return item'); // void User?
  }
  return res;
}

item_returnRFID() async {
  RFID tmp = await fetchRFID();
  final res = await http.put(
    Uri.parse(URL + 'api/items/returnRFID/' + tmp.rfidNum),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //body: convert.jsonEncode({'itemRFID': tmp.rfidNum})
  );

  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Returned well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to return item'); // void User?
  }
  return res;
}

Future<Map> item_ispresent(String itemId) async {
  final _response = await http.get(
    Uri.parse(URL + '/api/items/isRented/' + itemId),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return CST.fromJson(convert.jsonDecode(_response.body));
    var dict = new Map();
    dict = convert.jsonDecode(_response.body);
    return dict;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load User'); // void User?
    return {};
  }
}
