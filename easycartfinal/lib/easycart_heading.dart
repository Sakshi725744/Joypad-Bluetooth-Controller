import 'package:easycartfinal/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class heading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double h = SizeConfig.safeBlockVertical*100;
    double w = SizeConfig.safeBlockHorizontal*100 ;
    return RichText(
      text: TextSpan(
        /*defining default style is optional */
        children: <TextSpan>[
          TextSpan(
              text: 'E',
              style: GoogleFonts.galdeano(
                  textStyle: TextStyle(
                      color: Color(0xfff20b0b),
                      fontSize: h*0.056,
                      fontWeight: FontWeight.bold))),
          TextSpan(
              text: 'ASYCART',
              style: GoogleFonts.galdeano(
                  textStyle: TextStyle(
                      color: Color(0xff6E707D),
                      fontSize: h*0.056,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
