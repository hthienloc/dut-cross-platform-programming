import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  /// Gọi REST API https://jsonplaceholder.typicode.com/posts
  /// Ném ra [ServerException] nếu mã phản hồi khác 200.
  Future<List<PostModel>> getPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImpl({required this.client});

  static const String endpoint = 'https://jsonplaceholder.typicode.com/posts';

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await client.get(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
      return jsonList
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(
        message: 'Lỗi tải dữ liệu từ máy chủ (HTTP ${response.statusCode})',
      );
    }
  }
}
