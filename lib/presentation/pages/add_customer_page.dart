import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/database/database_helper.dart';

class AddCustomerPage extends StatefulWidget {
  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final dbHelper = DatabaseHelper();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  // ✅ Pick Image
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    String fileExtension = image.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      _showSnackbar("Only JPG, JPEG, or PNG files are allowed!");
      return;
    }

    File imageFile = File(image.path);
    int fileSizeInBytes = await imageFile.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    if (fileSizeInMB > 5) {
      _showSnackbar("Image size should be less than 5MB!");
      return;
    }

    setState(() => _selectedImage = imageFile);
  }

  // ✅ Get Current Location
  Future<void> _determinePosition() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      _showSnackbar("Please select an image!");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar("Location permission is required!");
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _saveCustomer(position);
  }

  // ✅ Save Customer to Database
  void _saveCustomer(Position position) async {
    await dbHelper.insertCustomer({
      'name': nameController.text,
      'mobile': mobileController.text,
      'email': emailController.text,
      'address': addressController.text,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'image_path': _selectedImage!.path,
    });

    Navigator.pop(context, true);
  }

  // ✅ Show Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Customer")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ✅ Profile Image Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                    child: _selectedImage == null ? Icon(Icons.camera_alt, size: 40, color: Colors.white) : null,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // ✅ Form Fields
              _buildTextField(nameController, "Full Name", Icons.person, (value) {
                if (value!.isEmpty) return "Name is required";
                if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) return "Only letters allowed";
                return null;
              }),

              _buildTextField(mobileController, "Mobile No", Icons.phone, (value) {
                if (value!.isEmpty) return "Mobile number is required";
                if (!RegExp(r"^\d{10}$").hasMatch(value)) return "Enter a valid 10-digit number";
                return null;
              }, keyboardType: TextInputType.phone),

              _buildTextField(emailController, "Email", Icons.email, (value) {
                if (value!.isEmpty) return "Email is required";
                if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                  return "Enter a valid email";
                }
                return null;
              }, keyboardType: TextInputType.emailAddress),

              _buildTextField(addressController, "Address", Icons.location_on, null),

              SizedBox(height: 20),

              // ✅ Save Button
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text("Save Customer"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: _determinePosition,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Build Input Fields
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String? Function(String?)? validator, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
