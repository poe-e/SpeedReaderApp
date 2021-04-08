import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
//import 'package:flutter_mobile_vision/flutter_mobile_vision.dart'; //tried using and it just wasnt that great
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
//import 'package:path/path.dart' as p;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
  //final cameras = await availableCameras();
  //final firstCamera = cameras.first;
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepOrange,
          backgroundColor: Colors.black),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpeedReader"),
        backgroundColor: Colors.red[900],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonTheme(
              //isnt changing size and i don't know why
              minWidth: 200.0,
              height: 100.0,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[900])),
                child: Text('Begin Reading'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BeginReadingScreen();
                    }),
                  );
                },
              )),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[900])),
            child: Text('Progress'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Progress();
                }),
              );
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[900])),
            child: Text('Import Custom Text'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ImportCustomText();
                }),
              );
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[900])),
            child: Text('Saved Text'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SavedText();
                }),
              );
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[900])),
            child: Text('Settings'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Settings();
                }),
              );
            },
          ),
        ],
      )),
    );
  }
}

class BeginReadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Begin Reading"),
          backgroundColor: Colors.red[900],
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[900])),
              child: Text('Continue Progress'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ContinueProgress();
                  }),
                );
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[900])),
              child: Text('Saved Text'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SavedText();
                  }),
                );
              },
            ),
          ],
        )));
  }
}

class BeginReadingScreenReal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Begin Reading"),
        backgroundColor: Colors.red[900],
      ),
      body: Center(child: UpdateText()),
    );
  }
}

class SavedText extends StatefulWidget {
  @override
  _SavedText createState() => _SavedText();
}

final List<String> savedTexts = <String>["Page 1"];
final List<String> savedTextParagraphs = <String>[
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
];

class _SavedText extends State {
  TextEditingController nameController = TextEditingController();

  void addItemToList(String itemToAdd, String paragraph) {
    setState(() {
      savedTexts.add(itemToAdd);
      savedTextParagraphs.add(paragraph);
    });
    print(savedTextParagraphs);
  }

  void deleteItemFromList(String value) {
    setState(() {
      savedTexts.remove(value);
      savedTextParagraphs.remove(value);
    });
  }

  String parsedText = '';

  Future<String> openCamera() async {
    print("Camera");
    //File _image;
    final picker = ImagePicker();
    PickedFile image = await picker.getImage(
        source: ImageSource.camera, maxWidth: 670, maxHeight: 970);
    final Io.File imageFile = Io.File(image.path);
    var bytes = Io.File(imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);
    var url = Uri.parse('https://api.ocr.space/parse/image');
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apikey": "dddeb6dd7b88957"};
    var post = await http.post(url = url, body: payload, headers: header);
    var result = jsonDecode(post.body);
    parsedText = result['ParsedResults'][0]['ParsedText'];
    print(parsedText);
    return parsedText;
  }

  Future<String> openGallery() async {
    //instead of using an api call website, tesseractOcr looks good too
    print("Gallery");

    //var gallery = await ImagePicker.getImage( /// old api
    //  source: ImageSource.gallery,
    //);
    PickedFile image = await ImagePicker().getImage(
        source: ImageSource.gallery, maxWidth: 670, maxHeight: 970); //new api
    final Io.File imageFile = Io.File(image.path);
    var bytes = Io.File(imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);
    var url = Uri.parse('https://api.ocr.space/parse/image');
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apikey": "dddeb6dd7b88957"};
    var post = await http.post(url = url, body: payload, headers: header);
    var result = jsonDecode(post.body);
    parsedText = await result['ParsedResults'][0]['ParsedText'];
    //print(parsedText);
    return parsedText.toString();
  }

  Future<void> _showMenu(int pos) async {
    int selected = await showMenu(
      position: RelativeRect.fromLTRB(100, 100.0, 100.0, 100.0),
      context: context,
      items: [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.edit),
              Text("Edit"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.delete),
              Text("Delete"),
            ],
          ),
        ),
      ],
    );
    if (selected == 0) {
      print('handle edit');
    } else {
      deleteItemFromList(savedTexts[pos]);
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Input name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: nameController,
              decoration: InputDecoration(hintText: "Page 1"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text("Okay"),
                onPressed: () async {
                  codeDialog = valueText;
                  Navigator.pop(context);
                  textString = await openGallery();
                  print(textString);
                  addItemToList(codeDialog, textString);
                },
              )
            ],
          );
        });
  }

  String codeDialog;
  String valueText;
  String textString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Text"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: savedTexts.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  margin: EdgeInsets.all(2),
                  child: Center(
                    child: ListTile(
                      title: Text('${savedTexts[index]}'),
                      onTap: () {
                        print(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return UpdateText(
                              textIndex: index,
                            ); //right now they all go home screen so but
                            //they should go to read screen with the proper text located at savedText[index]
                          }),
                        );
                      },
                      onLongPress: () => {_showMenu(index)},
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                          child: Text('Take a picture'),
                          onTap: () async {
                            Navigator.of(context).pop();

                            var textString = await openCamera();
                            print(textString);
                          }),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      GestureDetector(
                        child: Text('Select from gallery'),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await _displayTextInputDialog(context);
                          // var textString = await openGallery();
                          print("Right before");
                          print(textString);
                          print(codeDialog);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class ContinueProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Progress"),
        ),
        body: ListView(children: <Widget>[
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 1'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return HomeScreen();
              }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 2'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 3'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 4'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 5'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 6'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 7'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 8'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 9'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 10'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 11'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 12'),
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Level 13'),
          ),
        ]));
  }
}

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Begin Reading"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Back'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class ImportCustomText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('Pop2!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('Pop2!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class UpdateText extends StatefulWidget {
  final int textIndex;
  UpdateText({Key key, @required this.textIndex}) : super(key: key);
  //if you spam click, it creates multiple instances and overlaps
  UpdateTextState createState() => UpdateTextState(textIndex2: textIndex);
}

bool yesOrNo = false;

class UpdateTextState extends State with SingleTickerProviderStateMixin {
  final int textIndex2;
  UpdateTextState({Key key, @required this.textIndex2});
  String blank = '';
  String textHolder;
  int actualWPM = 150;

//don't use
/*
  changeText() async {
    textHolder = savedTextParagraphs[textIndex2];
    print(textHolder);
    textHolder = textHolder.replaceAll("\n", " ");
    var list = textHolder.split(
      " ",
    );
    for (var item in list) {
      if (yesOrNo == true) break;
      setState(() {
        blank = item;
      });
      // ignore: unnecessary_statements
      (await new Future.delayed(
          const Duration(seconds: 400))); //control the wpm

    }
  }
  */

  changeTextTest(String item) {
    setState(() {
      blank = item;
    });
  }

  AnimationController controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void playPauseChange() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? controller.forward() : controller.reverse();
    });
  }

  bool isChanging = true;
  bool lockInstance = false;
  bool firstClick = false;
  bool rewindSave = false;
  int savedSpot = 0;
  int wpm;
  var list = [];
  var wpmList = <String>[
    '100 WPM',
    '150 WPM',
    '200 WPM',
    '250 WPM',
    '300 WPM',
    '350 WPM',
    '400 WPM',
    '450 WPM',
    '500 WPM',
    '550 WPM',
    '600 WPM',
    '650 WPM',
    '700 WPM',
    '750 WPM',
    '800 WPM'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text("Saved Text"),
          backgroundColor: Colors.red[900],
        ),
        body: Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                color: Colors.red[900],
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$blank',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
              Row(
                  //EmainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      iconSize: 100,
                      icon: Icon(Icons.fast_rewind_outlined),
                      onPressed: () async {
                        rewindSave = true;
                        print(savedSpot);
                        if (savedSpot != 0 && savedSpot - 2 > 0) {
                          print("REWIND");
                          //rewind word functionality
                          savedSpot = savedSpot - 2;
                          await changeTextTest(list[savedSpot]);
                          print(lockInstance);
                          isChanging = true;
                        }
                        rewindSave = false;
                      },
                    ),
                    IconButton(
                      iconSize: 100,
                      icon: Icon(isPlaying
                          ? Icons.pause_outlined
                          : Icons.play_arrow_outlined),
                      onPressed: () async {
                        var textPara = savedTextParagraphs[textIndex2];
                        textPara = textPara.replaceAll("\n", " ");
                        list = textPara.split(
                          " ",
                        );
                        if (firstClick == true) isChanging = false;
                        //this will lock it so it doesn't create another instance and will reset when it's done displaying
                        if (lockInstance == false) {
                          firstClick = true;
                          print("HERE");
                          playPauseChange();
                          print("playpause");
                          for (var i = savedSpot; i < list.length; i++) {
                            print("outside");
                            if (isChanging == true) {
                              print("inside");
                              await changeTextTest(list[i]);
                              // ignore: unnecessary_statements
                              (await new Future.delayed(
                                  Duration(milliseconds: actualWPM)));
                              //sleep(Duration(milliseconds: 200));
                            } else if (isChanging == false) {
                              print("isChanging");
                              print(rewindSave);
                              if (rewindSave == false) savedSpot = i;
                              //savedSpot = i;
                              lockInstance = false;
                              firstClick = false;
                              isChanging = true;
                              rewindSave = false;
                              break; // if you spam click, then it can't hit the break fast enough and won't pause
                            }
                            lockInstance = true;
                          }
                          lockInstance = false;
                          firstClick = false;
                          playPauseChange();
                        }
                      },
                    ),
                    new DropdownButton<String>(
                      hint: new Text("Select a WPM",
                          style: TextStyle(fontSize: 25)),
                      value: wpm == null ? null : wpmList[wpm],
                      items: wpmList.map((String value) {
                        return new DropdownMenuItem(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          wpm = wpmList.indexOf(value);
                          actualWPM = (int.parse(value.split(" ")[0]));
                          double temp = (60 / actualWPM) * 1000;
                          actualWPM = temp.toInt();
                          print(actualWPM);
                        });
                      },
                    )
                  ])

              // IconButton(
              //  iconSize: 50,
              //  icon: AnimatedIcon(
              //   icon: AnimatedIcons.play_pause,
              //    progress: controller,
              //  ),
              // onPressed: () => changeText(),
              // ),
              /*ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red[900])),
                  onPressed: () =>
                      changeText(), //will probably have to pass in wpm specified here
                  child: const Text("READ")),*/
            ])));
  }
}
