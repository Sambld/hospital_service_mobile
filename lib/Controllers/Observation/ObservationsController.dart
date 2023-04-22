import 'package:get/get.dart';
import 'package:infectious_diseases_service/Models/MedicalRecord.dart';

import '../../Models/Observation.dart';
import '../../Services/Api.dart';

class ObservationsController extends GetxController {
  var isLoading = true.obs;
  var patientId = 0.obs;

  var medicalRecordId = 0.obs;
  var medicalRecord = MedicalRecord().obs;

  var observations = [].obs;

  @override
  void onInit() {
    patientId(Get.arguments['patientId']);
    medicalRecordId(Get.arguments['medicalRecordId']);
    fetchMedicalRecord();
    fetchObservations();
    super.onInit();
  }

  Future<void> fetchMedicalRecord() async {
    try {
      final res = await Api.getMedicalRecord(
          patientId: patientId.value, medicalRecordId: medicalRecordId.value);
      final data = res.data['data'] as Map<String, dynamic>;
      // convert the list of maps to a list of Observations with the fromJson constructor
      medicalRecord(MedicalRecord.fromJson(data));

    } catch (e) {
      print(e);
    } finally {

    }
  }

  void fetchObservations() async {
    try {
      isLoading(true);
      final res = await Api.getObservations(
          patientId: patientId.value, medicalRecordId: medicalRecordId.value);
      final data = res.data['data'] as List<dynamic>;
      // convert the list of maps to a list of Observations with the fromJson constructor
      observations(data.map((item) => Observation.fromJson(item)).toList());

      print(observations[0].images);

    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void addObservation( formData) async{
    try {
      isLoading(true);
      final res = await Api.addObservation(
          patientId: patientId.value, medicalRecordId: medicalRecordId.value, formData: formData);
      final data = res.data['data'] ;
      final observation = Observation.fromJson(data);

      // convert the list of maps to a list of Observations with the fromJson constructor
      fetchObservations();
      Get.toNamed('/observation' , arguments: {'patientId': patientId.value, 'medicalRecordId': medicalRecordId.value, 'observationId': observation.id});

    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
