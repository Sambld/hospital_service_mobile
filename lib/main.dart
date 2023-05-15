import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infectious_diseases_service/Screens/ComplementaryExamination/ComplementaryExaminations.dart';
import 'package:infectious_diseases_service/Screens/Dashboard.dart';
import 'package:infectious_diseases_service/Screens/Dashboard/DoctorDashboard.dart';
import 'package:infectious_diseases_service/Screens/Dashboard/NurseDashboard.dart';
import 'package:infectious_diseases_service/Screens/LoginPage.dart';
import 'package:infectious_diseases_service/Screens/MonitoringSheet/MonitoringSheet.dart';
import 'package:infectious_diseases_service/Screens/Observation/Observations.dart';
import 'package:infectious_diseases_service/Screens/Patients/EditPatient.dart';
import 'package:infectious_diseases_service/Screens/Prescriptions/Prescriptions.dart';
import 'package:infectious_diseases_service/Screens/SplashScreen.dart';
import 'Controllers/NavigationDrawerController.dart';
import 'Screens/MedicalRecord/AddMedicalRecord.dart';
import 'Screens/MedicalRecord/EditMedicalRecord.dart';
import 'Screens/MedicalRecord/MedicalRecord.dart';
import 'Screens/MedicalRecord/MedicalRecords.dart';
import 'Screens/MonitoringSheet/AddMonitoringSheetDay.dart';
import 'Screens/MonitoringSheet/UpdateMonitoringSheetTreatments.dart';
import 'Screens/Observation/Observation.dart';
import 'Screens/Patients/AddPatient.dart';
import 'Screens/Patients/Patient.dart';
import 'Screens/Patients/Patients.dart';
import 'Screens/Prescriptions/Prescription.dart';
import 'Services/Api.dart';
import 'languages.dart';

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
      translations: Languages(),
      // locale: Locale('FR'),
      darkTheme: ThemeData.dark(),
      theme: ThemeData(fontFamily: 'Rubik'),
      home: const MyHomePage(),
      getPages: [
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/patients', page: () => const PatientsScreen()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/patient-details', page: () =>  PatientScreen()),
        GetPage(name: '/add-patient', page: () => AddPatientScreen()),
        GetPage(name: '/edit-patient', page: () => EditPatientScreen()),
        GetPage(
            name: '/medical-record-details', page: () => MedicalRecordScreen()),
        GetPage(name: '/medical-records', page: () => const MedicalRecordsScreen()),
        GetPage(
            name: '/add-medical-record', page: () => AddMedicalRecordScreen()),
        GetPage(
            name: '/edit-medical-record',
            page: () => const EditMedicalRecordScreen()),
        GetPage(name: '/monitoring-sheet', page: () => MonitoringSheetScreen()),
        GetPage(
            name: '/add-monitoring-sheet',
            page: () => AddMonitoringSheetDayScreen()),
        GetPage(
            name: '/update-monitoring-sheet-treatments',
            page: () => const UpdateMonitoringSheetTreatments()),
        GetPage(
            name: '/observations',
            page: () => const ObservationsScreen(),
            transition: Transition.fade),
        GetPage(
            name: '/observation',
            page: () => const ObservationScreen(),
            transition: Transition.fade),
        GetPage(
            name: '/complementary-examinations',
            page: () => const ComplementaryExaminationsScreen(),
            transition: Transition.fade),
      GetPage(
            name: '/prescriptions',
            page: () => PrescriptionsScreen(),
            transition: Transition.fade),
       GetPage(
            name: '/prescription',
            page: () => PrescriptionScreen(),
            transition: Transition.fade),
       GetPage(
            name: '/doctor-dashboard',
            page: () =>  DoctorDashboardScreen(),
            transition: Transition.fade),
       GetPage(
            name: '/nurse-dashboard',
            page: () =>  NurseDashboardScreen(),
            transition: Transition.fade),
      ],
    );
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
    return  Scaffold(
      body: SplashScreen(),
    );
  }
}
