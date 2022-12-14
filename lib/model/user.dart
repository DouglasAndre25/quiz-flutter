class UserApplication {
  String email;
  String password;

  UserApplication(this.email, this.password);

  factory UserApplication.fromJson(Map<dynamic, dynamic> json) {
    return UserApplication(json['email'] as String, json['password'] as String);
  }
}
