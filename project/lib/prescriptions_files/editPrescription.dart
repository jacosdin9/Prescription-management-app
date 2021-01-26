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
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("ID: " + data.id),
                            ),

                            SizedBox(height: 5),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.0),
                              height: 70,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent)
                              ),
                              child: Text("Name: " + data.name),
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