import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'data/repositories/customer_repository.dart';
import 'logic/bloc/customer/customer_bloc.dart';
import 'logic/bloc/customer/customer_event.dart';
import 'presentation/pages/customer_list_page.dart';
import 'presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final customerRepository = CustomerRepository();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(
    customerRepository: customerRepository,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatefulWidget {
  final CustomerRepository customerRepository;
  final bool isLoggedIn;

  const MyApp({super.key, required this.customerRepository, required this.isLoggedIn});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  // ✅ Internet Connection Check
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });

    // Show alert if no internet
    if (!_isConnected) {
      _showNoInternetDialog();
    }
  }

  // ✅ Show No Internet Alert
  void _showNoInternetDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("Please check your WiFi or Mobile Data."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerBloc(customerRepository: widget.customerRepository)..add(LoadCustomers()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Customer Management',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: _isConnected
            ? (widget.isLoggedIn ? CustomerListPage() : LoginPage())
            : Scaffold(body: Center(child: Text("No Internet Connection"))),
      ),
    );
  }
}
