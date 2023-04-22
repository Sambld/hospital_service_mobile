
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Models/Observation.dart';
import '../../Services/Api.dart';
import 'ObservationsController.dart';


class ObservationController extends GetxController{
  var isLoading = false.obs;
  var patientId = 0.obs;
  var medicalRecordId = 0.obs;
  var observationId = 0.obs;
  var OC = Get.find<ObservationsController>();


  var observation = Observation().obs;

  var editNameController = TextEditingController();

  Future<void> uploadCameraImage() async {
    if (await Permission.camera.request().isGranted) {
      XFile? image;
      try {
        isLoading(true);
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          image = pickedFile;
          final formData = FormData.fromMap({
            'image': await MultipartFile.fromFile(pickedFile.path, filename: 'image.jpg'),
          });
          try {
            final res = await  Api.addObservationImage(patientId: patientId.value, medicalRecordId: medicalRecordId.value, observationId: observationId.value, formData: formData);
          } catch (e) {
            isLoading(false);
            print(e);
          }
          isLoading(false);
          fetchImages();
        }
      } catch (e) {
        isLoading(false);
        print(e);
      }
    }
  }

  Future<void> uploadMultipleImages() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (var i = 0; i < pickedFiles.length; i++) {
          final formData = FormData.fromMap({
            'image': await MultipartFile.fromFile(pickedFiles[i].path, filename: 'image_$i.jpg'),
          });
          try {
            final res = await Api.addObservationImage(
                patientId: patientId.value,
                medicalRecordId: medicalRecordId.value,
                observationId: observationId.value,
                formData: formData);
            print(res.data);
          } catch (e) {
            print(e);
          }
        }
        fetchImages();
      } else {
        // Handle case when user doesn't select any image
        print('No images selected');
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  void onInit() {
    patientId(Get.arguments['patientId']);
    medicalRecordId(Get.arguments['medicalRecordId']);
    observationId(Get.arguments['observationId']);
    fetchImages();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void>  fetchImages() async {

    try {
      isLoading(true);

      final res = await Api.getObservationById(patientId: patientId.value, medicalRecordId: medicalRecordId.value, observationId: observationId.value);
      final data = res.data['data'];
        // convert the list of maps to a list of observations with the fromJson constructor
      observation(Observation.fromJson(data));

       isLoading(false);


    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteImage(int i) async{
    try {
      isLoading(true);
      final res = await Api.deleteObservationImage(patientId: patientId.value, medicalRecordId: medicalRecordId.value, observationId: observationId.value, imageId: i);
      print(res.data);
      fetchImages();
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void updateObservationName() async {
    try {
      isLoading(true);
      final res = await Api.updateObservationName(patientId: patientId.value, medicalRecordId: medicalRecordId.value, observationId: observationId.value, formData: {'name': editNameController.text});
      print(res.data);
      fetchImages();
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }


}

