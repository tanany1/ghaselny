class RegisterRequest {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;
  final String role;
  final VehicleData vehicle;

  RegisterRequest({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    this.role = "user",
    required this.vehicle,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password,
      "role": role,
      "vehicle": vehicle.toJson(),
    };
  }
}

class VehicleData {
  final String manufacturer;
  final String model;
  final String type; // "car" or "bike"
  final PlateNumber plateNumber;

  VehicleData({
    required this.manufacturer,
    required this.model,
    required this.type,
    required this.plateNumber,
  });

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

  PlateNumber({
    required this.letters,
    required this.numbers,
  });

  Map<String, dynamic> toJson() {
    return {
      "letters": letters,
      "numbers": numbers,
    };
  }
}