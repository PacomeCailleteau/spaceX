import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:space_x/features/launches/model/launch_model.dart';

class PaginatedLaunches {
  const PaginatedLaunches({required this.launches, required this.hasNextPage});
  final List<Launch> launches;
  final bool hasNextPage;
}

class LaunchService {
  final String _baseUrl = 'https://api.spacexdata.com/v4/launches/query';

  Future<PaginatedLaunches> getLaunches({
    int page = 1,
    int limit = 20,
    String query = '',
  }) async {
    final searchQuery = query.isEmpty
        ? {}
        : {
            'name': {
              '\$regex': query,
              '\$options': 'i', // i for case-insensitive
            }
          };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'query': searchQuery,
        'options': {
          'page': page,
          'limit': limit,
          'sort': {
            'date_utc': 'desc',
          },
          'populate': ['rocket'],
        },
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final launches = (data['docs'] as List)
          .map((json) => Launch.fromJson(json))
          .toList();
      return PaginatedLaunches(
        launches: launches,
        hasNextPage: data['hasNextPage'] as bool,
      );
    } else {
      throw Exception('Failed to load launches: ${response.body}');
    }
  }

  Future<List<Launch>> getLaunchesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'query': {
          '_id': { '\$in': ids }
        },
        'options': {
          'populate': ['rocket'],
        },
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return (data['docs'] as List)
          .map((json) => Launch.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load favorite launches');
    }
  }
}
