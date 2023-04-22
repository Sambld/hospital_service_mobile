import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../Services/Api.dart';
import '../../Widgets/GlobalWidgets.dart';
import '../../Controllers/MonitoringSheet/MonitoringSheetController.dart';

class UpdateMonitoringSheetBottomSheet extends StatefulWidget {
  const UpdateMonitoringSheetBottomSheet({super.key});

  @override
  _UpdateMonitoringSheetBottomSheetState createState() =>
      _UpdateMonitoringSheetBottomSheetState();
}

class _UpdateMonitoringSheetBottomSheetState
    extends State<UpdateMonitoringSheetBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  final _controller = Get.find<MonitoringSheetController>();


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:  const ClampingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Temperature field
                FormBuilderTextField(
                  name: 'temperature',
                  initialValue: "${_controller.currentMonitoringSheet.value.temperature ?? ''}",
                  decoration: GlobalWidgets.inputDecoration(
                    'Temperature',
                    Icons.thermostat,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  valueTransformer: (value) => double.tryParse(value ?? ''),// enable decimal point
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),

                  ])

                ),
                const SizedBox(height: 10),
                // Blood pressure field
                FormBuilderTextField(
                  name: 'blood_pressure',
                  initialValue: _controller.currentMonitoringSheet.value.bloodPressure ?? '',
                  decoration: GlobalWidgets.inputDecoration('Blood Pressure'.tr, Icons.bloodtype),
                  keyboardType: TextInputType.number,

                ),
                const SizedBox(height: 10),

                // Urine field
                FormBuilderTextField(
                  name:
                      'urine',
                  initialValue: "${_controller.currentMonitoringSheet.value.urine ?? ''}",
                  decoration: GlobalWidgets.inputDecoration('Urine'.tr, Icons.water),
                  keyboardType: TextInputType.number,

                ),
                const SizedBox(height: 10),

                // Weight field
                FormBuilderTextField(
                  name: 'weight',
                  initialValue: "${_controller.currentMonitoringSheet.value.weight ?? ''}",
                  decoration: GlobalWidgets.inputDecoration('Weight'.tr, Icons.line_weight),
                  keyboardType: TextInputType.number,

                ),
                const SizedBox(height: 10),
                // Progress status field
                FormBuilderTextField(
                  name: 'progress_report',
                  initialValue: _controller.currentMonitoringSheet.value.progressReport ?? '',
                  decoration: GlobalWidgets.inputDecoration('Report'.tr, Icons.text_fields),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 10),
                // Save button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveMonitoringSheet,
                  child: _isLoading
                      ? SizedBox(child: const CircularProgressIndicator(strokeWidth: 2,) , height: 18, width: 18,)
                      :  Text('Save'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveMonitoringSheet() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() {
        _isLoading = true;
      });
      final formData = _formKey.currentState!.value;
      final res = await Api.editMonitoringSheetDay(_controller.patientId.value, _controller.medicalRecordId.value, _controller.currentMonitoringSheet.value.id!,
          formData);
      setState(() {
        _isLoading = false;
      });
      if (res.statusCode == 200) {
        _controller.getMonitoringSheets();
        Get.back();
      }
    }
  }
}
