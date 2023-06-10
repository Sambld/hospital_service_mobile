import 'package:infectious_diseases_service/Models/MedicalRecord.dart';

import 'Doctor.dart';
import 'Treatment.dart';

class MonitoringSheet {
  final int? id;
  final int? recordId;
  final int? filledById;
  final DateTime? fillingDate;
  final int? urine;
  final String? bloodPressure;
  final int? weight;
  final String? temperature;
  final String? progressReport;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? filledBy;
  final List<Treatment>? treatments;
  final MedicalRecord? medicalRecord;
  final Doctor? doctor;

  MonitoringSheet({
    this.id,
    this.recordId,
    this.filledById,
    this.fillingDate,
    this.urine,
    this.bloodPressure,
    this.weight,
    this.temperature,
    this.progressReport,
    this.filledBy,
    this.createdAt,
    this.updatedAt,
    this.treatments,
    this.medicalRecord,
    this.doctor,
  });

  factory MonitoringSheet.fromJson(Map<String, dynamic> json) {


    return MonitoringSheet(
      id: json['id'],
      recordId: json['record_id'],
      filledById: json['filled_by_id'],
      fillingDate: json['filling_date'] == null ? null : DateTime.parse(json['filling_date']),
      urine: json['urine'],
      bloodPressure: json['blood_pressure'],
      weight: json['weight'],
      temperature: json['temperature'],
      // to double
      progressReport: json['progress_report'],
      filledBy: json['filled_by'],
      // filledBy: "${json['filled_by']['first_name']} ${json['filled_by']['last_name']}",
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
      treatments: json['treatments'] == null ? [] : json['treatments'].map<Treatment>((t) => Treatment.fromJson(t)).toList(),
      medicalRecord: json['medical_record'] == null ? null : MedicalRecord.fromJson(json['medical_record']),
      doctor: json['doctor'] == null ? null : Doctor.fromJson(json['doctor']),
    );
  }

  Map<String, dynamic> toJson() => {
        'record_id': recordId,
        'filled_by_id': filledById,
        'filling_date': fillingDate!.toIso8601String(),
        'urine': urine,
        'blood_pressure': bloodPressure,
        'weight': weight,
        'temperature': temperature,
        'progress_report': progressReport,
        'filled_by': filledBy,
        'treatments': treatments!.map((t) => t.toJson()).toList(),
      };
}
