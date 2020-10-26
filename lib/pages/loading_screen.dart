import 'package:flutter/material.dart';
import 'package:todo/constants/colors.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DARKEST,
      appBar: AppBar(
        backgroundColor: RED,
        title: Text('Home'),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
