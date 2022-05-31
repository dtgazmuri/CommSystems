import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert' as convert;

String URL = 'http://192.168.137.168:5000/';
String URL_totem = 'http://192.168.137.168:5000/';

User empty_usr = const User(
    rfidNum: '0',
    id: '0',
    cst_id: '0',
    email: '0',
    name: '0',
    surname: '0',
    type: '0');
RFID empty_rfid = const RFID(rfidNum: '0');

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
      type: json['Type'],
      cst_id: json['Customer_Id'],
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
        id: json['ItemID']);
  }
}

Future<User> signInUser(String email, String password) async {
  final _response = sendUser(email, password);

  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(convert.jsonDecode(_response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User'); // void User?
  }
}

sendUser(String email, String password) async {
  final res = await http.post(Uri.parse(URL + 'api/signIn'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body:
      convert.jsonEncode({'inputEmail': email, 'inputPassword': password}));
  return res;
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
    final _response = sendRFID(tmp.rfidNum);

    if (_response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(convert.jsonDecode(_response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load User');
      //return void User?
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
      body: convert.jsonEncode({'RFID': rfid}));
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
  final _response = sendemail(email);

  if (_response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(convert.jsonDecode(_response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User'); // void User?
  }
}

sendemail(String email) async {
  //add ID search
  final res = await http.post(Uri.parse(URL + 'api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'inputEmail': email}));
  return res;
}

add_user(String email, String password, String name, String type,
    String surname, String cst_ID, String rfid) async {
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
        'cst_ID': cst_ID
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

remove_user(String email) async {
  final res = await http.delete(Uri.parse(URL + 'api/users/<int:id>'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'Email': email}));
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('removed well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to remove User'); // void User?
  }
  return res;
}

//Future<CTS> getCst() {}

add_cst(String name) async {
  final res = await http.post(Uri.parse(URL + 'api/customers/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'Name': name}));
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

remove_cst(String name) async {
  final res = await http.delete(Uri.parse(URL + 'api/customers/<int:id>'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'Name': name}));
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Removed well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to remove customer'); // void User?
  }
  return res;
}

add_item(String name, String description, String category, String cst,
    String rfid, String id) async {
  final res = await http.post(Uri.parse(URL + 'api/item/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({
        'Description': description,
        'Name': name,
        'Category': category,
        'Customer': cst,
        'RFID': rfid,
        'ItemId': id,
      }));
  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Added well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to add item'); // void User?
  }
  return res;
}

//controllare
remove_item(String name) async {
  final res = await http.delete(Uri.parse(URL + 'api/items/<int:id>'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'Name': name}));
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

//item rent
item_rent(String itemId, String userId) async {
  final res = await http.put(Uri.parse(URL + 'api/item/rent'),
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
    throw Exception('Failed to rent item'); // void User?
  }
  return res;
}

//item return, return RFID
item_return(String itemId) async {
  final res = await http.put(Uri.parse(URL + 'api/item/return/<int:itemId>'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'itemId': itemId}));

  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Returned well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to return item'); // void User?
  }
  return res;
}

item_returnRFID() async {
  RFID tmp = await fetchRFID();
  final res = await http.put(Uri.parse(URL + 'api/item/return/<int:itemRFID>'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({'itemRFID': tmp.rfidNum}));

  if (res.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Returned well');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to return item'); // void User?
  }
  return res;
}