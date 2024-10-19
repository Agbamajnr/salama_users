class RegisterDto {
  RegisterDto({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.phone,
    required this.userType,
    required this.firebaseToken,
  });

  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? email;
  final String? password;
  final String? rePassword;
  final String? phone;
  final String? userType;
  final String? firebaseToken;

  factory RegisterDto.fromJson(Map<String, dynamic> json){
    return RegisterDto(
      firstName: json["firstName"],
      lastName: json["lastName"],
      middleName: json["middleName"],
      email: json["email"],
      password: json["password"],
      rePassword: json["rePassword"],
      phone: json["phone"],
      userType: json["userType"],
      firebaseToken: json["firebaseToken"],
    );
  }

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "middleName": middleName,
    "email": email,
    "password": password,
    "rePassword": rePassword,
    "phone": phone,
    "userType": userType,
    "firebaseToken": firebaseToken,
  };

  @override
  String toString(){
    return "$firstName, $lastName, $middleName, $email, $password, $rePassword, $phone, $userType, $firebaseToken, ";
  }
}
