import 'dart:convert';

import 'package:chairs_state/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/dbcontroller.dart';
import '../../model/chairmodel.dart';
import '../screens/chair form.dart';
import '../screens/chair description.dart';
import '../screens/homescreen.dart';
import 'package:getwidget/getwidget.dart';

class ChairsCard extends StatefulWidget {
  String title;
  String state;
  String description;
  String pic1;
  String pic2;
  int id;
  String date;

  ChairsCard(this.title, this.description, this.id, this.pic1, this.pic2,
      this.state, this.date);

  @override
  State<ChairsCard> createState() => _ChairsCardState();
}

class _ChairsCardState extends State<ChairsCard> {
  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Please Confirm'),
            content: Text('Are you sure to remove the box?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    ChairsDB().deletechair(widget.id);
                    // Remove the box
                    setState(() {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('item deleted')));
                    });

                    // Close the dialog
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('No'))
            ],
          );
        });
  }

  ChairsDB? chairsdb;

  @override
  Widget build(BuildContext context) {
    Image img1 = Image.memory(
      base64Decode(widget.pic1),
      fit: BoxFit.cover,
    );
    Image img2 = Image.memory(
      base64Decode(widget.pic2),
      fit: BoxFit.cover,
    );
    return GestureDetector(
      onTap: () async {
        Navigator.push(context,
            CupertinoPageRoute(builder: (BuildContext context) {
          return DisScreen(
            title: '${widget.title}',
            date: '${widget.date}',
            description: '${widget.description}',
            pic1: '${widget.pic1}',
            pic2: '${widget.pic2}',
            state: '${widget.state}',
            id: widget.id,
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          margin: EdgeInsets.all(0),
          color: whiteapp,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DPadding),
            //set border radius more than 50% of height and width to make circle
          ),
          elevation: 5,
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(image: img2.image, fit: BoxFit.cover),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),

              //add border radius
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.title}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      (widget.state == 'closed')
                          ? Icon(
                              Icons.lock,
                              color: Colors.amber,
                            )
                          : Icon(Icons.lock_open, color: Colors.red)
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
                  child: Text(
                    '${widget.description}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10),
                        child: Text(
                          '${widget.date}',
                          maxLines: 2,
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, CupertinoPageRoute(
                              builder: (BuildContext context) {
                            return ChairForm(
                              titleback: widget.title,
                              desback: widget.description,
                              idback: widget.id,
                              pic1back: widget.pic1,
                              pic2back: widget.pic2,
                              action: 'update',
                            );
                          }));
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _delete(context);
                          });
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
