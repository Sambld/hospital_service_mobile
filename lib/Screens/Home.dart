import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:infectious_diseases_service/Controllers/NavigationDrawerController.dart';

import '../Controllers/AuthController.dart';
import '../Widgets/NavigationDrawerWidget.dart';
import 'Dashboard.dart';
import 'LoginPage.dart';
import 'Patients.dart';
import 'SplashScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _controller = Get.find();
  final _navigationDrawerController = Get.put(NavigationDrawerController());

  final screens = [
    DashboardScreen(),
    PatientsScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Rubik'),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Infectious Diseases Service'),
        ) ,
        drawer: NavigationDrawerWidget(),
        body: Obx(() => screens[_navigationDrawerController.selectedIndex.value])
      ),
    );
  }
}
