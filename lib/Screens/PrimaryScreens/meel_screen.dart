import 'package:flutter/material.dart';

class MeelScreen extends StatefulWidget {
  const MeelScreen({super.key});

  @override
  State<MeelScreen> createState() => _MeelScreenState();
}

class _MeelScreenState extends State<MeelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:Text("Meels Screen")),
    );
  }
}
