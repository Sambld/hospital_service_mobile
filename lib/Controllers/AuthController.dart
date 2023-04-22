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
    setLanguage();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> setLanguage() async {
    String lang = await GetStorage().read('language');
    if (lang == null) {
      await GetStorage().write('language', 'en');
      Get.updateLocale(Locale('en'));
    } else {
      Get.updateLocale(Locale(lang));
    }

  }

  Future<void> redirect() async {

    try {
      var res = await Api.getUser();
      if (res.statusCode == 200) {
        user(res.data);
        isLoggedIn = true.obs;
        Get.offNamed('/medical-records');
      } else {
        isLoggedIn = false.obs;
        Get.offNamed('/login');
      }


    } on DioError catch (e) {

    }




  }

  bool isDoctor() {
    return user.value['role'] == 'doctor';
  }
  bool isNurse() {
    return user.value['role'] == 'nurse';
  }



}