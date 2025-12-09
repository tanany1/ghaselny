import 'dart:convert';
import 'package:http/http.dart' as http;
import 'vehicle_model.dart';

class VehicleRepository {
  final String baseUrl = "https://ghaslni-api.vercel.app";

  // 1. Get User Vehicles
  Future<List<Vehicle>> getVehicles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicle/me'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Vehicle.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load vehicles");
      }
    } catch (e) {
      throw Exception("Error fetching vehicles: $e");
    }
  }

  // 2. Add New Vehicle
  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vehicle'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(vehicle.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to add vehicle");
      }
    } catch (e) {
      throw Exception("Error adding vehicle: $e");
    }
  }
}