import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          color: Colors.orange,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Icon(
              Icons.sticky_note_2_outlined,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
