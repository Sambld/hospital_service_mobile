import 'Doctor.dart';

class ComplementaryExamination {
  int id;
  String type;
  int medicalRecordId;
  String result;
  DateTime createdAt;
  DateTime updatedAt;
  Doctor? doctor;

  ComplementaryExamination({
    required this.id,
    required this.type,
    required this.medicalRecordId,
    required this.result,
    required this.createdAt,
    required this.updatedAt,
    this.doctor,
  });

  factory ComplementaryExamination.fromJson(Map<String, dynamic> json) {
    return ComplementaryExamination(
      id: json['id'],
      type: json['type'],
      medicalRecordId: json['medical_record_id'],
      result: json['result'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'medical_record_id': medicalRecordId,
    'result': result,
  };
}
