import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/NavigationDrawerWidget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Dashboard'.tr),
      ),
      drawer: NavigationDrawerWidget(),
      body: Center(child: Text("greeting".tr),),
    );
  }
}
