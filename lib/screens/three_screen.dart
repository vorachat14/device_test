import 'package:flutter/material.dart';

class ThreeScreen extends StatelessWidget {
  const ThreeScreen({
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Three Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'three',
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
