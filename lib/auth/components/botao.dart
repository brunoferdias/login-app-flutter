import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const BotaoCustomizado({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 159, 171, 239),
              Color.fromARGB(255, 180, 186, 213),
              Colors.grey.shade200
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          border: Border.all(color: Colors.grey.shade200, width: 4),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 159, 171, 239),
                  Color.fromARGB(255, 180, 186, 213),
                  Colors.grey.shade200
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Container(
              constraints: BoxConstraints(
                minWidth: double.infinity,
                minHeight: 50.0,
              ),
              alignment: Alignment.center,
              child: Text(
                "$text",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
