import 'dart:async';
import 'package:easycartfinal/MobileAuth/Authservice.dart';
import 'package:easycartfinal/easycart_heading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../MobileAuth/profile.dart';
import '../sizeconfig.dart';
import 'DiscoveryPage.dart';
import 'SelectBondedDevicePage.dart';
import '../joypad.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _address = "...";
  String _name = "...";
  bool connected=false;
  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  bool _autoAcceptPairingRequests = false;
  String name = "Unknown";
  String age = "";
  bool gender = true;
  Future<dynamic> getData() async {
    final DocumentReference document = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        name = snapshot['name'];
        age = snapshot['age'];
        if (snapshot['gender'] == "Male")
          gender = true;
        else
          gender = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
    getData();
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double h = SizeConfig.safeBlockVertical*100;
    double w = SizeConfig.safeBlockHorizontal*100 ;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xfff7f7f7),
      drawer: Drawer(
        elevation: 20,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Column(
          // Important: Remove any padding from the ListView.

          children: <Widget>[
            Container(
              height: h * 0.4,
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: h*0.035,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Center(
                        child: Column(children: [
                      Container(
                        height: h * (0.15),
                        child: gender
                            ? Image.asset(
                                "image/male.png",
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "image/female.png",
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(height: h*0.01),
                      Text(
                        name,
                        style: GoogleFonts.galdeano(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: h*0.032,
                        )),
                      ),
                      SizedBox(height: h*0.005),
                      Text(
                        age,
                        style: GoogleFonts.galdeano(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: h*0.032,
                        )),
                      )
                    ])),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xffF20B0B),
                ),
              ),
            ),
            Expanded(
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: h*0.032,
                  ),
                  title: Text(
                    'Edit Profile',
                    style: GoogleFonts.galdeano(
                        textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: h*0.032,
                    )),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => profile()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: h*0.032,
                  ),
                  title: Text(
                    'Device Settings',
                    style: GoogleFonts.galdeano(
                        textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: h*0.032,
                    )),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    FlutterBluetoothSerial.instance.openSettings();
                  },
                ),
              ]),
            ),
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 0.3,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black,
                size: h*0.032,
              ),
              title: Text(
                'Logout',
                style: GoogleFonts.galdeano(
                    textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: h*0.032,
                )),
              ),
              onTap: () {
                AuthService().signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Bluetooth Settings', style: GoogleFonts.galdeano(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: h*0.032,
            ))),
        backgroundColor: Color(0xffF20B0B),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: h * 0.1, horizontal: w * 0.1),
                child: heading()),
            SwitchListTile(
              title: Text('Bluetooth State', style: GoogleFonts.galdeano(
                  textStyle: TextStyle(
                    color: Color(0xff747292),
                    fontSize: h*0.032,
                  ))),
              subtitle: Text(_bluetoothState.toString()),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),

            ListTile(
              title: Text('Local adapter address',style: GoogleFonts.galdeano(
                  textStyle: TextStyle(
                    color: Color(0xff747292),
                    fontSize: h*0.032,
                  ))),
              subtitle: Text(_address),
            ),
            ListTile(
              title: Text('Local adapter name',style: GoogleFonts.galdeano(
                  textStyle: TextStyle(
                    color: Color(0xff747292),
                    fontSize: h*0.032,
                  ))),
              subtitle: Text(_name),
              onLongPress: null,
            ),
            SizedBox(height: h*0.08,),
            Container(
              width: h*(0.38),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  elevation: 7,
                  color:Color(0xffF20B0B) ,
                  child: Text('Find a chair nearby',style: GoogleFonts.galdeano(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: h*0.029,
                      ))),
                  onPressed: () async {
                    if(_bluetoothState.isEnabled){
                    final BluetoothDevice selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DiscoveryPage();
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print('Discovery -> selected ' + selectedDevice.address);
                    } else {
                      print('Discovery -> no device selected');
                    } }
                    else
                      {
                        var snackBar = SnackBar(
                          content: Text("Bluetooth Disabled",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.galdeano(
                                textStyle: TextStyle(
                                    color: Color(0xffF20B0B),
                                    fontSize: h*0.025,
                                    fontWeight: FontWeight.bold)),
                          ),
                          backgroundColor:Colors.white,
                          duration: Duration(milliseconds: 1500),
                        );
                        scaffoldKey.currentState.showSnackBar(snackBar);
                      }
                  }),
            ),
            Container(
              width: h*(0.38),
              child: RaisedButton(
                elevation: 7,
                color:Color(0xffF20B0B) ,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),

                ),
                child: Text('Connect to paired chair',style: GoogleFonts.galdeano(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: h*0.029,
                      fontWeight: FontWeight.bold
                    ))),
                onPressed: () async {
                  if(_bluetoothState.isEnabled){
                  final BluetoothDevice selectedDevice =
                      await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectBondedDevicePage(checkAvailability: false);
                      },
                    ),
                  );

                  if (selectedDevice != null) {
                    print('Connect -> selected ' + selectedDevice.address);
                    _startChat(context, selectedDevice);
                  } else {
                    print('Connect -> no device selected');
                  }}
                  else{
                    var snackBar = SnackBar(
                      content: Text("Bluetooth Disabled",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.galdeano(
                            textStyle: TextStyle(
                                color: Color(0xffF20B0B),
                                fontSize: h*0.025,
                                fontWeight: FontWeight.bold)),
                      ),
                      backgroundColor:Colors.white,
                      duration: Duration(milliseconds: 1500),
                    );
                    scaffoldKey.currentState.showSnackBar(snackBar);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startChat(BuildContext context, BluetoothDevice server) {

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return joypad(server: server);
          },
        ),
      );

  }
}
