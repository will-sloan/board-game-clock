import 'package:flutter/material.dart';

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

class _TimerBodyState extends State<TimerBody> {
  var players = 0;
  var duration = 0;
  final _formKey = GlobalKey<FormState>();
  final playerController = TextEditingController();
  final durationController = TextEditingController();

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
                                      return "Must input a number between 1-12";
                                    } else if (int.tryParse(value) < 1 ||
                                        int.tryParse(value) > 12) {
                                      return "Number must be between 1-12";
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
                                      int.tryParse(value) == null
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
                                        duration =
                                            int.parse(durationController.text);
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
      ),
      body: Column(
          children: List.generate(
              players,
              (index) => Expanded(
                  child: Container(
                      // height:
                      //     MediaQuery.of(context).size.height /
                      //         players,
                      color: colorList[index],
                      child: Text("$index"))))),
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
