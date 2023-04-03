class Medicine {
  final int id;
  final String name;
  final String category;
  final String description;
  final double? price;
  final int quantity;
  final bool isPharmaceutical;
  final String? manufacturer;
  final String? supplier;
  final DateTime expirationDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.price,
    required this.quantity,
    required this.isPharmaceutical,
    this.manufacturer,
    this.supplier,
    required this.expirationDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      price: json['price'],
      quantity: json['quantity'],
      isPharmaceutical: json['is_pharmaceutical'],
      manufacturer: json['manufacturer'],
      supplier: json['supplier'],
      expirationDate: DateTime.parse(json['expiration_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'description': description,
    'price': price,
    'quantity': quantity,
    'is_pharmaceutical': isPharmaceutical,
    'manufacturer': manufacturer,
    'supplier': supplier,
    'expiration_date': expirationDate.toIso8601String(),
  };
}
