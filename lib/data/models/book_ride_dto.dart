class BookRideDto {
  BookRideDto({
    required this.driverId,
    required this.riderToLong,
    required this.riderToLat,
    required this.riderFromLong,
    required this.driverLongitude,
    required this.driverLatitude,
    required this.riderFromAddress,
    required this.riderToAddress,
    required this.amount,
  });

  final String? driverId;
  final double? riderToLong;
  final double? riderToLat;
  final double? riderFromLong;
  final double? driverLongitude;
  final double? driverLatitude;
  final String? riderFromAddress;
  final String? riderToAddress;
  final dynamic amount;

  factory BookRideDto.fromJson(Map<String, dynamic> json){
    return BookRideDto(
      driverId: json["driverId"],
      riderToLong: json["riderToLong"],
      riderToLat: json["riderToLat"],
      riderFromLong: json["riderFromLong"],
      driverLongitude: json["driverLongitude"],
      driverLatitude: json["driverLatitude"],
      riderFromAddress: json["riderFromAddress"],
      riderToAddress: json["riderToAddress"],
      amount: json["amount"],
    );
  }

  Map<String, dynamic> toJson() => {
    "driverId": driverId,
    "riderToLong": riderToLong,
    "riderToLat": riderToLat,
    "riderFromLong": riderFromLong,
    "driverLongitude": driverLongitude,
    "driverLatitude": driverLatitude,
    "riderFromAddress": riderFromAddress,
    "riderToAddress": riderToAddress,
    "amount": amount,
  };

  @override
  String toString(){
    return "$driverId, $riderToLong, $riderToLat, $riderFromLong, $driverLongitude, $driverLatitude, $riderFromAddress, $riderToAddress, $amount, ";
  }
}
