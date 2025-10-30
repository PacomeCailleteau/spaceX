import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:space_x/features/rockets/model/rocket_model.dart';

class RocketService {
  final String _baseUrl = 'https://api.spacexdata.com/v4/rockets';

  Future<Rocket> getRocket(String rocketId) async {
    final response = await http.get(Uri.parse('$_baseUrl/$rocketId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Rocket.fromJson(data);
    } else {
      throw Exception('Failed to load rocket');
    }
  }
}
