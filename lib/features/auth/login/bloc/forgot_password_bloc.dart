import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ghaselny/features/auth/auth_repository.dart';

// --- EVENTS ---
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object> get props => [];
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  final String identifier;
  final bool isPhone;

  const ForgotPasswordSubmitted({required this.identifier, required this.isPhone});
  @override
  List<Object> get props => [identifier, isPhone];
}

class ResetPasswordSubmitted extends ForgotPasswordEvent {
  final String id;
  final String newPassword;

  const ResetPasswordSubmitted({required this.id, required this.newPassword});
  @override
  List<Object> get props => [id, newPassword];
}

// --- STATES ---
abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordLinkSentSuccess extends ForgotPasswordState {
  final String? id; // ID might be needed for the next step if returned by API
  const ForgotPasswordLinkSentSuccess({this.id});
  @override
  List<Object?> get props => [id];
}

class ResetPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;
  const ForgotPasswordFailure(this.error);
  @override
  List<Object> get props => [error];
}

// --- BLOC ---
class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordBloc({required this.authRepository}) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onForgotSubmitted);
    on<ResetPasswordSubmitted>(_onResetSubmitted);
  }

  Future<void> _onForgotSubmitted(ForgotPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      final id = await authRepository.forgotPassword(event.identifier, event.isPhone);
      emit(ForgotPasswordLinkSentSuccess(id: id));
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
      emit(ForgotPasswordInitial());
    }
  }

  Future<void> _onResetSubmitted(ResetPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      await authRepository.resetPassword(event.id, event.newPassword);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
      emit(ForgotPasswordInitial()); // Reset to allow retry
    }
  }
}