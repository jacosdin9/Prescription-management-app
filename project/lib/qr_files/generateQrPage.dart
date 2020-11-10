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
              QrImage(
                data: deviceID + "***" + currentPatientID,
                version: QrVersions.auto,
                size: 250.0,
              ),
              Text("Device ID: " + deviceID),
              Text("Patient ID: " + currentPatientID),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red),
                ),
                padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainArea()),
                  );
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