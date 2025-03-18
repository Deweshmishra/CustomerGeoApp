import '../../core/database/database_helper.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<List<Customer>> getCustomers() async {
    final customerMaps = await dbHelper.fetchCustomers();
    return customerMaps.map((map) => Customer.fromMap(map)).toList();
  }

  Future<void> addCustomer(Customer customer) async {
    await dbHelper.insertCustomer(customer.toMap());
  }

  Future<void> deleteCustomer(int id) async {
    await dbHelper.deleteCustomer(id);
  }
}
