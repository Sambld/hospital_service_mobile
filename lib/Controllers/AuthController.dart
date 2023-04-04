import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infectious_diseases_service/Screens/Dashboard.dart';
import 'package:infectious_diseases_service/Screens/Home.dart';
import 'package:infectious_diseases_service/Screens/LoginPage.dart';
import 'package:infectious_diseases_service/Screens/Patients/Patients.dart';
import 'package:infectious_diseases_service/main.dart';
import 'package:dio/dio.dart';

import '../Services/Api.dart';

class AuthController extends GetxController {

  var isLoggedIn = true.obs;
  var user = {}.obs;



  @override
  void onInit() {
    // GetStorage().erase();
    redirect();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> redirect() async {

    try {
      var res = await Api.getUser();
      if (res.statusCode == 200) {
        user(res.data);
        print(user);
        isLoggedIn = true.obs;
        Get.off(() => PatientsScreen());
      } else {
        isLoggedIn = false.obs;
        Get.offNamed('/login');
      }


    } on DioError catch (e) {

    }




  }



}