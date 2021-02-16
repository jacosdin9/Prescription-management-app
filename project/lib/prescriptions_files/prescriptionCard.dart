import 'package:flutter/material.dart';
import 'package:project/prescriptions_files/prescriptionPopup.dart';

class PrescriptionCard extends StatelessWidget {

  String id;
  String name;
  double strength;
  String strengthUnits;
  int unitsPerDosage;
  String reminderFreq;
  int daysInterval;
  List reminderTimes;
  List specificDays;
  int stockReminder;
  int stockNo;
  bool silentReminders;
  DateTime lastRestockDate;

  PrescriptionCard(this.id, this.name, this.strength, this.strengthUnits, this.unitsPerDosage, this.reminderFreq, this.daysInterval, this.reminderTimes, this.specificDays, this.stockReminder, this.stockNo, this.silentReminders, this.lastRestockDate);

  @override
  Widget build(BuildContext context) {

    final prescriptionThumbnail = Container(
      margin: EdgeInsets.symmetric(
          vertical: 16.0
      ),
      alignment: FractionalOffset.centerLeft,
      child: RawMaterialButton(
        onPressed: () {},
        elevation: 0.0,
        fillColor: Colors.amber,
        child: Icon(
          Icons.album,
          size: 40.0,
        ),
        padding: EdgeInsets.all(25.0),
        shape: CircleBorder(),
      ),
    );

    final prescriptionCardContent = Container(
      margin: EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 4.0),
          Text(name),
          Container(height: 7.0),
          Text(reminderFreq.toString()),
          Container(height: 7.0),
          Text(id),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            height: 2.0,
            width: 18.0,
            color: Color(0xff00c6ff),
          ),

        ],
      ),
    );

    final prescriptionCard = GestureDetector(
        onTap: () {
          var popUp = PrescriptionPopup(id, name, strength, strengthUnits, unitsPerDosage, reminderFreq, daysInterval, reminderTimes, specificDays, stockReminder, stockNo, silentReminders, lastRestockDate);

          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context){
              return popUp;
            },
          );
        },
        child: Container(
          child: prescriptionCardContent,
          height: 124.0,
          margin: EdgeInsets.only(left: 46.0),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 5.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
        )
    );

    return Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: Stack(
          children: <Widget>[
            prescriptionCard,
            prescriptionThumbnail,
          ],
        )
    );
  }
}