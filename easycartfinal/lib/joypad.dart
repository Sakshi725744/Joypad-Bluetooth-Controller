import 'package:easycartfinal/bluetooth/bluetoothDetails.dart';
import 'package:easycartfinal/easycart_heading.dart';
import 'package:easycartfinal/sizeconfig.dart';
import 'package:easycartfinal/SplashScreens/splash_joypad.dart';
import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class joypad extends StatefulWidget {
  final BluetoothDevice server;

  const joypad({this.server});
  @override
  _joypadState createState() => _joypadState();
}

class _joypadState extends State<joypad> {

  BluetoothConnection connection;

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });

  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;

    }

    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double h = SizeConfig.safeBlockVertical*100;
    double w = SizeConfig.safeBlockHorizontal*100 ;
    JoystickDirectionCallback onDirectionChanged(
        double degrees, double distance) {
      //double x= distance*sin(degrees*(pi/180));
      //double y= distance*cos(degrees*(pi/180));
      int xi= degrees.round();
      int yi= (distance*100).round();
      _sendMessage(xi.toString(),yi.toString());}
    var joypad_ui=Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[ Padding(
              padding: EdgeInsets.only(
                top: h * 0.2, ),
              child: heading()),
            RawMaterialButton(
              onPressed: () {
                if(connection!=null&&connection.isConnected)
                {connection.close();}
                Navigator.of(context).pop();
              },
              elevation: 10.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.power_settings_new_rounded,
                size: w*0.13,
                color: Color(0xffF20B0B),
              ),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: h*0.05),
              child: JoystickView(

                innerCircleColor:Color(0xffF20B0B),
                iconsColor: Color(0xff747292),
                backgroundColor: Colors.white,
                size: h*0.35,
                onDirectionChanged: onDirectionChanged,
              ),
            ),
          ]
      ),
    );

    return (connection!=null&&connection.isConnected)? joypad_ui:splash_joypad();

  }


  void _sendMessage(String i,String j) async {
    if(connection.isConnected){
    try {
      connection.output.add(utf8.encode(i+":"+j+"#"));
      print(i+":"+j+"#");
      await connection.output.allSent;
    } catch (e) {
      // Ignore error, but notify state
     print(e.toString());
    }

  }
  else{
  Navigator.of(context).push(MaterialPageRoute(
  builder: (BuildContext _) => MainPage()
  ));
  }}
}

