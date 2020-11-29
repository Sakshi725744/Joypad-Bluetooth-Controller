import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
class splash_joypad extends StatefulWidget {
  @override
  _splash_joypadState createState() => _splash_joypadState();
}

class _splash_joypadState extends State<splash_joypad> {
  bool a = false;
  route() {
    setState(() {
      a=true;
    });
  }
  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration,route);
  }

  @override
  void initState() {
    super.initState();
   startTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    var back = Column(children: [
      Text("CANNOT CONNECT",
          style: GoogleFonts.galdeano(
              textStyle: TextStyle(
                  color: Color(0xfff20b0b),
                  fontSize: 22,
                  fontWeight: FontWeight.bold))),
      SizedBox(height: h*(0.2),),
      Container(
        width: w * (0.6),
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 7,
            color: Color(0xffF20B0B),
            child: Text('Back',
                style: GoogleFonts.galdeano(
                    textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ))),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      )
    ]);
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("image/easycart.png"),
            SizedBox(
              height: 15,
            ),
            a?back:CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
