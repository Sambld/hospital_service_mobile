import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:infectious_diseases_service/Screens/LoginPage.dart';
import 'package:infectious_diseases_service/Controllers/AuthController.dart';

import '../Utils/ResponsiveFontSizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final authController = Get.put(AuthController());



  @override
  void initState()  {
    // TODO: implement initState
    super.initState();

    // Future.delayed(Duration(seconds: 3) , () { redirect();} );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveFontSize.initialize(context);
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  // void redirect() {Get.to(LoginPage());}
}
