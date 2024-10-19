class UpdateUserDto {
  UpdateUserDto({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.device,
    required this.firebaseToken,
    required this.longitude,
    required this.latitude,
  });

  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? device;
  final String? firebaseToken;
  final double? longitude;
  final double? latitude;

  factory UpdateUserDto.fromJson(Map<String, dynamic> json){
    return UpdateUserDto(
      firstName: json["firstName"],
      lastName: json["lastName"],
      middleName: json["middleName"],
      device: json["device"],
      firebaseToken: json["firebaseToken"],
      longitude: json["longitude"],
      latitude: json["latitude"],
    );
  }

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "middleName": middleName,
    "device": device,
    "firebaseToken": firebaseToken,
    "longitude": longitude,
    "latitude": latitude,
  };

  @override
  String toString(){
    return "$firstName, $lastName, $middleName, $device, $firebaseToken, $longitude, $latitude, ";
  }
}
