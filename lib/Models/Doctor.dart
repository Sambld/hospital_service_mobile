class Doctor {
  int? id ;
  String? firstName ;
  String? lastName ;


  Doctor({
    this.id,
    this.firstName,
    this.lastName,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  String fullName() {
    return '${this.firstName} ${this.lastName}';
  }

}