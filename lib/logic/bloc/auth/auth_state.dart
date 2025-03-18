

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}


class AuthInitial extends AuthState {}


class AuthLoading extends AuthState {}


class AuthAuthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AuthLoggedOut extends AuthState {}
