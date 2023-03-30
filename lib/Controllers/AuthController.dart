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
  var user = [].obs;

  @override
  void onInit() {
    redirect();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> redirect() async {
    var token = await GetStorage().read('token');
    if (token == null) {
      print(isLoggedIn);
      Get.off(() => LoginPage());
    } else {
      isLoggedIn = true.obs;
      Get.off(() => DashboardScreen());
    }
  }



}