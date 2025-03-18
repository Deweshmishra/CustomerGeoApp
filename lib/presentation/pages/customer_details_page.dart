import 'package:flutter/material.dart';

class CustomerDetailsPage extends StatelessWidget {
  final Map<String, dynamic> customer;

  CustomerDetailsPage({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: customer['image'] != null ? NetworkImage(customer['image']) : null,
              child: customer['image'] == null ? Icon(Icons.person, size: 50) : null,
            ),
            SizedBox(height: 16),
            Text("Name: ${customer['name']}", style: TextStyle(fontSize: 18)),
            Text("Mobile: ${customer['mobile']}", style: TextStyle(fontSize: 18)),
            Text("Email: ${customer['email']}", style: TextStyle(fontSize: 18)),
            Text("Address: ${customer['address']}", style: TextStyle(fontSize: 18)),
            Text("Geo Address: ${customer['geo_address']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
