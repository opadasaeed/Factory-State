import 'dart:convert';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class DisScreen extends StatefulWidget {
  String title;
  String state;
  String description;
  String pic1;
  String pic2;
  int id;
  String date;

  @override
  _DisScreenState createState() => _DisScreenState();

  //.......... a constructor for get data to description screen ..........

  DisScreen({
    required this.title,
    required this.state,
    required this.description,
    required this.pic1,
    required this.pic2,
    required this.id,
    required this.date,
  });
}

class _DisScreenState extends State<DisScreen> {
  @override
  Widget build(BuildContext context) {
    //.................fetch image as a string from database and decode it into image ..............
    Image img1 = Image.memory(
      base64Decode(widget.pic1),
      fit: BoxFit.cover,
    );
    Image img2 = Image.memory(
      base64Decode(widget.pic2),
      fit: BoxFit.cover,
    );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Transform(
            transform: Matrix4.rotationY(math.pi),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: img2.image, fit: BoxFit.cover),
              ),

              //add border radius
            ),
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.red.withOpacity(0.2),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 24,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 25,
                        ),
                        label: Text(
                          "Back",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  FlipCard(
                      fill: Fill.fillBack,
                      front: Container(
                        height: MediaQuery.of(context).size.height / 1.6,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: img2.image, fit: BoxFit.cover),
                        ),
                      ),
                      back: Container(
                        height: MediaQuery.of(context).size.height / 1.6,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: img1.image, fit: BoxFit.cover),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 70,
                              child: Text(
                                "${widget.title}",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                            ),
                            Text(
                              "${widget.state}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Expanded(flex: 15, child: Icon(Icons.lock)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.description}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.date}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
