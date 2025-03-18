import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/customer_repository.dart';
import 'customer_event.dart';
import 'customer_state.dart';


class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc({required this.customerRepository}) : super(CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<AddCustomer>(_onAddCustomer);
    on<DeleteCustomer>(_onDeleteCustomer);
  }

  void _onLoadCustomers(LoadCustomers event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final customers = await customerRepository.getCustomers();
      emit(CustomerLoaded(customers: customers));
    } catch (e) {
      emit(CustomerError(message: "Failed to load customers"));
    }
  }

  void _onAddCustomer(AddCustomer event, Emitter<CustomerState> emit) async {
    try {
      await customerRepository.addCustomer(event.customer);
      final customers = await customerRepository.getCustomers();
      emit(CustomerLoaded(customers: customers));
    } catch (e) {
      emit(CustomerError(message: "Failed to add customer"));
    }
  }

  void _onDeleteCustomer(DeleteCustomer event, Emitter<CustomerState> emit) async {
    try {
      await customerRepository.deleteCustomer(event.customerId);
      final customers = await customerRepository.getCustomers();
      emit(CustomerLoaded(customers: customers));
    } catch (e) {
      emit(CustomerError(message: "Failed to delete customer"));
    }
  }
}
