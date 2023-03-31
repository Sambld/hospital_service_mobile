import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infectious_diseases_service/PatientCard.dart';
import 'package:infectious_diseases_service/Screens/Dashboard.dart';
import 'package:infectious_diseases_service/Screens/LoginPage.dart';
import 'package:infectious_diseases_service/Screens/SplashScreen.dart';

import 'Controllers/AuthController.dart';
import 'Controllers/NavigationDrawerController.dart';
import 'Screens/Patients.dart';
import 'Services/Api.dart';
import 'Widgets/NavigationDrawerWidget.dart';

void main() async {
  await GetStorage.init();
  Api.initializeInterceptors();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key , } );

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(fontFamily: 'Rubik'),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      getPages: [
        GetPage(name: '/dashboard', page: () => DashboardScreen()),
        GetPage(name: '/patients', page: () => PatientsScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
      ]
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _navigationDrawerController = Get.put(NavigationDrawerController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: SplashScreen(),
    );

  }
}
