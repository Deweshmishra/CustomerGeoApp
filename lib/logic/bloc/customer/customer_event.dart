import 'package:equatable/equatable.dart';
import '../../../data/models/customer_model.dart';

abstract class CustomerEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class LoadCustomers extends CustomerEvent {}


class AddCustomer extends CustomerEvent {
  final Customer customer;

  AddCustomer({required this.customer});

  @override
  List<Object> get props => [customer];
}


class DeleteCustomer extends CustomerEvent {
  final int customerId;

  DeleteCustomer({required this.customerId});

  @override
  List<Object> get props => [customerId];
}
