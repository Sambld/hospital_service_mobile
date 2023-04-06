import 'Treatment.dart';

class MonitoringSheet {
  final int? id;
  final int? recordId;
  final int? filledById;
  final DateTime? fillingDate;
  final int? urine;
  final String? bloodPressure;
  final int? weight;
  final int? temperature;
  final String? progressReport;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? filledBy;
  final List<Treatment>? treatments;

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
  });

  factory MonitoringSheet.fromJson(Map<String, dynamic> json) {
    var treatmentList = json['treatments'] as List;
    List<Treatment> treatments =
    treatmentList.map((i) => Treatment.fromJson(i)).toList();

    return MonitoringSheet(
      id: json['id'],
      recordId: json['record_id'],
      filledById: json['filled_by_id'],
      fillingDate: DateTime.parse(json['filling_date']),
      urine: json['urine'],
      bloodPressure: json['blood_pressure'],
      weight: json['weight'],
      temperature: json['temperature'],
      progressReport: json['progress_report'],
      filledBy: json['filled_by'],
      // filledBy: "${json['filled_by']['first_name']} ${json['filled_by']['last_name']}",
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      treatments: treatments,
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
