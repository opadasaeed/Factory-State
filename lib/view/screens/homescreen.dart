import 'package:chairs_state/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controller/dbcontroller.dart';
import '../../model/chairmodel.dart';
import '../widget/chaircard.dart';
import 'chair form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var chairdb = ChairsDB();
  Chairs? chair;
  late DateTime currentBackPressTime;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ChairsDB().db.then((value) {
      print("value$value");
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteapp,
      appBar: AppBar(
        elevation: 15,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(DPadding),
        )),
        title: Text(
          'Home',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontLarge,
              color: whiteapp),
        ),
        centerTitle: true,
        backgroundColor: darkred,
      ),
      body:
      WillPopScope(child: FutureBuilder(
          future: chairdb.getchairs(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return (snapshot.hasData)
                ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ChairsCard(
                    "${snapshot.data[index].title}",
                    "${snapshot.data[index].description}",
                    snapshot.data[index].id,
                    '${snapshot.data[index].pic1}',
                    '${snapshot.data[index].pic2}',
                    '${snapshot.data[index].state}',
                    '${snapshot.data[index].date}');
              },
            )
                : const CircularProgressIndicator(
              backgroundColor: darkred,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            );
          }), onWillPop: onWillPop),
      floatingActionButton: FloatingActionButton(
          backgroundColor: darkred,
          onPressed: () {

            Navigator.push(context,
                CupertinoPageRoute(builder: (BuildContext context) {
                  // ......... i send empty argument because i used one form for update and add chair state ..........
              return ChairForm(
                titleback: '',
                pic2back: '',
                pic1back: '',
                idback: 0,
                desback: '',
                action: 'add',
              );
            }));
          },
          child: Icon(
            Icons.add,
            color: whiteapp,
          )),
      
    );
  }
  //........using this function to never get out of app with  back by mistake hhhhhhhhhhhhhhhhhhhhhhhhhhh///
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      return Future.value(false);
    }
    return Future.value(true);
  }
}
