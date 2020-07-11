import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
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
  int hasMe;
  bool alive;

  MyTimer(int index, CountdownController cont, int nextPlayer, int hasMe,
      bool alive) {
    this.index = index;
    this.cont = cont;
    this.nextPlayer = nextPlayer;
    this.hasMe = hasMe;
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

  set setHasMe(int hasMe) {
    this.hasMe = hasMe;
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

  int get getHasMe {
    return hasMe;
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
  final CountdownController controller = CountdownController();
  final List<MyTimer> timers = List.generate(maxPlayers, (index) {
    return MyTimer(index, CountdownController(), index, index, false);
  });
  int currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer App"),
        leading: IconButton(
          icon: Icon(Icons.change_history),
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
                                        players =
                                            int.parse(playerController.text);
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
                                              i + 1 < players ? i + 1 : 0;
                                          if (i == 0) {
                                            timers[i].setHasMe = players - 1;
                                          } else {
                                            timers[i].setHasMe = i - 1;
                                          }
                                        }
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
              setState(() {
                for (var i = 0; i < 8; i++) {
                  timers[i].setAlive = false;
                  timers[i].setNextPlayer = i;
                }
                for (var i = 0; i < players; i++) {
                  timers[i].setAlive = true;
                  timers[i].setNextPlayer = i + 1 < players ? i + 1 : 0;
                  if (i == 0) {
                    timers[i].setHasMe = players - 1;
                  } else {
                    timers[i].setHasMe = i - 1;
                  }
                }
              });
              for (var player in timers) {
                player.cont.restart();
                player.cont.pause();
              }
              currentIndex = players - 1;
            },
          )
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        //if (Orientation.portrait == orientation) {
        return GestureDetector(
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
          child: orientation == Orientation.portrait
              ? Column(
                  children: timers.where((t) => t.alive).map((timer) {
                    var index = timers.indexOf(timer);
                    return Expanded(
                      child: Card(
                        child: Column(children: <Widget>[
                          Expanded(
                            child: Container(
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
                                build: (context, double time) => Text(
                                    time.toString(),
                                    style: TextStyle(fontSize: 36)),
                                interval: Duration(milliseconds: 100),
                                onFinished: () {
                                  print(timers);
                                  setState(() {
                                    // for (var i in timers) {
                                    //   if
                                    // }
                                    timers[timer.hasMe].nextPlayer =
                                        timer.nextPlayer;
                                    timers[timer.nextPlayer].hasMe =
                                        timer.hasMe;
                                    //timer.alive = false;
                                    // if (index == 0) {
                                    //   print("In index 0");
                                    //   timers[players - 1].nextPlayer =
                                    //       timers[index].nextPlayer;
                                    //   print(timers);
                                    // } else {
                                    //   print("In else");
                                    //   timers[index - 1].nextPlayer =
                                    //       timers[index].nextPlayer;
                                    // }
                                    print(timers.length);
                                    print("Stopping timer: $currentIndex");
                                    timers[currentIndex].cont.pause();
                                    currentIndex =
                                        timers[currentIndex].nextPlayer;
                                    print("Starting timer: $currentIndex");
                                    timers[currentIndex].cont.resume();
                                    timers[timer.nextPlayer].cont.resume();
                                    //timer.setAlive = false;
                                  });
                                  print(timers);
                                  print('Timer is done!');
                                },
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  }).toList(),
                )
              : Row(
                  children: timers.where((t) => t.alive).map((timer) {
                    var index = timers.indexOf(timer);
                    return Expanded(
                      child: Card(
                        child: Column(children: <Widget>[
                          Expanded(
                            child: Container(
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
                                build: (context, double time) => Text(
                                    time.toString(),
                                    style: TextStyle(fontSize: 36)),
                                interval: Duration(milliseconds: 100),
                                onFinished: () {
                                  setState(() {
                                    timers[timer.hasMe].nextPlayer =
                                        timer.nextPlayer;
                                    timers[timer.nextPlayer].hasMe =
                                        timer.hasMe;
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
                ),
        );
      }),
    );
  }
}
