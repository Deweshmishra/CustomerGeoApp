class Customer {
  final int? id;
  final String name;
  final String mobile;
  final String email;
  final String address;
  final double latitude;
  final double longitude;

  Customer({
    this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      mobile: map['mobile'],
      email: map['email'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
