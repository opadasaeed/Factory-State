import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chairs_state/view/screens/chair form.dart';
import 'package:chairs_state/view/screens/chair description.dart';
import 'package:chairs_state/view/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // .........to use riverpod state management.........
  runApp( ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chairs State',
      theme: ThemeData(
        textTheme: GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),

        primarySwatch: Colors.blue,
      ),
      //..............start with splash screen.......
      home: AnimatedSplashScreen(
        splash: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset("assets/images/splash.png",fit: BoxFit.cover,
            ),
          ),
        ) ,
        duration: 2000,
        splashIconSize: double.infinity,
        nextScreen: const HomeScreen(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}


