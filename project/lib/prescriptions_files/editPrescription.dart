import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/prescriptions_files/prescriptionClass.dart';


class EditPrescription extends StatefulWidget {

  final data;

  EditPrescription(this.data);

  @override
  _EditPrescriptionState createState() => _EditPrescriptionState(data);
}

class _EditPrescriptionState extends State<EditPrescription> {

  PrescriptionClass data;

  _EditPrescriptionState(this.data);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Edit Prescription",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Edit Prescription"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            //NAME
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Name: " + data.name),
                              ),
                            ),

                            SizedBox(height: 5),

                            //STRENGTH
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Strength: " + data.strength.toString()),
                              ),
                            ),

                            SizedBox(height: 5),

                            //STRENGTH UNITS
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Strength Units: " + data.strengthUnits),
                              ),
                            ),

                            SizedBox(height: 5),

                            //UNITS PER DOSAGE
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Units Per Dosage: " + data.unitsPerDosage.toString()),
                              ),
                            ),

                            SizedBox(height: 5),

                            //STOCK REMINDERS
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Stock Reminders: "),
                              ),
                            ),

                            SizedBox(height: 5),

                            //REMAINING STOCK
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Remaining Stock: " + data.stockNo.toString()),
                              ),
                            ),

                            SizedBox(height: 5),

                            //REMINDER FREQUENCY
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Reminder Frequency: " + data.reminderFreq),
                              ),
                            ),

                            SizedBox(height: 5),

                            //REMINDER DAYS
                            GestureDetector(
                              onTap: () {

                              },
                              child: data.reminderFreq == "Specific days" ?
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Reminder Days"),
                              ) : SizedBox(),
                            ),

                            SizedBox(height: 5),

                            //DAYS INTERVAL
                            GestureDetector(
                              onTap: () {

                              },
                              child: data.reminderFreq == "Days Interval" ?
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Name: " + data.daysInterval.toString()),
                              ) : SizedBox(height: 0),
                            ),

                            SizedBox(height: 5),

                            //REMINDER TIMES
                            GestureDetector(
                              onTap: () {

                              },
                              child: data.reminderFreq != "None" ?
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Reminder Times"),
                              ) :SizedBox(height: 0),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}