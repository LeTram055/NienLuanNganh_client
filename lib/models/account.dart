class Account {
  final int accountId;
  final String username;

  final String accountRole;
  final String accountPassword;
  final String accountActive;

  Account({
    required this.accountId,
    required this.username,
    required this.accountRole,
    required this.accountPassword,
    required this.accountActive,
  });

  // Factory method để khởi tạo từ JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'],
      username: json['account_username'],
      accountRole: json['account_role'],
      accountPassword: json['account_password'] ?? '',
      accountActive: json['account_active'],
    );
  }

  // Phương thức chuyển thành JSON để gửi lên backend
  Map<String, dynamic> toJson() {
    return {
      'account_username': username,
      'account_role': accountRole,
      'account_password': accountPassword,
      'account_active': accountActive,
    };
  }
}
