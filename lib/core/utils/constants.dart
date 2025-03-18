import 'package:flutter/material.dart';

class AppConstants {

  static const String databaseName = "customers.db";
  static const String customerTable = "customers";


  static const String validUserId = "user@maxmobility.in";
  static const String validPassword = "Abc@#123";


  static const String defaultProfileImage = "assets/default_user.png";

  static const String nameRequired = "Full Name is required";
  static const String invalidEmail = "Enter a valid email address";
  static const String mobileRequired = "Mobile number is required";
  static const String invalidMobile = "Enter a valid 10-digit mobile number";
  static const String addressRequired = "Address is required";


  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.orange;


  static String googleMapsUrl(double lat, double long) {
    return "https://www.google.com/maps/dir/?api=1&destination=$lat,$long";
  }
}
