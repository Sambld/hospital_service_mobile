class MedicalRecord {
  int? id;
  int? patientId;
  int? userId;
  String? medicalSpecialty;
  String? conditionDescription;
  String? stateUponEnter;
  String? standardTreatment;
  String? stateUponExit;
  int? bedNumber;
  DateTime? patientEntryDate;
  DateTime? patientLeavingDate;
  String? doctorName;
  bool? canEdit;

  MedicalRecord({
    this.id,
    this.patientId,
    this.userId,
    this.medicalSpecialty,
    this.conditionDescription,
    this.stateUponEnter,
    this.standardTreatment,
    this.stateUponExit,
    this.bedNumber,
    this.patientEntryDate,
    this.patientLeavingDate,
    this.doctorName,
    this.canEdit,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
        id: json['id'],
        patientId: json['patient_id'],
        userId: json['user_id'],
        medicalSpecialty: json['medical_specialty'],
        conditionDescription: json['condition_description'],
        stateUponEnter: json['state_upon_enter'],
        standardTreatment: json['standard_treatment'],
        stateUponExit: json['state_upon_exit'],
        bedNumber: json['bed_number'],
        patientEntryDate: DateTime.parse(json['patient_entry_date']),
        patientLeavingDate: json['patient_leaving_date'] != null
            ? DateTime.parse(json['patient_leaving_date'])
            : null,
        doctorName:
            "${json['assigned_doctor']['first_name']} ${json['assigned_doctor']['last_name']}",
        canEdit: json['can_update']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = id;
    data['patient_id'] = patientId;
    data['user_id'] = userId;
    data['medical_specialty'] = medicalSpecialty;
    data['condition_description'] = conditionDescription;
    data['state_upon_enter'] = stateUponEnter;
    data['standard_treatment'] = standardTreatment;
    data['state_upon_exit'] = stateUponExit;
    data['bed_number'] = bedNumber;
    data['patient_entry_date'] = patientEntryDate?.toIso8601String();
    data['patient_leaving_date'] = patientLeavingDate?.toIso8601String();
    data['can_update'] = canEdit;
    return data;
  }
}
