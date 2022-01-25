import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Scanner extends StatefulWidget {
  final String id;
  final String model;
  final int station;
  final int num;
  final bool rent;
  Scanner(this.id, this.model, this.station, this.num, this.rent);
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  ScanResult? scanResult;
  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  late String iD = widget.id;
  late bool rent = widget.rent;
  late String model = widget.model;
  late int station = widget.station;
  late int num = widget.num;
  FirebaseFirestore dataBase = FirebaseFirestore.instance;

  Future<void> updateDb() async {
    DocumentReference bikeDb2 = dataBase.doc('users/$iD');
    DocumentReference bikeDb1 = dataBase.doc('Station/$station/bike/$model');
    print(rent);
    print('rent');
    print(station);
    print(model);
    if (rent == false) {
      await bikeDb1
          .update({'num': num - 1})
          .then((value) => print("cycle database Updated"))
          .catchError((error) => print("Failed to update database: $error"));
      await bikeDb2
          .update({'Status': true})
          .then((value) => print("User database Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      await bikeDb1
          .update({'num': num + 1})
          .then((value) => print("cycle database Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      await bikeDb2
          .update({'Status': false})
          .then((value) => print("User database Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      updateDb();
      setState(() {
        scanResult = result;
      });
      print(scanResult);
      Navigator.pop(context,true);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Scan QR-code',
              style: GoogleFonts.unicaOne(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            leading: Icon(
              Icons.camera,
              color: Colors.black,
            ),
            backgroundColor: Colors.teal[100]),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  child: Image.asset('assets/bike1.jpg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Container(
                child: TextButton(
                    onPressed: _scan,
                    child: !rent
                        ? Text(
                            'Click to Rent Cycle',
                            style: Style,
                          )
                        : Text(
                            'Return Cycle',
                            style: Style,
                          )),
              ),
            )
          ],
        ),
        backgroundColor: Color(0xFFF5F5DB),
      ),
    ));
  }
}

const Style = TextStyle(fontSize: 30, color: Colors.black);
