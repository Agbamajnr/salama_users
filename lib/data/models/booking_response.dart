class BookingResponse {
  BookingResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final String? status;
  final int? statusCode;
  final String? message;
  final Data? data;

  factory BookingResponse.fromJson(Map<String, dynamic> json){
    return BookingResponse(
      status: json["status"],
      statusCode: json["statusCode"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  String toString(){
    return "$status, $statusCode, $message, $data, ";
  }
}

class Data {
  Data({
    required this.id,
    required this.driverId,
    required this.riderToLong,
    required this.riderToLat,
    required this.riderFromLong,
    required this.driverLongitude,
    required this.driverLatitude,
    required this.riderFromAddress,
    required this.riderToAddress,
    required this.amount,
    required this.riderId,
    required this.tripId,
  });

  final String? id;
  final String? driverId;
  final dynamic? riderToLong;
  final dynamic? riderToLat;
  final dynamic? riderFromLong;
  final dynamic? driverLongitude;
  final dynamic? driverLatitude;
  final String? riderFromAddress;
  final String? riderToAddress;
  final dynamic? amount;
  final String? riderId;
  final String? tripId;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      driverId: json["driverId"],
      riderToLong: json["riderToLong"],
      riderToLat: json["riderToLat"],
      riderFromLong: json["riderFromLong"],
      driverLongitude: json["driverLongitude"],
      driverLatitude: json["driverLatitude"],
      riderFromAddress: json["riderFromAddress"],
      riderToAddress: json["riderToAddress"],
      amount: json["amount"],
      riderId: json["riderId"],
      tripId: json["tripId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "driverId": driverId,
    "riderToLong": riderToLong,
    "riderToLat": riderToLat,
    "riderFromLong": riderFromLong,
    "driverLongitude": driverLongitude,
    "driverLatitude": driverLatitude,
    "riderFromAddress": riderFromAddress,
    "riderToAddress": riderToAddress,
    "amount": amount,
    "riderId": riderId,
    "tripId": tripId,
  };

  @override
  String toString(){
    return "$id, $driverId, $riderToLong, $riderToLat, $riderFromLong, $driverLongitude, $driverLatitude, $riderFromAddress, $riderToAddress, $amount, $riderId, $tripId, ";
  }
}
