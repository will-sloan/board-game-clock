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
  /*
  MyTimer is used later in a List<MyTimer>
  Used to keep track of each controller and to know which user to go to onTap or when a timer finishes
  */
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
  // The max amount of players that work without running out of screen room
  static final maxPlayers = 8;
  // Valyes that will be changed by the form
  var players = 0;
  double duration = 0;

  // Used for taking input from the user
  final _formKey = GlobalKey<FormState>();
  final playerController = TextEditingController();
  final durationController = TextEditingController();

  // Generates 8 players each time, and sets them to some default parameters
  // When the user sets how many players they want, the setState will change
  // the alive value of the inputted amount of players
  // Ex: Input of 4, the first 4 in this list will later have their alive = true
  final List<MyTimer> timers = List.generate(maxPlayers, (index) {
    return MyTimer(index, CountdownController(), index, index, false);
  });
  int currentIndex = 0;

  // There is a max of 8 players and each will have their won color
  List colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.yellow,
    Colors.indigo,
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
                  // The form for taking user input
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
                                      // Since there is valid input, we have to change
                                      // the amount of timers entered to alive
                                      // (only alive timers are created into widgets)
                                      setState(() {
                                        players =
                                            int.parse(playerController.text);
                                        duration = double.parse(
                                            durationController.text);
                                        currentIndex = players - 1;
                                        // resets each timer
                                        for (var i = 0; i < 8; i++) {
                                          timers[i].setAlive = false;
                                          timers[i].setNextPlayer = i;
                                        }
                                        // Actually sets them to alive
                                        // Also sets which player will come next
                                        // and who has each player
                                        for (var i = 0; i < players; i++) {
                                          timers[i].setAlive = true;
                                          //timers[i].cont.pause();
                                          timers[i].setNextPlayer =
                                              i + 1 < players ? i + 1 : 0;
                                          if (i == 0) {
                                            timers[i].setHasMe = players - 1;
                                          } else {
                                            timers[i].setHasMe = i - 1;
                                          }
                                        }
                                      });
                                      // closes the window
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
              // Does the smae thing as the Form except it keeps the
              // duration and the amount of players the same
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
              // Resets all the timers and pauses (so they don't immediately start counting down)
              for (var player in timers) {
                player.cont.restart();
                player.cont.pause();
              }
              // This makes it so the first tap starts the player 1 timer (rather than player 2)
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
              // pauses the current timer
              // then resumes whichever is next
              timers[currentIndex].cont.pause();
              currentIndex = timers[currentIndex].nextPlayer;
              timers[currentIndex].cont.resume();
            });
          },
          child: orientation == Orientation.portrait
              ? Column(
                  children: timers.where((t) => t.alive).map((timer) {
                    // creates iterable of timers that are alive
                    // then passes to map so they can have widgets created
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
                                // here is the countdown timer logic (comes from the timer_count_down library)
                                controller: timer.cont,
                                seconds: (duration * 60).ceil(),
                                build: (context, double time) => Text(
                                    time.toString(),
                                    style: TextStyle(fontSize: 36)),
                                interval: Duration(milliseconds: 100),
                                onFinished: () {
                                  // When a timer finishes the nextPlayer and hasMe are now incorrect
                                  // This updates the nextPlayer and hasMe to be correct
                                  // It also
                                  setState(() {
                                    timers[timer.hasMe].nextPlayer =
                                        timer.nextPlayer;
                                    timers[timer.nextPlayer].hasMe =
                                        timer.hasMe;
                                    //timers[currentIndex].cont.pause();
                                    currentIndex =
                                        timers[currentIndex].nextPlayer;
                                    //timers[currentIndex].cont.resume();
                                    timers[timer.nextPlayer].cont.resume();
                                  });
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
                                    //timers[currentIndex].cont.pause();
                                    currentIndex =
                                        timers[currentIndex].nextPlayer;
                                    //timers[currentIndex].cont.resume();
                                    timers[timer.nextPlayer].cont.resume();
                                  });
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
