import 'package:flutter/material.dart';
import 'Login_Screen.dart';
import 'package:green_cycle/constant.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "register";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool obscure = true;
  String email = '';
  bool loading = false;
  String password = '';
  final _auth = FirebaseAuth.instance;
  CollectionReference User = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(fullName,email) {
    return User.doc(_auth.currentUser!.uid).set({
      'Name': fullName,
      'Status': false,
      'email':email,
      'id':_auth.currentUser!.uid,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: AnimatedTextKit(
                            repeatForever: true,
                            pause: Duration(microseconds: 1),
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'Green  Pedal',
                                speed: Duration(milliseconds: 500),
                                textStyle: GoogleFonts.unicaOne(
                                  color: Colors.green.shade900,
                                  fontSize: 50.0,
                                  //fontWeight: FontWeight.w500,
                                ),
                                colors: colorizeColors,
                              ),
                            ],
                            isRepeatingAnimation: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: Hero(
                      tag: 'title',
                      child: CircleAvatar(
                        child: Image.asset('assets/cycle.png'),
                        radius: 100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your email')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      textAlign: TextAlign.center,
                      obscureText: obscure,
                      decoration: kTextFieldDecoration.copyWith(
                          suffix: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                              child: Icon(Icons.remove_red_eye))),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    child: RoundedButton(Color(0xFFD0D1E6), () async {
                      setState(() {
                        loading = true;
                      });
                      try {
                        var val=email.split("@");
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        addUser(val[0],email);
                        setState(() {
                          loading=false;
                        });
                        Alert(
                          context: context,
                          title: "Registration Successful",
                          desc: 'Redirect to login page',
                          buttons: [
                            DialogButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      LoginScreen.id,
                                      (Route<dynamic> route) => false);
                                },
                                child: Text('YES')),
                          ],
                        ).show();
                      } catch (e) {
                        setState(() {
                          loading=false;
                        });
                        Alert(
                          context: context,
                          title: "ERROR",
                          desc: e.toString(),
                          buttons: [
                            DialogButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Return Back')),
                          ],
                        ).show();
                        print(e);
                      }
                    }, 'Register'),
                  ),
                ],
              ),
      ),
    );
  }
}
