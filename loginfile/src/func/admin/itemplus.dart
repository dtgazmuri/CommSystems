import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/Widget/bezierContainer.dart';

import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

import '../connection.dart';

class additemPage extends StatefulWidget {
  additemPage({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _additemPageState createState() => _additemPageState();
}

class _additemPageState extends State<additemPage> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
  final name_controller = TextEditingController();
  final description_controller = TextEditingController();
  final category_controller = TextEditingController();
  final cst_controller = TextEditingController();
  final _scan_rfid_read = TextEditingController();

  Widget _entryField(String title,  _controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }
  String _scan_rfid = '';

  nfc_reader_tmp(){
    var Id = '';
    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);
      _scan_rfid = onData.id;
      print(onData.content);
    });
    return Id;
  }


  Widget _NfcButton() {
    return InkWell(
      onTap: () async {

        //RFID tmp = await fetchRFID();
        String tmp = nfc_reader_tmp();

        setState(() {
          //_scan_rfid = tmp.rfidNum;
          _scan_rfid = _scan_rfid; //smartphone
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],

            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF6F35A5), Color(0xfff7892b)])),
        child: Text(
          'Scan RFID',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () async {
          if(_scan_rfid != 'Scan RFID') {
            add_item(
              name_controller.text,
              description_controller.text,
              category_controller.text,
              cst_controller.text,
              _scan_rfid, );
          }else{
            add_item(
              name_controller.text,
              description_controller.text,
              category_controller.text,
              cst_controller.text,
              '',);
          }
          ElevatedButton(
            onPressed: () {
              _showSimpleDialog();
            },
            child: Text('Dialog'),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF6F35A5), Color(0xfff7892b)])),
          child: Text(
            'Submit',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  void _showSimpleDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Add item successful'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _dismissDialog();
                },
                child: const Text('OK'),
              ),

            ],
          );
        });
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'add ',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)
          ),
          children: [
            TextSpan(
              text: 'item ',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _ItemWidget() {
    return Column(
      children: <Widget>[
        _entryField("Name", name_controller),
        _entryField("Description" ,description_controller),
        _entryField("Category", category_controller),
        _entryField("Costumer", cst_controller),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _ItemWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    _NfcButton(),
                    Text(_scan_rfid, style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
