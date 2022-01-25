import 'package:flutter/material.dart';
import 'package:green_cycle/constant.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_cycle/Components/Map.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:geolocator/geolocator.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscure = true;
  String email = '';
  bool loading = false;
  String password = '';
  final _auth = FirebaseAuth.instance;

   String getUserId() {
    User? user=_auth.currentUser ;
    String id=user!.uid;
    return id;

  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(serviceEnabled);
    if (serviceEnabled == false) {
      print('hi');
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    print('ola');
    print(permission);
    if (permission == LocationPermission.denied) {
      print('ola1');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('ola2');
        print('hi1');
        await Geolocator.openLocationSettings();
        print('bye');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
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
                  Flexible(
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedTextKit(
                            repeatForever: true,
                            pause: Duration(microseconds: 1),
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'Green  Pedal',
                                textAlign: TextAlign.center,
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
                      ],
                    ),
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
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          suffix: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                              child: Icon(Icons.remove_red_eye))),
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
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        Position pos = await _determinePosition();
                        print('Your position');
                        print(pos);
                        String id=getUserId();
                        print(id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppScreen(28.6507320, 77.3538950,id)),
                        );
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
                    }, 'Log In'),
                  ),
                ],
              ),
      ),
    );
  }
}
