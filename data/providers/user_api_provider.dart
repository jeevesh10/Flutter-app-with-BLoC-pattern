import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../core/constants/api_constants.dart';

class UserApiProvider {
  final Dio _dio = Dio();

  Future<List<UserModel>> fetchUsers(int limit, int skip, [String? search]) async {
    final query = {
      'limit': limit.toString(),
      'skip': skip.toString(),
    };
    if (search != null && search.isNotEmpty) {
      query['q'] = search;
    }
    final response = await _dio.get(ApiConstants.users, queryParameters: query);
    final List users = response.data['users'];
    return users.map((u) => UserModel.fromJson(u)).toList();
  }
}
