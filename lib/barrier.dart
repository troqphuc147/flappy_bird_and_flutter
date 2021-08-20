import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final double height;
  Barrier({this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: this.height,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(color: Colors.green[900], width: 10),
      ),
    );
  }
}
