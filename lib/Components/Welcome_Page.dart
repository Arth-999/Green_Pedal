import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cycle/Components/Login_Screen.dart';
import 'package:green_cycle/Components/Registration_Screen.dart';
import 'package:green_cycle/constant.dart';

class WelcomePage extends StatelessWidget {
  static const String id = "welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'title',
                  child: CircleAvatar(
                    child: Image.asset('assets/cycle.png'),
                    radius: 40,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    'Green Pedal',
                    style: GoogleFonts.unicaOne(
                      color: Colors.green.shade900,
                      fontSize: 45.0,
                      //fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'The Bike-Sharing App',
                  style: GoogleFonts.indieFlower(
                    letterSpacing: 1,
                    color: Colors.green.shade600,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
            SizedBox(height: 30),
            Container(
              child: Image.asset('assets/bike.jpg'),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: RoundedButton(Color(0xFFD0D1E6), () {
                Navigator.pushNamed(context, LoginScreen.id);
              }, 'Log In'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: RoundedButton(Color(0xFFD0D1E6), () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              }, 'Register'),
            ),
          ],
        ),
      ),
    );
  }
}
