import 'dart:convert';

class User {
  User(this.id , this.token, this.email, this.password);
  final String id;
  final String token;
  String email;
  String password;
  String? pathImage;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'_id': id});
    result.addAll({'token': token});
    result.addAll({'email': email});
    result.addAll({'password': password});
  
    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['_id'] ?? '',
      map['token'] ?? '',
      map['email'] ?? '',
      map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  void setPath(String path) => pathImage = path;
}
