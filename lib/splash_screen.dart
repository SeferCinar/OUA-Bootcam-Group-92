import 'package:flutter/material.dart';
import 'package:rutin_app/main.dart';
import 'dart:async';
import 'homepage.dart'; // Ana ekran widget'ınızı import edin

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Splash screen süresini ayarlayın (örneğin, 3 saniye)
    Timer(Duration(seconds: 2), () {
      // Ana ekrana yönlendirin
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(), // Ana ekran widget'ınız
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(217, 217, 217,1), // Görsel dışındaki alanların arka plan rengi
      body: Center(
        child: Container(
          color: Colors.white, // Görselin arka plan rengi
          child: Image.asset('assets/images/splash_image.jpg'),
        ),
      ),
    );
  }
}
