import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_self_care_app/components/rounded_button.dart';
import 'package:covid_self_care_app/constants.dart';
import 'package:covid_self_care_app/nearby_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showSpinner = false;
  late String email;
  late String password;
  late String userName;
  late String Name;
  late String Age;
  late String Gender;
  late String Health_Status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/logo.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    userName = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Username'),
                ),
                SizedBox(
                  height: 4.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 4.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 4.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    Name = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Name'),
                ),
                SizedBox(
                  height: 4.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    Age = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Age'),
                ),
                SizedBox(
                  height: 4.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    Gender = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Gender'),
                ),
                SizedBox(
                  height: 4.0,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    Health_Status = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Health Status'),
                ),
                SizedBox(
                  height: 12.0,
                ),
                RoundedButton(
                  title: 'Register',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        _firestore.collection('users').doc(email).set({
                          'username': userName,
                          'name': Name,
                          'age': Age,
                          'gender': Gender,
                          'health_status': Health_Status,
                        });
                        Navigator.pushNamed(context, NearbyInterface.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
