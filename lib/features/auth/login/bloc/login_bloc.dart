import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ghaselny/features/auth/auth_repository.dart';
import 'package:ghaselny/features/auth/login/data/login_model.dart';
// --- EVENTS ---
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginTabChanged extends LoginEvent {
  final int index;
  const LoginTabChanged(this.index);
  @override
  List<Object> get props => [index];
}

class LoginSubmitted extends LoginEvent {
  final String identifier; // Email or Phone
  final String password;
  final bool isPhone;

  const LoginSubmitted({
    required this.identifier,
    required this.password,
    required this.isPhone,
  });

  @override
  List<Object> get props => [identifier, password, isPhone];
}

class LoginVisibilityToggled extends LoginEvent {}

// --- STATES ---
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final int selectedTab; // 0 = Phone, 1 = Email
  final bool isPasswordVisible;

  const LoginInitial({
    this.selectedTab = 0,
    this.isPasswordVisible = false
  });

  @override
  List<Object> get props => [selectedTab, isPasswordVisible];
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure(this.error);
  @override
  List<Object> get props => [error];
}

// --- BLOC ---
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(const LoginInitial()) {
    on<LoginTabChanged>(_onTabChanged);
    on<LoginVisibilityToggled>(_onVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onTabChanged(LoginTabChanged event, Emitter<LoginState> emit) {
    if (state is LoginInitial) {
      final currentState = state as LoginInitial;
      emit(LoginInitial(
        selectedTab: event.index,
        isPasswordVisible: currentState.isPasswordVisible,
      ));
    } else {
      // Reset if coming from error/success
      emit(LoginInitial(selectedTab: event.index));
    }
  }

  void _onVisibilityToggled(LoginVisibilityToggled event, Emitter<LoginState> emit) {
    if (state is LoginInitial) {
      final currentState = state as LoginInitial;
      emit(LoginInitial(
        selectedTab: currentState.selectedTab,
        isPasswordVisible: !currentState.isPasswordVisible,
      ));
    }
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    // Preserve UI state for fallback
    int currentTab = event.isPhone ? 0 : 1;

    emit(LoginLoading());

    try {
      final request = LoginRequest(
        password: event.password,
        phoneNumber: event.isPhone ? event.identifier : null,
        email: !event.isPhone ? event.identifier : null,
      );

      await authRepository.login(request);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
      // Return to initial state so user can retry
      emit(LoginInitial(selectedTab: currentTab));
    }
  }
}