import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Network {
  // Future<List<Map<String, dynamic>>>
  Future<List<dynamic>> getData() async {
    var response = await http.get(Uri.parse(
        'https://g.tenor.com/v1/search?q=programming&key=LIVDSRZULELA&limit=20'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return data['results'];
    }
    return Future.error('error');
  }
  
}
