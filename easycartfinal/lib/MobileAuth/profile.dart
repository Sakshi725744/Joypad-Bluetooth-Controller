import 'package:easycartfinal/bluetooth/bluetoothDetails.dart';
import 'package:easycartfinal/easycart_heading.dart';
import 'package:easycartfinal/sizeconfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  final formKey = new GlobalKey<FormState>();
  bool hasError = false;
  bool male = true;
  bool codeSent = true;
  var dbref = FirebaseFirestore.instance.collection("users");
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double h = SizeConfig.safeBlockVertical*100;
    double w = SizeConfig.safeBlockHorizontal*100 ;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f7f7),
      body: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.1, vertical: h * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: h * (0.015),
                      width: w * (0.2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20.0),
                            right: Radius.circular(20.0)),
                        color: Color(0xffE1E1E1),
                      ),
                    ),
                    Container(
                      height: h * (0.015),
                      width: w * (0.20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20.0),
                            right: Radius.circular(20.0)),
                        color: Color(0xffE1E1E1),
                      ),
                    ),
                    Container(
                      height: h * (0.015),
                      width: w * (0.2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20.0),
                            right: Radius.circular(20.0)),
                        color: Color(0xffF20B0B),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: h * 0.07, left: w * (0.07), right: w * (0.07)),
                child: Center(child: heading()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * (0.07)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text("Name",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.galdeano(
                                  textStyle: TextStyle(
                                color: Color(0xff747292),
                                fontSize: h*0.029,
                              ))),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22.0)),
                            ),
                            child: SizedBox(
                              width: w * 0.5,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                controller: name,
                                keyboardType: TextInputType.name,
                                cursorColor: Color(0xffF20B0B),
                                maxLength: 30,
                                maxLengthEnforced: true,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                ),

                                style: GoogleFonts.galdeano(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: h*0.032,
                                        fontWeight: FontWeight.normal)),
                                //decoration: InputDecoration(hintText: 'Enter phone number'),

                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text("Age",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.galdeano(
                                  textStyle: TextStyle(
                                color: Color(0xff747292),
                                fontSize: h*0.029,
                              ))),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22.0)),
                            ),
                            child: SizedBox(
                              width: w * (0.2),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Age';
                                  } else if (!value
                                      .contains(RegExp(r'^[0-9]*$'))) {
                                    return "age in 0-99";
                                  }
                                  return null;
                                },
                                controller: age,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                textAlign: TextAlign.center,
                                maxLengthEnforced: true,
                                cursorColor: Color(0xffF20B0B),
                                decoration: new InputDecoration(
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                       vertical: 10),
                                ),

                                style: GoogleFonts.varelaRound(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: h*0.032,
                                        fontWeight: FontWeight.normal)),
                                //decoration: InputDecoration(hintText: 'Enter phone number'),

                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: h * (0.05), right: w * 0.07, left: w * 0.07),
                child: Text("Choose a gender",
                    style: GoogleFonts.galdeano(
                        textStyle: TextStyle(
                      color: Color(0xff747292),
                      fontSize: h*0.029,
                    ))),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, right: w * 0.08, left: w * 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          male = true;
                        });
                      },
                      child: Container(
                        height: h * 0.17,
                        decoration: male
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(w * (0.3)),
                                border: Border.all(
                                  color: Color(0xffF20B0B),
                                  width: 5,
                                ),
                              )
                            : BoxDecoration(),
                        child: Image.asset('image/male.png'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          male = false;
                        });
                      },
                      child: Container(
                        height: h * 0.17,
                        decoration: male
                            ? BoxDecoration()
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(w * (0.3)),
                                border: Border.all(
                                  color: Color(0xffF20B0B),
                                  width: 5,
                                ),
                              ),
                        child: Image.asset('image/female.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    top: h * 0.08,
                  ),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(w * 0.15),
                          side: BorderSide(color: Colors.black, width: 1)),
                      child: Container(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.15, vertical: h * 0.015),
                              child: Text(
                                'NEXT',
                                style: GoogleFonts.galdeano(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: h*0.04,
                                )),
                              ))),
                      color: Color(0xffF20B0B),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          dbref
                              .doc(
                                  FirebaseAuth.instance.currentUser.phoneNumber)
                              .set({
                            'name': name.text,
                            'age': age.text,
                            'gender': male ? "Male" : "Female",
                          });
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MainPage()));
                        }
                      })),
            ],
          )),
    );
  }
}
