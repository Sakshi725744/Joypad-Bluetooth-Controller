import 'dart:typed_data';

import 'package:control_pad/models/pad_button_item.dart';
import 'package:easycartfinal/bluetooth/bluetoothDetails.dart';
import 'package:easycartfinal/easycart_heading.dart';
import 'package:easycartfinal/sizeconfig.dart';
import 'package:easycartfinal/SplashScreens/splash_joypad.dart';
import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:control_pad/models/gestures.dart';
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
  bool joypadview = false; //for padbutton or joypad
  showAlertDialog(BuildContext context, String error,String title) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {Navigator.of(context).pop();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title,style: TextStyle(color: Color(0xfff20b0b)),),
      content: Text(error),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
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
    double h = SizeConfig.safeBlockVertical * 100;
    double w = SizeConfig.safeBlockHorizontal * 100;

    var joypad_ui = Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
            padding: EdgeInsets.only(
              top: h * 0.2,
            ),
            child: heading()),
        RawMaterialButton(
          onPressed: () {
            if (connection != null && connection.isConnected) {
              connection.close();
            }
            Navigator.of(context).pop();
          },
          elevation: 10.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.power_settings_new_rounded,
            size: w * 0.13,
            color: Color(0xffF20B0B),
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
        Switch(
          value: joypadview,
          onChanged: (value) {
            setState(() {
              joypadview = value;
            });
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: h * 0.05),
          child: joypadview
              ? JoystickView(
                  innerCircleColor: Color(0xffF20B0B),
                  iconsColor: Color(0xff747292),
                  backgroundColor: Colors.white,
                  size: h * 0.35,
                  onDirectionChanged: onDirectionChanged,
            interval: Duration(milliseconds: 200),
                )
              : PadButtonsView(
                  size: h * 0.35,
                  padButtonPressedCallback: padBUttonPressedCallback,
                  buttons: [
                    PadButtonItem(index: 0, buttonText: 'R',pressedColor: Color(0xffF20B0B)),
                    PadButtonItem(index: 1, buttonText: 'B',pressedColor: Color(0xffF20B0B)),
                    PadButtonItem(index: 2, buttonText: 'L',pressedColor: Color(0xffF20B0B)),
                    PadButtonItem(index: 3, buttonText: 'F',pressedColor: Color(0xffF20B0B)),
                  ],
                ),
        ),
      ]),
    );

    return (connection != null && connection.isConnected)
        ? joypad_ui
        : splash_joypad();
  }
  JoystickDirectionCallback onDirectionChanged(
      double degrees, double distance) {
    int xi = degrees.round();
    int yi = (distance * 100).round();
    _sendMessage(xi, yi);

  }

  PadButtonPressedCallback padBUttonPressedCallback(
      int buttonIndex, Gestures gesture) {
    _PadsendMessage( "${buttonIndex}");
  }
  void _sendMessage(int i, int j) async {
    if (connection.isConnected) {
      Uint8List l;
      if(i>254) l=Uint8List.fromList([j,254,i-254,255]);
      else l=Uint8List.fromList([j,i,0,255]);
      try {
        connection.output.add(l);
        print(l.toString());
        await connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        print(e.toString());
      }
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {

        BluetoothConnection.toAddress(widget.server.address).then((_connection) {//trying to reconnect
          print('Connected to the device');
          connection = _connection;
          setState(() {
            isConnecting = false;
            isDisconnecting = false;
          });
        }).catchError((error) {
          print('Cannot connect, exception occured');
          showAlertDialog(context, error, "Connection Error!");

        });


      });
    }
  }
  void _PadsendMessage(String i) async {
    if (connection.isConnected) {
      try {
        connection.output.add(utf8.encode(i));
        print(i);
        await connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        print(e.toString());
      }
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {

        BluetoothConnection.toAddress(widget.server.address).then((_connection) {//trying to reconnect
          print('Connected to the device');
          connection = _connection;
          setState(() {
            isConnecting = false;
            isDisconnecting = false;
          });
        }).catchError((error) {
          print('Cannot connect, exception occured');
          showAlertDialog(context, error, "Connection Error!");

      });


      });
    }
  }
}
