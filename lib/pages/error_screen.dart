import 'package:flutter/material.dart';
import 'package:todo/constants/colors.dart';

class ErrorScreen extends StatelessWidget {
  final String e;
  final String s;

  ErrorScreen({this.e, this.s});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DARKEST,
      appBar: AppBar(
        backgroundColor: RED,
        title: Text('Error'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text(
                'Error is occuring',
                style: TextStyle(fontSize: 24, color: WHITE),
              ),
              const SizedBox(height: 20),
              Text(
                e,
                style: TextStyle(fontSize: 24, color: WHITE),
              ),
              const SizedBox(height: 20),
              Text(
                s,
                style: TextStyle(fontSize: 24, color: WHITE),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
