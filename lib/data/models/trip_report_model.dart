class TripReport {
  TripReport({
    required this.message,
  });

  final String? message;

  factory TripReport.fromJson(Map<String, dynamic> json){
    return TripReport(
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
  };

  @override
  String toString(){
    return "$message, ";
  }
}
