import 'package:equatable/equatable.dart';

import '../../../data/models/customer_model.dart';


abstract class CustomerState extends Equatable {
  @override
  List<Object> get props => [];
}


class CustomerInitial extends CustomerState {}


class CustomerLoading extends CustomerState {}


class CustomerLoaded extends CustomerState {
  final List<Customer> customers;

  CustomerLoaded({required this.customers});

  @override
  List<Object> get props => [customers];
}

class CustomerError extends CustomerState {
  final String message;

  CustomerError({required this.message});

  @override
  List<Object> get props => [message];
}
