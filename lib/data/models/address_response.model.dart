class AddressResponse {
  AddressResponse({
    required this.longitude,
    required this.latitude,
    required this.address,
    required this.country,
    required this.distance,
  });

  final String? longitude;
  final String? latitude;
  final String? address;
  final String? country;
  final int? distance;

  factory AddressResponse.fromJson(Map<String, dynamic> json){
    return AddressResponse(
      longitude: json["longitude"],
      latitude: json["latitude"],
      address: json["address"],
      country: json["country"],
      distance: json["distance"],
    );
  }

  Map<String, dynamic> toJson() => {
    "longitude": longitude,
    "latitude": latitude,
    "address": address,
    "country": country,
    "distance": distance,
  };

  @override
  String toString(){
    return "$longitude, $latitude, $address, $country, $distance, ";
  }
}
