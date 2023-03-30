import 'package:flutter/material.dart';

import '../Widgets/NavigationDrawerWidget.dart';
import '../Widgets/PatientTile.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
      ),
      drawer: NavigationDrawerWidget(),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return PatientTile();
        },
      ),
    );
  }
}
