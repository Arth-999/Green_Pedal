import 'package:flutter/material.dart';


const kTextFieldDecoration=InputDecoration(
  hintText: 'Enter your password',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const colorizeColors= [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Color(0xFFFA9A8A)
];



class RoundedButton extends StatelessWidget {
  final Color col;
  final dynamic func;
  final String text;
  RoundedButton(this.col, this.func, this.text);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: col,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: func,
        minWidth: 200.0,
        height: 42.0,
        child: Text(text,
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
    );
  }
}


