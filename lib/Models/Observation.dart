import 'Doctor.dart';
import 'Image.dart';

class Observation {
  final int? id;
  final int? medicalRecordId;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Image>? images;
  final Doctor? doctor;


  Observation({
     this.id,
     this.medicalRecordId,
     this.name,
     this.createdAt,
     this.updatedAt,
    this.images,
    this.doctor,
  });

  factory Observation.fromJson(Map<String, dynamic> json) {
    return Observation(
      id: json['id'],
      medicalRecordId: json['medical_record_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      images: json['images'] != null ? (json['images'] as List).map((i) => Image.fromJson(i)).toList() : null,
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'medical_record_id': medicalRecordId,
    'name': name,
  };
}
