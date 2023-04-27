import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:infectious_diseases_service/Screens/LoginPage.dart';
import 'package:infectious_diseases_service/Controllers/AuthController.dart';

import '../Utils/ResponsiveFontSizes.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    ResponsiveFontSize.initialize(context);
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
