class Trip {
  Trip({
    required this.id,
    required this.riderId,
    required this.driverId,
    required this.riderFromAddress,
    required this.riderToAddress,
    required this.riderToLong,
    required this.riderFromLong,
    required this.rideStatus,
    required this.driverLongitude,
    required this.amount,
    required this.driverLatitude,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.driver,
  });

  final String? id;
  final String? riderId;
  final String? driverId;
  final String? riderFromAddress;
  final String? riderToAddress;
  final double? riderToLong;
  final double? riderFromLong;
  final String? rideStatus;
  final double? driverLongitude;
  final int? amount;
  final int? driverLatitude;
  final dynamic startTime;
  final dynamic endTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final Driver? driver;

  factory Trip.fromJson(Map<String, dynamic> json){
    return Trip(
      id: json["id"],
      riderId: json["riderId"],
      driverId: json["driverId"],
      riderFromAddress: json["riderFromAddress"],
      riderToAddress: json["riderToAddress"],
      riderToLong: json["riderToLong"],
      riderFromLong: json["riderFromLong"],
      rideStatus: json["rideStatus"],
      driverLongitude: json["driverLongitude"],
      amount: json["amount"],
      driverLatitude: json["driverLatitude"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "riderId": riderId,
    "driverId": driverId,
    "riderFromAddress": riderFromAddress,
    "riderToAddress": riderToAddress,
    "riderToLong": riderToLong,
    "riderFromLong": riderFromLong,
    "rideStatus": rideStatus,
    "driverLongitude": driverLongitude,
    "amount": amount,
    "driverLatitude": driverLatitude,
    "startTime": startTime,
    "endTime": endTime,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
    "driver": driver?.toJson(),
  };

  @override
  String toString(){
    return "$id, $riderId, $driverId, $riderFromAddress, $riderToAddress, $riderToLong, $riderFromLong, $rideStatus, $driverLongitude, $amount, $driverLatitude, $startTime, $endTime, $createdAt, $updatedAt, $user, $driver, ";
  }
}

class Driver {
  Driver({
    required this.name,
    required this.phone,
    required this.plateNo,
  });

  final String? name;
  final String? phone;
  final String? plateNo;

  factory Driver.fromJson(Map<String, dynamic> json){
    return Driver(
      name: json["name"],
      phone: json["phone"],
      plateNo: json["plateNo"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "plateNo": plateNo,
  };

  @override
  String toString(){
    return "$name, $phone, $plateNo, ";
  }
}

class User {
  User({
    required this.name,
    required this.phone,
    required this.image,
  });

  final String? name;
  final String? phone;
  final String? image;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      name: json["name"],
      phone: json["phone"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "image": image,
  };

  @override
  String toString(){
    return "$name, $phone, $image, ";
  }
}
