class ApiResponse {
  final MetaData metaData;
  final Object? data;

  ApiResponse({
    required this.metaData,
    this.data,
  });

  factory ApiResponse.fromJson(dynamic json) => ApiResponse(
        data: json["data"],
        metaData: MetaData.fromJson(json["metaData"]),
      );
}

class MetaData {
  final int statusCode;
  final String message;

  MetaData({
    required this.statusCode,
    required this.message,
  });

  factory MetaData.fromJson(dynamic json) => MetaData(
        statusCode: json["statusCode"],
        message: json["message"],
      );
}
