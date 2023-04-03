class MonitoringSheet {
  final int id;
  final int recordId;
  final int? filledById;
  final DateTime fillingDate;
  final int? urine;
  final String? bloodPressure;
  final int? weight;
  final int? temperature;
  final String? progressReport;
  final DateTime createdAt;
  final DateTime updatedAt;

  MonitoringSheet({
    required this.id,
    required this.recordId,
    this.filledById,
    required this.fillingDate,
    this.urine,
    this.bloodPressure,
    this.weight,
    this.temperature,
    this.progressReport,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MonitoringSheet.fromJson(Map<String, dynamic> json) {
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'record_id': recordId,
    'filled_by_id': filledById,
    'filling_date': fillingDate.toIso8601String(),
    'urine': urine,
    'blood_pressure': bloodPressure,
    'weight': weight,
    'temperature': temperature,
    'progress_report': progressReport,
  };
}
