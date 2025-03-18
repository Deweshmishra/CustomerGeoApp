import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());


    await Future.delayed(Duration(seconds: 2));


    if (event.email == "user@maxmobility.in" && event.password == "Abc@#123") {
      emit(AuthAuthenticated());
    } else {
      emit(AuthFailure(errorMessage: "Invalid credentials"));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthLoggedOut());
  }
}
