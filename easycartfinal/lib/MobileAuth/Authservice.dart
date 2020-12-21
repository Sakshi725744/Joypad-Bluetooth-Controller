import 'package:easycartfinal/MobileAuth/profile.dart';
import 'package:easycartfinal/bluetooth/bluetoothDetails.dart';
import 'package:easycartfinal/SplashScreens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easycartfinal/MobileAuth/phone_otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  //Handles Auth


  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  handleAuth() {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {//whether logged in or not
            return FutureBuilder(
              future: checkIfDocExists(FirebaseAuth.instance.currentUser.phoneNumber),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.done)
                  if (snapshot.data==true) { //where phone number document exists to check profile info
                      return MainPage();
                    } else {
                      return profile();
                    }
                else{
                return splash();}//poor connection
              },
            );
                return MainPage();
              } else {
            return LoginPage();
          }
        });
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }


}