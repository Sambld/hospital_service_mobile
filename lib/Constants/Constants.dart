import 'package:flutter/material.dart';


const apiUrl = 'http://10.0.2.2:8000';
// const apiUrl = 'http://192.168.1.9:8001';

final kAppBarColor = Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.green,
        Colors.blue,
      ],
      stops: [0.3, 1.0],
    ),
  ),
);
