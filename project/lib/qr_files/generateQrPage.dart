import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:qr_flutter/qr_flutter.dart';


class GenerateQrPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "QR Code",
      home: Scaffold(
        appBar: AppBar(
          title: Text("QR Code"),
        ),
        body: Center(
          child: Column(
            children: [

              SizedBox(height: 20),

              Text(
                "Scan this QR code to automatically fill out device ID and patient ID",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),

              QrImage(
                data: deviceID + "***" + currentPatientID,
                version: QrVersions.auto,
                size: 250.0,
              ),

              SizedBox(height: 60),

              Text(
                "Device ID: " + deviceID,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Patient ID: " + currentPatientID,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red),
                ),
                padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "BACK",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        )

      )
    );
  }

}