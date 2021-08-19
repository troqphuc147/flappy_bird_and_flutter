import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
        child: Image.asset(
            'lib/images/flappybird1.png'
        )
    );
  }
}
