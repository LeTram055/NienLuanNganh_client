class Customer {
  final int id;
  final String name;
  final String cccd;
  final String email;
  final String address;
  final int accountId;

  Customer({
    required this.id,
    required this.name,
    required this.cccd,
    required this.email,
    required this.address,
    required this.accountId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['customer_id'],
      name: json['customer_name'],
      cccd: json['customer_cccd'],
      email: json['customer_email'],
      address: json['customer_address'],
      accountId: json['account_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_name': name,
      'customer_cccd': cccd,
      'customer_email': email,
      'customer_address': address,
      'account_id': accountId,
    };
  }
}
