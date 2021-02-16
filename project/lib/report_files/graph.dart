import 'package:draw_graph/draw_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:draw_graph/models/feature.dart';

class Graph extends StatefulWidget{
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {

  List<Feature> features;

  @override
  void initState() {
    super.initState();

    features = [
      Feature(
        title: "Drink Water",
        color: Colors.blue,
        data: [0.2, 0.8, 1, 0.7,],
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Stock reports"),
        ),
        body: Column(
          children: [
            Text("GRAPH PAGE YEAH"),
            LineGraph(
              features: features,
              size: Size(500, 400),
              labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
              labelY: ['20%', '40%', '60%', '80%', '100%'],
              showDescription: true,
              graphColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

populateFeatures(){
  //retrieve records collection from current patient
  //x_axis = date
  //y_axis = remaining stock
}
