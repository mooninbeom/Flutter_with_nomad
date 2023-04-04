import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget{

  final String text;
  final Color bgColor;
  final Color textColor;

  const Button({
  super.key, required this.text, required this.bgColor, required this.textColor,
});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius:  BorderRadius.circular(45),
      ),
      child: Padding(
        child: Text(text,
          style: TextStyle(fontSize: 20,color: textColor),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 20, horizontal: 50,
        ),
      ),
    );
  }
}
