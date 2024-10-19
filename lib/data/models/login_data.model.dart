class LoginData {
  LoginData({
    required this.token,
    required this.user,
  });

  final String? token;
  final User? user;

  factory LoginData.fromJson(Map<String, dynamic> json){
    return LoginData(
      token: json["token"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
  };

  @override
  String toString(){
    return "$token, $user, ";
  }
}

class User {
  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.phone,
    required this.firebaseToken,
    required this.isVerified,
    required this.longitude,
    required this.country,
    required this.profileImage,
    required this.rideStatus,
    required this.isActive,
    required this.createdAt,
  });

  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? email;
  final String? phone;
  final dynamic firebaseToken;
  final int? isVerified;
  final dynamic longitude;
  final String? country;
  final String? profileImage;
  final dynamic rideStatus;
  final int? isActive;
  final DateTime? createdAt;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: json["userId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      middleName: json["middleName"],
      email: json["email"],
      phone: json["phone"],
      firebaseToken: json["firebaseToken"],
      isVerified: json["isVerified"],
      longitude: json["longitude"],
      country: json["country"],
      profileImage: json["profileImage"],
      rideStatus: json["rideStatus"],
      isActive: json["isActive"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
    "middleName": middleName,
    "email": email,
    "phone": phone,
    "firebaseToken": firebaseToken,
    "isVerified": isVerified,
    "longitude": longitude,
    "country": country,
    "profileImage": profileImage,
    "rideStatus": rideStatus,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$userId, $firstName, $lastName, $middleName, $email, $phone, $firebaseToken, $isVerified, $longitude, $country, $profileImage, $rideStatus, $isActive, $createdAt, ";
  }
}
