import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:merge_images/merge_images.dart';
import '../../constant.dart';
import '../../controller/dbcontroller.dart';
import 'homescreen.dart';

enum ChaircurrentState { open, closed }

class ChairForm extends StatefulWidget {
  String action;
  String titleback;
  String desback;
  String pic1back;
  String pic2back;
  int idback;

  @override
  _ChairFormState createState() => _ChairFormState();

// ......... constructor for get and set data in form screen............
  ChairForm({
    required this.titleback,
    required this.action,
    required this.desback,
    required this.pic1back,
    required this.pic2back,
    required this.idback,
  });
}
//............
class _ChairFormState extends State<ChairForm> {
  ChaircurrentState? _states;
//......... text feild controller to catch changes on update items ........
  final myController = TextEditingController();
  final myController2 = TextEditingController();
//...........
  @override
  void initState() {
    //........view data for chair state in text fields......
    myController.text = widget.titleback;
    myController2.text = widget.desback;
    super.initState();

    // ..Start listening to changes...
    myController.addListener(_printLatestValue);
    myController2.addListener(_printLatestValue);
  }
//.........for handle text ........
  void _printLatestValue() {
    print('Second text field: ${myController.text}');
  }

  void dispose() {
    //......... Clean up the controller when the widget is removed from the widget tree......
    //........ This also removes the _printLatestValue listener..........
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }

  var _image1;
  var _image2;
  var bicunit8;
  var pic1;
  var pic2;
  var title;
  var description;
  var state;
  var date;
  var pass1;
  var pass2;

  @override
  void setdate() {
    // ....to fetch current date and time......
    var time = new TimeOfDay.now();
    var now = new DateTime.now();
    String formatedtime = time.format(context);
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    date = "$formattedDate  \n  $formatedtime";
  }

  Future CamaraImage() async {
    // ........pick image from camera then encoding as string base64 to store it in database......
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 400, imageQuality: 50);

    setState(() async {
      setdate();
      _image2 = await File(image!.path);
      var image5 = await ImagesMergeHelper.loadImageFromFile(_image2);
      pass2 = await ImagesMergeHelper.imageToUint8List(image5);
      pic2 = base64Encode(pass2);
    });
    //..................................end of picker................................................
  }

  Future GalleryImage() async {
    // ........pick image from Gallery then encoding as string base64 to store it in database......
    XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 400, imageQuality: 50);

    setState(() async {
      setdate();

      _image1 =await File(image!.path);
      var image5 = await ImagesMergeHelper.loadImageFromFile(_image1);
      pass1 = await ImagesMergeHelper.imageToUint8List(image5);
      pic1 = base64Encode(pass1);
    });
    //..................................end of picker................................................
  }

  @override
  var chairdb = ChairsDB();

  @override
  Widget build(BuildContext context) {
    //.................. start ui for add and update form ..............
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(DPadding),
        )),
        title: Text(
          'Insert',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontLarge,
              color: whiteapp),
        ),
        centerTitle: true,
        backgroundColor: darkred,
      ),
      backgroundColor: whiteapp,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: myController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(color: darkred),
                  hintText: "Enter Title",
                  contentPadding: EdgeInsets.all(20),
                  helperStyle: TextStyle(
                    color: darkred,
                  ),
                  fillColor: darkred,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: darkred, width: 0.6)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: darkred, width: 0.6)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: darkred, width: 0.6)),
                ),
                onChanged: (value) {
                  setdate();
                  setState(() {
                    title = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: myController2,
                // maxLength: 8,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: "State Description",
                  labelStyle: TextStyle(color: darkred),
                  hintText: "Enter State Description",
                  contentPadding: EdgeInsets.all(10),
                  helperStyle: TextStyle(
                    color: darkred,
                  ),
                  fillColor: darkred,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: darkred, width: 0.6)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: darkred, width: 0.6)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: darkred, width: 0.6)),
                ),
                onChanged: (value) {
                  setState(() {
                    setdate();
                    description = value;
                  });
                },
              ),
              Column(
                children: [
                  // ..........set state of a chair open or closed...........
                  RadioListTile<ChaircurrentState>(
                    title: const Text('closed'),
                    value: ChaircurrentState.closed,
                    groupValue: _states,
                    onChanged: (ChaircurrentState? value) {
                      setState(() {
                        setdate();
                        _states = ChaircurrentState.closed;
                        state = 'closed';
                      });
                    },
                  ),
                  RadioListTile<ChaircurrentState>(
                    title: const Text('opened'),
                    value: ChaircurrentState.open,
                    groupValue: _states,
                    onChanged: (ChaircurrentState? value) {
                      setState(() {
                        setdate();
                        _states = ChaircurrentState.open;
                        state = 'opened';
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                //............view picked image in container before added in date base............
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: _image2 == null
                            ? Center(
                                child: Text(
                                'take a photo with camera ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ))
                            : Image.file(
                                _image2,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        backgroundColor: darkred,
                        onPressed: () {
                          CamaraImage();
                        },
                        child: Icon(Icons.camera),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    //............view picked image in container before added in date base............
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        height: 100,
                        width: 100,
                        child: _image1 == null
                            ? Center(
                                child: Text(
                                'Choose from galary ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ))
                            : Image.file(
                                _image1,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        backgroundColor: darkred,
                        onPressed: () {
                          GalleryImage();
                        },
                        child: Icon(Icons.photo_library),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                //..............trying handle null value when adding new item .......
                onPressed: () {
                  if (widget.action == 'add') {
                    if (description == null || title == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('missing text you must fill it')));
                    } else {
                      if (pic1 == null && pic2 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('please choose at least on image')));
                      } else {if(state==null){ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('please choose a state of chair'))); }else{
                        if (pic1 == null) {
                          pic1 = pic2;
                        } else {
                          if (pic2 == null) {
                            pic2 = pic1;
                          }
                        }
                        chairdb.addchair({
                          "description": "$description",
                          "title": "$title",
                          "date": "$date",
                          "pic1": "$pic1",
                          "pic2": "$pic2",
                          "state": "$state",
                        }).then((value) {
                          print("Successfully$value");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false,
                          );
                        });
                      }
                    }
                    //.............the end of  adding new item ................................
                    //................................................................
                    //............. here starting updating existing item  and handle null values .......
                  } }else {
                    if (description == null && title == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('you dont make change')));
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      if (pic2 == null && pic1 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('updated successfully')));
                        chairdb.deletechair(widget.idback);
                        if (description == null) {
                          description = widget.desback;
                        } else {
                          if (title == null) {
                            title = widget.titleback;
                          }
                        }
                        chairdb.addchair({
                          "description": "$description",
                          "title": "$title",
                          "date": "$date",
                          "pic1": "${widget.pic1back}",
                          "pic2": "${widget.pic2back}",
                          "state": "$state",
                        }).then((value) {
                          print("Successfully$value");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false,
                          );
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('updated successfully')));
                        chairdb.deletechair(widget.idback);
                        if (description == null) {
                          description = widget.desback;
                        } else {
                          if (title == null) {
                            title = widget.titleback;
                          } else {
                            if (pic2 == null) {
                              pic2 = widget.pic2back;
                            } else {
                              if (pic1 == null) {
                                pic1 = widget.pic1back;
                              }
                            }
                          }
                        }
                        chairdb.addchair({
                          "description": "$description",
                          "title": "$title",
                          "date": "$date",
                          "pic1": "$pic1",
                          "pic2": "$pic2",
                          "state": "$state",
                        }).then((value) {
                          print("Successfully$value");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false,
                          );
                        });
                      }
                    }
                  }
                },
                //......................end of update block code .................................
                color: darkred,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Save an item',
                    style: TextStyle(fontSize: 18, color: whiteapp),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
