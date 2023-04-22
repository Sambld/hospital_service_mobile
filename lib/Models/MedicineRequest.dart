import 'Medicine.dart';

class MedicineRequest {
  final int? id;
  final int? userId;
  final int? recordId;
  final int? medicineId;
  final int? quantity;
  final String? status;
  final String? review;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Medicine? medicine;

  MedicineRequest({
     this.id,
     this.userId,
     this.recordId,
     this.medicineId,
     this.quantity,
     this.status,
     this.review,
      this.medicine,
     this.createdAt,
     this.updatedAt,
  });

  factory MedicineRequest.fromJson(Map<String, dynamic> json) {
    return MedicineRequest(
      id: json['id'],
      userId: json['user_id'],
      recordId: json['record_id'],
      medicineId: json['medicine_id'],
      quantity: json['quantity'],
      status: json['status'],
      review: json['review'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      medicine: json['medicine'] != null ? Medicine.fromJson(json['medicine']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'record_id': recordId,
    'medicine_id': medicineId,
    'quantity': quantity,
    'status': status,
    'review': review,

  };
}
