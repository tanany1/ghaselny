import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ghaselny/features/home/data/vehicle_model.dart';
import 'package:ghaselny/features/home/data/vehicle_repo.dart';

// --- Events ---
abstract class VehicleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadVehicles extends VehicleEvent {}

class AddNewVehicle extends VehicleEvent {
  final Vehicle vehicle;
  AddNewVehicle(this.vehicle);
}

// --- States ---
abstract class VehicleState extends Equatable {
  @override
  List<Object> get props => [];
}

class VehicleInitial extends VehicleState {}
class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  final Vehicle? selectedVehicle;

  VehicleLoaded(this.vehicles, {this.selectedVehicle});

  @override
  List<Object> get props => [vehicles, selectedVehicle ?? ''];
}

class VehicleError extends VehicleState {
  final String message;
  VehicleError(this.message);
}

// --- Bloc ---
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repo;

  VehicleBloc(this.repo) : super(VehicleInitial()) {
    on<LoadVehicles>((event, emit) async {
      emit(VehicleLoading());
      try {
        final vehicles = await repo.getVehicles();
        // Default to selecting the first one if available
        final selected = vehicles.isNotEmpty ? vehicles.first : null;
        emit(VehicleLoaded(vehicles, selectedVehicle: selected));
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<AddNewVehicle>((event, emit) async {
      // We keep showing loading or keep current state, but for simplicity:
      emit(VehicleLoading());
      try {
        await repo.addVehicle(event.vehicle);
        // Refresh list after adding
        add(LoadVehicles());
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });
  }
}