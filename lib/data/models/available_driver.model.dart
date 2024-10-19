class AvailableDriver {
  AvailableDriver({
    required this.longitude,
    required this.latitude,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.userId,
    required this.profileImage,
    required this.phone,
    required this.plateNo,
    required this.distance,
    required this.amount,
  });

  final String? longitude;
  final String? latitude;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? userId;
  final dynamic profileImage;
  final String? phone;
  final String? plateNo;
  final int? distance;
  final int? amount;

  factory AvailableDriver.fromJson(Map<String, dynamic> json){
    return AvailableDriver(
      longitude: json["longitude"],
      latitude: json["latitude"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      address: json["address"],
      userId: json["userId"],
      profileImage: json["profileImage"],
      phone: json["phone"],
      plateNo: json["plateNo"],
      distance: json["distance"],
      amount: json["amount"],
    );
  }

  Map<String, dynamic> toJson() => {
    "longitude": longitude,
    "latitude": latitude,
    "firstName": firstName,
    "lastName": lastName,
    "address": address,
    "userId": userId,
    "profileImage": profileImage,
    "phone": phone,
    "plateNo": plateNo,
    "distance": distance,
    "amount": amount,
  };

  @override
  String toString(){
    return "$longitude, $latitude, $firstName, $lastName, $address, $userId, $profileImage, $phone, $plateNo, $distance, $amount, ";
  }
}
