class Vehicle {
  final String? id;
  final String manufacturer;
  final String model;
  final String type; // 'car' or 'motorcycle'
  final PlateNumber plateNumber;

  Vehicle({
    this.id,
    required this.manufacturer,
    required this.model,
    required this.type,
    required this.plateNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '', // Assuming API returns an ID
      manufacturer: json['manufacturer'] ?? '',
      model: json['model'] ?? '',
      type: json['type'] ?? 'car',
      plateNumber: PlateNumber.fromJson(json['plateNumber']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "manufacturer": manufacturer,
      "model": model,
      "type": type,
      "plateNumber": plateNumber.toJson(),
    };
  }
}

class PlateNumber {
  final String letters;
  final String numbers;

  PlateNumber({required this.letters, required this.numbers});

  factory PlateNumber.fromJson(Map<String, dynamic> json) {
    return PlateNumber(
      letters: json['letters'] ?? '',
      numbers: json['numbers'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "letters": letters,
      "numbers": numbers,
    };
  }
}