import 'dart:async';

import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double time = 0;
  static double yBirdAxis = 0;
  double height = 0;
  double initHeight = yBirdAxis;
  bool started = false;
  void jump(){
    time = 0;
    initHeight = yBirdAxis;
  }
  void startGame(){
    started = true;
    Timer.periodic(Duration(milliseconds: 40), (timer) {
      time += 0.05;
      height = -5*time*time + 2.5*time;
      setState(() {
        yBirdAxis= initHeight - height;
      });
      if(yBirdAxis > 1){
        timer.cancel();
        started = false;
      };
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: (){
                if(!started)
                  {
                    startGame();
                  }
                else{
                  jump();
                }
              },
              child: AnimatedContainer(
                alignment: Alignment(0,yBirdAxis),
                duration: Duration(milliseconds: 0),
                color: Colors.blue,
                child: Bird(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
