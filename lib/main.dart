import 'package:flutter/material.dart';
import 'Components/Welcome_Page.dart';
import 'Components/Login_Screen.dart';
import 'Components/Registration_Screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GreenPedal());
}

class GreenPedal extends StatelessWidget {

  final Future<FirebaseApp> _app=Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _app,
        builder: (context , snapshot) {
          if(snapshot.hasError){
            return Text('something went wrong');
          }
          else if(snapshot.hasData)
          {
            return WelcomePage();
          }
          else
          {
            return CircularProgressIndicator();
          }
        },
      ),
      routes: {
        WelcomePage.id:(context)=> WelcomePage(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
      },
    );
  }
}