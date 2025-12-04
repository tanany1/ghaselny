class LoginRequest {
  final String? email;
  final String? phoneNumber;
  final String password;

  LoginRequest({
    this.email,
    this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "password": password,
    };

    if (email != null && email!.isNotEmpty) {
      data["email"] = email;
    }

    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      data["phoneNumber"] = phoneNumber;
    }

    return data;
  }
}