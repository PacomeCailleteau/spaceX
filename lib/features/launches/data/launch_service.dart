import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:space_x/features/launches/model/launch_model.dart';

class LaunchService {
  final String _baseUrl = 'https://api.spacexdata.com/v4/launches/query';

  Future<List<Launch>> getLatestLaunches() async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'query': {},
        'options': {
          'sort': {
            'date_utc': 'desc',
          },
          'limit': 100,
          'populate': [
            {
              'path': 'rocket'
            }
          ],
        },
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> docs = data['docs'];
      return docs.map((json) => Launch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load launches');
    }
  }
}
