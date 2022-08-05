import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'second_screen',
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
