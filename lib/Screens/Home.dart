import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infectious_diseases_service/Controllers/NavigationDrawerController.dart';

import '../Widgets/NavigationDrawerWidget.dart';
import 'Dashboard.dart';
import 'Patients/Patients.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _navigationDrawerController = Get.put(NavigationDrawerController());

  final screens = [
    const DashboardScreen(),
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
