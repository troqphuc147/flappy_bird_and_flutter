import 'dart:async';
import 'dart:math';

import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double deviceHeight;
  double xBarrierAxis1;
  double xBarrierAxis2;
  double flexBird;
  double randomHeight1;
  double randomHeight2;
  double time;
  int score;
  int bestScore = 0;
  static double yBirdAxis;
  double height;
  double initHeight;
  bool started;
  @override
  void initState() {
    super.initState();
    xBarrierAxis1 = 2;
    xBarrierAxis2 = 3.5;
    randomHeight1 = (Random().nextInt(120) + 80).toDouble();
    randomHeight2 = (Random().nextInt(120) + 80).toDouble();
    time = 0;
    score = 0;
    yBirdAxis = 0;
    height = 0;
    initHeight = yBirdAxis;
    started = false;
  }
  void _showDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown[400],
            title: Center(
              child: Text(
                'Game over',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  score.toString(),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    if (score >= bestScore) bestScore = score;
                    //initState();
                    setState(() {
                      xBarrierAxis1 = 2;
                      xBarrierAxis2 = 3.5;
                      randomHeight1 = (Random().nextInt(120) + 80).toDouble();
                      randomHeight2 = (Random().nextInt(120) + 80).toDouble();
                      time = 0;
                      score = 0;
                      yBirdAxis = 0;
                      height = 0;
                      initHeight = yBirdAxis;
                      started = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Play again',
                    style: TextStyle(
                      fontSize: 20,
                        color: Colors.blue[100],
                    ),
                  ))
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void jump() {
    time = 0;
    initHeight = yBirdAxis;
  }

  void startGame() {
    started = true;
    deviceHeight = MediaQuery.of(context).size.height * 0.8;
    Timer.periodic(Duration(milliseconds: 40), (timer) async {
      time += 0.05;
      height = -5 * time * time + 2 * time;
      setState(() {
        yBirdAxis = initHeight - height;
        yBirdAxis >= 0
            ? flexBird = yBirdAxis / 2 + 0.5
            : flexBird = 0.5 - yBirdAxis.abs() / 2;
        if (xBarrierAxis1 <= -1.5) {
          xBarrierAxis1 = 1.5;
          randomHeight1 = (Random().nextInt(200) + 30).toDouble();
        } else {
          xBarrierAxis1 -= 0.05;
          if (xBarrierAxis1 <= -0.8 && xBarrierAxis1 >= -0.85) score += 1;
          if (bestScore <= score) bestScore = score;
        }
      });
      setState(() {
        if (xBarrierAxis2 <= -1.5) {
          xBarrierAxis2 = 1.5;
          randomHeight2 = (Random().nextInt(200) + 30).toDouble();
        } else {
          xBarrierAxis2 -= 0.05;
          if (xBarrierAxis2 <= -0.8 && xBarrierAxis2 >= -0.85) {
            score += 1;
            if (bestScore <= score) bestScore = score;
          }
        }
      });
      if (yBirdAxis > 1) {
        timer.cancel();
        started = false;
        await _showDialog();
      }
      ;
      if ((xBarrierAxis1 <= -0.6 && xBarrierAxis1 >= -1) &&
          (flexBird * deviceHeight <= randomHeight1 ||
              (deviceHeight - flexBird * deviceHeight <=
                  410 - randomHeight1))) {
        timer.cancel();
        started = false;
        await _showDialog();
      }
      if ((xBarrierAxis2 <= -0.6 && xBarrierAxis2 >= -1) &&
          (flexBird * deviceHeight <= randomHeight2 ||
              (deviceHeight - flexBird * deviceHeight <=
                  410 - randomHeight2))) {
        timer.cancel();
        started = false;
        await _showDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: GestureDetector(
                onTap: () {
                  if (!started) {
                    startGame();
                  } else {
                    jump();
                  }
                },
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(-0.8, yBirdAxis),
                      duration: Duration(milliseconds: 0),
                      color: Colors.blue,
                      child: Bird(),
                    ),
                    Container(
                      child: AnimatedContainer(
                        alignment: Alignment(xBarrierAxis1, -1),
                        duration: Duration(milliseconds: 0),
                        child: Barrier(
                          height: randomHeight1,
                        ),
                      ),
                    ),
                    Container(
                      child: AnimatedContainer(
                        alignment: Alignment(xBarrierAxis1, 1),
                        duration: Duration(milliseconds: 0),
                        child: Barrier(
                          height: 370 - randomHeight1,
                        ),
                      ),
                    ),
                    Container(
                      child: AnimatedContainer(
                        alignment: Alignment(xBarrierAxis2, -1),
                        duration: Duration(milliseconds: 0),
                        child: Barrier(
                          height: randomHeight2,
                        ),
                      ),
                    ),
                    Container(
                      child: AnimatedContainer(
                        alignment: Alignment(xBarrierAxis2, 1),
                        duration: Duration(milliseconds: 0),
                        child: Barrier(
                          height: 370 - randomHeight2,
                        ),
                      ),
                    ),
                    started
                        ? Container(
                            color: Colors.transparent,
                            child: Center(
                              heightFactor: 2,
                              child: Text(
                                score.abs().toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 90),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.transparent,
                            child: Center(
                              heightFactor: 8,
                              child: Text(
                                'T a p  T o  P l a y',
                                style: TextStyle(
                                    color: Colors.blue[900], fontSize: 30),
                              ),
                            ),
                          ),
                  ],
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.brown,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    color: Colors.green,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(
                          'Best score:',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          bestScore.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
