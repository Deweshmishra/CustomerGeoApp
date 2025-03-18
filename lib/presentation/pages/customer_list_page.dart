import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/database/database_helper.dart';
import 'add_customer_page.dart';
import 'login_page.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    final data = await dbHelper.fetchCustomers();
    if (!mounted) return;
    setState(() {
      _customers = data;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }


  Future<bool> _hasInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }


  bool _isValidCoordinate(double? lat, double? lon) {
    if (lat == null || lon == null) return false;
    return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;
  }


  Future<void> _openGoogleMaps(double? latitude, double? longitude) async {
    if (!_isValidCoordinate(latitude, longitude)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid GPS Coordinates."), backgroundColor: Colors.red),
      );
      return;
    }

    bool hasInternet = await _hasInternet();
    if (!hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No Internet Connection!"), backgroundColor: Colors.red),
      );
      return;
    }

    String url = "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open Google Maps."), backgroundColor: Colors.red),
      );
    }
  }


  Future<void> _confirmDelete(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Customer?"),
        content: Text("Are you sure you want to delete this customer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await dbHelper.deleteCustomer(id);
              _fetchCustomers(); // Refresh List
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Customer deleted successfully"), backgroundColor: Colors.green),
              );
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _customers.isEmpty
          ? Center(child: Text("No customers found", style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: _customers.length,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          var customer = _customers[index];
          double? latitude = customer['latitude']?.toDouble();
          double? longitude = customer['longitude']?.toDouble();

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: customer['image_path'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(customer['image_path']), width: 50, height: 50, fit: BoxFit.cover),
              )
                  : Icon(Icons.person, size: 50, color: Colors.grey),

              title: Text(customer['name'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(customer['mobile'], style: TextStyle(color: Colors.grey[700])),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.map, color: Colors.blue),
                    onPressed: () => _openGoogleMaps(latitude, longitude),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(customer['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomerPage()));
          if (result == true) _fetchCustomers();
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
