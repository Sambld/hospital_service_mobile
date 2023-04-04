import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infectious_diseases_service/PatientCard.dart';
import 'package:infectious_diseases_service/Screens/Dashboard.dart';
import 'package:infectious_diseases_service/Screens/LoginPage.dart';
import 'package:infectious_diseases_service/Screens/Medical%20record/AddMedicalRecord.dart';
import 'package:infectious_diseases_service/Screens/Medical%20record/EditMedicalRecord.dart';
import 'package:infectious_diseases_service/Screens/Medical%20record/MedicalRecord.dart';
import 'package:infectious_diseases_service/Screens/Patients/EditPatient.dart';
import 'package:infectious_diseases_service/Screens/SplashScreen.dart';

import 'Controllers/AuthController.dart';
import 'Controllers/NavigationDrawerController.dart';
import 'Screens/Patients/AddPatient.dart';
import 'Screens/Patients/Patient.dart';
import 'Screens/Patients/Patients.dart';
import 'Services/Api.dart';
import 'Widgets/NavigationDrawerWidget.dart';

void main() async {
  await GetStorage.init();
  Api.initializeInterceptors();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        theme: ThemeData(fontFamily: 'Rubik'),
        home: const MyHomePage(),
        getPages: [
          GetPage(name: '/dashboard', page: () => const DashboardScreen()),
          GetPage(name: '/patients', page: () => const PatientsScreen()),
          GetPage(name: '/login', page: () => const LoginPage()),
          GetPage(name: '/patient-details', page: () => const PatientScreen()),
          GetPage(name: '/add-patient', page: () => AddPatientScreen()),
          GetPage(name: '/edit-patient', page: () => EditPatientScreen()),
          GetPage(
              name: '/medical-record-details',
              page: () => MedicalRecordScreen()),
          GetPage(
              name: '/add-medical-record',
              page: () => AddMedicalRecordScreen()),
          GetPage(
              name: '/edit-medical-record',
              page: () => const EditMedicalRecordScreen()),
        ]);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _navigationDrawerController = Get.put(NavigationDrawerController());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashScreen(),
    );
  }
}
