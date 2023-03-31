import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infectious_diseases_service/Screens/Dashboard.dart';
import 'package:infectious_diseases_service/Screens/Home.dart';
import 'package:infectious_diseases_service/Screens/LoginPage.dart';
import 'package:infectious_diseases_service/main.dart';
import 'package:dio/dio.dart';

import '../Services/Api.dart';

class AuthController extends GetxController {

  var isLoggedIn = true.obs;
  var _user = {}.obs;

  get user => _user;

  set user(value) {
    _user = value;
  }

  @override
  void onInit() {
    // GetStorage().erase();
    redirect();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> redirect() async {

    try {
      var user = await Api.getUser();
      if (user.statusCode == 200) {
        isLoggedIn = true.obs;
        Get.off(() => DashboardScreen());
      } else {
        isLoggedIn = false.obs;
        Get.offNamed('/login');
      }


    } on DioError catch (e) {

    }




  }



}