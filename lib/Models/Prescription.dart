

import 'MedicineRequest.dart';

class Prescription {
  final int? id ;
  final String? name;
  final List<MedicineRequest>? medicineRequests;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  Prescription({
    this.id,
    this.name,
    this.medicineRequests,
    this.createdAt,
    this.updatedAt,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      name: json['name'],
      medicineRequests: json['medicine_requests'] != null ? (json['medicine_requests'] as List).map((i) => MedicineRequest.fromJson(i)).toList() : null,
      createdAt:json['created_at'] == null ? null :  DateTime.tryParse(json['created_at']),
      updatedAt: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'medicine_requests': medicineRequests?.map((e) => e.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

}