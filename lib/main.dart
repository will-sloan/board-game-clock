import 'package:flutter/material.dart';
import 'dart:async';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  var a = 5;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Timer App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TimerBody(),
    );
  }
}

class TimerBody extends StatefulWidget {
  @override
  _TimerBodyState createState() => _TimerBodyState();
}

class MyTimer {
  int index;
  CountdownController cont;
  int nextPlayer;
  bool alive;

  MyTimer(int index, CountdownController cont, int nextPlayer, bool alive) {
    this.index = index;
    this.cont = cont;
    this.nextPlayer = nextPlayer;
    this.alive = alive;
  }

  String toString() {
    return "$index connects to $nextPlayer";
  }

  set setCont(CountdownController cont) {
    this.cont = cont;
  }

  set setIndex(int index) {
    this.index = index;
  }

  set setNextPlayer(int nextPlayer) {
    this.nextPlayer = nextPlayer;
  }

  set setAlive(bool alive) {
    this.alive = alive;
  }

  CountdownController get controller {
    return cont;
  }

  int get getIndex {
    return index;
  }

  int get getNextPlayer {
    return nextPlayer;
  }

  bool get getAive {
    return alive;
  }
}

class _TimerBodyState extends State<TimerBody> {
  static final maxPlayers = 8;
  var players = 0;
  double duration = 0;
  final _formKey = GlobalKey<FormState>();
  final playerController = TextEditingController();
  final durationController = TextEditingController();
  //final List<MyTimer> timers = new List();
  // final ValueNotifier<List<MyTimer>> timers =
  //     ValueNotifier<List<MyTimer>>(new List());
  final CountdownController controller = CountdownController();
  final List<MyTimer> timers = List.generate(maxPlayers, (index) {
    return MyTimer(index, CountdownController(), index, false);
  });
  // for (var i=0; i<max_players; i++){
  //   var p = MyTimer(
  //                                               index,
  //                                               CountdownController(),
  //                                               nextPlayer,
  //                                               true);
  //                                           print(p);
  //                                           timers.value.add(p);
  // }
  int currentIndex = 0;
  bool _isPause = true;
  bool _isRestart = false;

  List colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.yellow,
    Colors.indigo,
    Colors.lime,
    Colors.teal,
    Colors.cyan,
    Colors.pink
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    durationController.dispose();
    playerController.dispose();
    super.dispose();
  }

  void _setPlayers(num_players) {
    setState(() {
      players = num_players;
    });
  }

  @override
  Widget build(BuildContext context) {
    var firstTime = true;
    // final IconData buttonIcon = _isRestart
    //     ? Icons.refresh
    //     : (_isPause ? Icons.pause : Icons.play_arrow);
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer App"),
        leading: IconButton(
          icon: Icon(Icons.ac_unit),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: TextFormField(),
                              // ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: playerController,
                                  decoration: const InputDecoration(
                                    hintText: "Number of Players",
                                  ),
                                  validator: (value) {
                                    if (int.tryParse(value) == null) {
                                      return "Must input a number between 1-8";
                                    } else if (int.tryParse(value) < 1 ||
                                        int.tryParse(value) > 8) {
                                      return "Number must be between 1-8";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: durationController,
                                  decoration: const InputDecoration(
                                    hintText: "Duration (minutes)",
                                  ),
                                  validator: (value) =>
                                      double.tryParse(value) == null
                                          ? "Must be a number"
                                          : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Submit"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        //timers = <MyTimer>[];
                                        players =
                                            int.parse(playerController.text);
                                        //var temp = players;
                                        duration = double.parse(
                                            durationController.text);
                                        currentIndex = players - 1;
                                        for (var i = 0; i < 8; i++) {
                                          timers[i].setAlive = false;
                                          timers[i].setNextPlayer = i;
                                        }
                                        for (var i = 0; i < players; i++) {
                                          timers[i].setAlive = true;
                                          timers[i].setNextPlayer =
                                              i + 1 < players
                                                  ? i + 1
                                                  : 0;
                                        }
                                        // timers.value.clear();
                                        // print(timers.value.length);
                                        // for (var index = 0;
                                        //     index < 8;
                                        //     index++) {
                                        //   temp--;
                                        //   if (temp > 0) {
                                        // var nextPlayer = index + 1 < players
                                        //     ? index + 1
                                        //     : 0;
                                        //     var p = MyTimer(
                                        //         index,
                                        //         CountdownController(),
                                        //         nextPlayer,
                                        //         true);
                                        //     print(p);
                                        //     timers.value.add(p);
                                        //   } else {
                                        //     var p = MyTimer(
                                        //         index,
                                        //         CountdownController(),
                                        //         index,
                                        //         false);
                                        //     print(p);
                                        //     timers.value.add(p);
                                        //   }
                                        //if (index != 0) {
                                        //p.cont.pause();
                                        //}

                                        // }
                                        // print(timers.value.length);
                                      });
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              for (var player in timers) {
                player.cont.restart();
                player.cont.pause();
              }
              currentIndex = players - 1;
            },
          )
        ],
      ),
      body:
          // GestureDetector(
          //     child: Countdown(
          //       controller: controller,
          //       seconds: 5,
          //       build: (_, double time) => Text(
          //         time.toString(),
          //         style: TextStyle(
          //           fontSize: 100,
          //         ),
          //       ),
          //       interval: Duration(milliseconds: 100),
          //       onFinished: () {
          //         print('Timer is done!');

          //         setState(() {
          //           _isRestart = true;
          //         });
          //       },
          //     ),
          //     onTap: () {
          //       final isCompleted = controller.isCompleted;
          //       isCompleted ? controller.restart() : controller.pause();

          //       if (!isCompleted && !_isPause) {
          //         controller.resume();
          //       }

          //       if (isCompleted) {
          //         setState(() {
          //           _isRestart = false;
          //         });
          //       } else {
          //         setState(() {
          //           _isPause = !_isPause;
          //         });
          //       }
          //     }),

          GestureDetector(
        onTap: () {
          setState(() {
            print(timers.length);
            print("Stopping timer: $currentIndex");
            timers[currentIndex].cont.pause();
            currentIndex = timers[currentIndex].nextPlayer;
            print("Starting timer: $currentIndex");
            timers[currentIndex].cont.resume();
          });
        },
        child: Column(
          children: timers.where((t) => t.alive).map((timer) {
            var index = timers.indexOf(timer);
            return Expanded(
              child: Card(
                child: Column(children: <Widget>[
                  Expanded(
                    child: Container(
                      // height:
                      //     MediaQuery.of(context).size.height /
                      //         players,
                      width: double.infinity,
                      color: colorList[index],
                      child: Text("Player ${index + 1}",
                          style: TextStyle(fontSize: 36)),
                      alignment: Alignment.center,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: colorList[index],
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Countdown(
                        controller: timer.cont,
                        seconds: (duration * 60).ceil(),
                        build: (context, double time) => Text(time.toString(),
                            style: TextStyle(fontSize: 36)),
                        interval: Duration(milliseconds: 100),
                        onFinished: () {
                          setState(() {
                            if (index == 0) {
                              timers[timers.length - 1].nextPlayer =
                                  timers[index].nextPlayer;
                            } else {
                              timers[index - 1].nextPlayer =
                                  timers[index].nextPlayer;
                            }
                          });
                          print('Timer is done!');
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }).toList(),

          // List.generate(players, (index) {
          //   var p = timers[index];
          //   print("At index $index");
          //   p.setAlive = true;
          //   p.setNextPlayer = index + 1 < players ? index + 1 : 0;
          //p.cont.pause();
          // if (firstTime) {
          //   var nextPlayer = index + 1 < players ? index + 1 : 0;
          //   var p = MyTimer(index, CountdownController(), nextPlayer);
          //   //if (index != 0) {
          //   //p.cont.pause();
          //   //}
          //   print(p);
          //   timers.add(p);
          // }

          // return Expanded(
          //   child: Card(
          //     child: Column(children: <Widget>[
          //       Expanded(
          //         child: Container(
          //           // height:
          //           //     MediaQuery.of(context).size.height /
          //           //         players,
          //           width: double.infinity,
          //           color: colorList[index],
          //           child: Text("Player ${index + 1}",
          //               style: TextStyle(fontSize: 36)),
          //           alignment: Alignment.center,
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(
          //           color: colorList[index],
          //           width: double.infinity,
          //           alignment: Alignment.center,
          //           child: Countdown(
          //             controller: p.cont,
          //             seconds: (duration * 60).ceil(),
          //             build: (context, double time) => Text(time.toString(),
          //                 style: TextStyle(fontSize: 36)),
          //             interval: Duration(milliseconds: 100),
          //             onFinished: () {
          //               setState(() {
          //                 if (p.index == 0) {
          //                   timers[timers.length - 1].nextPlayer =
          //                       timers[p.index].nextPlayer;
          //                 } else {
          //                   timers[p.index - 1].nextPlayer =
          //                       timers[p.index].nextPlayer;
          //                 }
          //               });
          //               print('Timer is done!');
          //             },
          //           ),
          //         ),
          //       ),
          //     ]),
          //   ),
          // );
          //}
        ),
      ),
      // ),

      // body: MediaQuery.of(context).orientation == Orientation.portrait
      //     ? portraitMode(context, )
      //     : landscapeMode(),
      //   OrientationBuilder(builder: (context, orientation) {
      //     return orientation == Orientation.portrait
      //         ? portraitMode()
      //         : landscapeMode();
      //   }
      // )
    );
  }
}

// Widget portraitMode(context) {
//   var height = MediaQuery.of(context).size.height;
//   var width = MediaQuery.of(context).size.width;
//   return Column(children: <Widget>[
//     Container(height: height, width: width, child: Text(""))
//   ],)
// }

// Widget landscapeMode() {
//   return Container(child: Text("Bye"));
// }
