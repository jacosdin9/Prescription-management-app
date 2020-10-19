import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/objects/prescription.dart';

class PrescriptionCard extends StatelessWidget {

  String id;
  String name;
  double dosage;
  String measurement;
  int noOfReminders;
  int stock;

  PrescriptionCard(this.id, this.name, this.dosage, this.measurement, this.noOfReminders, this.stock);

  @override
  Widget build(BuildContext context) {

    final prescriptionThumbnail = new Container(
      margin: new EdgeInsets.symmetric(
          vertical: 16.0
      ),
      alignment: FractionalOffset.centerLeft,
      child: RawMaterialButton(
        elevation: 0.0,
        fillColor: Colors.white,
        child: Icon(
          Icons.album,
          size: 40.0,
        ),
        padding: EdgeInsets.all(25.0),
        shape: CircleBorder(),
      ),
    );

    final prescriptionCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(name),
          new Container(height: 7.0),
          new Text(dosage.toString() + measurement),
          new Container(height: 7.0),
          new Text(id),
          new Container(
            margin: new EdgeInsets.symmetric(vertical: 8.0),
            height: 2.0,
            width: 18.0,
            color: new Color(0xff00c6ff),
          ),

        ],
      ),
    );

    final prescriptionCard = new GestureDetector(

        child: new Container(
          child: prescriptionCardContent,
          height: 124.0,
          margin: new EdgeInsets.only(left: 46.0),
          decoration: new BoxDecoration(
            color: Colors.red,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black,
                blurRadius: 5.0,
                offset: new Offset(0.0, 10.0),
              ),
            ],
          ),
        )
    );

    return new Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            prescriptionCard,
            prescriptionThumbnail,
          ],
        )
    );
  }
}