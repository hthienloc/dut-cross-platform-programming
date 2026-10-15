class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Lỗi máy chủ không xác định'});

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Lỗi kết nối mạng'});

  @override
  String toString() => 'NetworkException: $message';
}
