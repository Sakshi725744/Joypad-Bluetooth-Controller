import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("image/easycart.png"),
            SizedBox(height: 10,),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
