import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ghaselny/features/auth/auth_repository.dart';
import 'package:ghaselny/features/auth/register/data/register_model.dart';

// --- EVENTS ---
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class RegisterNextStep extends RegisterEvent {}

class RegisterPreviousStep extends RegisterEvent {}

class RegisterSubmit extends RegisterEvent {
  final String fullName;
  final String email;
  final String phone; // With country code
  final String password;
  final String manufacturer;
  final String model;
  final bool isCar;
  final String plateLetters;
  final String plateNumbers;

  const RegisterSubmit({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.manufacturer,
    required this.model,
    required this.isCar,
    required this.plateLetters,
    required this.plateNumbers,
  });
}

// --- STATES ---
abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  final int step;
  const RegisterInitial({this.step = 0});
  @override
  List<Object> get props => [step];
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;
  const RegisterFailure(this.error);
  @override
  List<Object> get props => [error];
}

// --- BLOC ---
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(const RegisterInitial(step: 0)) {
    on<RegisterNextStep>(_onNextStep);
    on<RegisterPreviousStep>(_onPreviousStep);
    on<RegisterSubmit>(_onSubmit);
  }

  void _onNextStep(RegisterNextStep event, Emitter<RegisterState> emit) {
    if (state is RegisterInitial) {
      final currentStep = (state as RegisterInitial).step;
      // Max step is 2
      if (currentStep < 2) {
        emit(RegisterInitial(step: currentStep + 1));
      }
    }
  }

  void _onPreviousStep(RegisterPreviousStep event, Emitter<RegisterState> emit) {
    if (state is RegisterInitial) {
      final currentStep = (state as RegisterInitial).step;
      if (currentStep > 0) {
        emit(RegisterInitial(step: currentStep - 1));
      }
    }
  }

  Future<void> _onSubmit(RegisterSubmit event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());

    try {
      final requestModel = RegisterRequest(
        fullName: event.fullName,
        phoneNumber: event.phone,
        email: event.email,
        password: event.password,
        role: "user",
        vehicle: VehicleData(
          manufacturer: event.manufacturer,
          model: event.model,
          type: event.isCar ? "car" : "bike",
          plateNumber: PlateNumber(
            letters: event.plateLetters,
            numbers: event.plateNumbers,
          ),
        ),
      );

      await authRepository.registerUser(requestModel);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
      // Return to the last step form after error so user can fix inputs
      emit(const RegisterInitial(step: 2));
    }
  }
}