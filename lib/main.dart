import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  double playery = 0.745;
  double playeryinitial = 0.745;
  double objy = 1.4;
  double objyinitial = 1.4;
  bool isTimerActive = false;
  bool? jumpAscending;
  double peakJump = 0.5;
  Timer? _timer;
  Timer? jumpTimer;

  void stopTimer() {
    if (isTimerActive) {
      isTimerActive = false;
      setState(() {
        objy = objyinitial;
      });
      _controller.reset();
      jumpTimer?.cancel();
      _timer?.cancel();
    }
  }

  void startTimer() {
    const duration = const Duration(milliseconds: 10);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (objy <= 0.2 &&
          objy >= -0.05 &&
          playery >= 0.68 &&
          playery >= playeryinitial) {
        setState(() {
          isTimerActive = false;
        });
        _controller.stop();

        _timer?.cancel();
        jumpTimer?.cancel();
      } else {
        setState(() {
          objy -= 0.01;

          if (objy <= -0.2) {
            objy = objyinitial;
            // timer.cancel();
            // isTimerActive = false;
          }
        });
      }
    });
  }

  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3500), // Adjust the duration as needed
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _animation2 = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap:
            !isTimerActive || jumpTimer?.isActive != null && jumpTimer!.isActive
                ? null
                : () {
                    setState(() {
                      jumpAscending = true;
                    });
                    jumpTimer = Timer.periodic(
                      Duration(milliseconds: 20),
                      (Timer timer) {
                        if (jumpAscending == true) {
                          setState(() {
                            playery = playery + -0.05;
                          });
                          if (playery <= 0.4) {
                            setState(() {
                              jumpAscending = false;
                            });
                          }
                        } else {
                          setState(() {
                            playery = playery + 0.012;
                          });
                          if (playery >= playeryinitial) {
                            setState(() {
                              jumpAscending = false;
                              playery = playeryinitial;
                            });
                            jumpTimer?.cancel();
                          }
                        }
                      },
                    );
                  },
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.teal[300],
          child: SafeArea(
            child: Stack(
              children: [
                SlideTransition(
                  position: _animation,
                  child: Image.asset(
                    "assets/background.jpg",
                    fit: BoxFit.fill,
                    width: screenWidth,
                    height: screenHeight,
                  ), // Replace this with your image widget
                ),
                SlideTransition(
                  position: _animation2,
                  child: Image.asset(
                    "assets/background.jpg",
                    fit: BoxFit.fill,
                    width: screenWidth,
                    height: screenHeight,
                  ), // Replace this with your image widget
                ),
                // isTimerActive
                //     ? Image.asset(
                //         "assets/background.jpg",
                //         fit: BoxFit.fill,
                //         width: screenWidth,
                //         height: screenHeight,
                //       )
                //         .animate(onPlay: (controller) => controller.repeat())
                //         .moveX(
                //           curve: Curves.linear,
                //           delay: 0.ms,
                //           duration: 3500.ms,
                //           begin: 0,
                //           end: -MediaQuery.of(context).size.width,
                //         )
                //     : Image.asset(
                //         "assets/background.jpg",
                //         fit: BoxFit.fill,
                //         width: screenWidth,
                //         height: screenHeight,
                //       ),
                // isTimerActive
                //     ? Image.asset(
                //         "assets/background.jpg",
                //         fit: BoxFit.fill,
                //         width: screenWidth,
                //         height: screenHeight,
                //       )
                //         .animate(onPlay: (controller) => controller.repeat())
                //         .moveX(
                //           curve: Curves.linear,
                //           delay: 0.ms,
                //           duration: 3500.ms,
                //           begin: MediaQuery.of(context).size.width,
                //           end: 0,
                //         )
                //     : Container(),
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Text(
                //     'Variable Value: ${objy.toStringAsFixed(2)}',
                //     style: TextStyle(fontSize: 20.0, color: Colors.white),
                //   ),
                // ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Variable Value: ${playery.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0.1, playery),
                  child: Image.asset(
                    "assets/player.png",
                    height: 100,
                    width: 100,
                  ),
                ),
                Align(
                    alignment: FractionalOffset(objy, 0.77),
                    child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset("assets/obstacle1.png"))),
                Positioned.fill(
                  top: 50,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (isTimerActive) {
                                stopTimer();
                              } else {
                                _controller.repeat();
                                startTimer();
                                isTimerActive = true;
                              }
                            },
                            child: Text(isTimerActive ? 'Stop' : 'Play')),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isTimerActive = false;
                                objy = objyinitial;
                                playery = playeryinitial;
                              });
                              jumpTimer?.cancel();
                              _controller.reset();
                              _timer?.cancel();
                            },
                            child: Text("Reset")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
