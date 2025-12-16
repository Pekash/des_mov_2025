import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://anapioficeandfire.com/api';

  Future<dynamic> getBook(int bookId) async {
    var url = Uri.parse('$baseUrl/books/$bookId');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getPOVCharacters(List<String> povUrls) async {
    List<dynamic> characters = [];
    for (String url in povUrls) {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        characters.add(json.decode(response.body));
      }
    }
    return characters;
  }

  Future<List<dynamic>> getHousesFromCharacters(List<String> povUrls) async {
    Set<String> houseUrls = {};
    Map<String, dynamic> housesData = {};

    for (String url in povUrls) {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var character = json.decode(response.body);
        List<dynamic> allegiances = character['allegiances'] ?? [];
        for (String houseUrl in allegiances) {
          houseUrls.add(houseUrl);
        }
      }
    }

    for (String houseUrl in houseUrls) {
      var response = await http.get(Uri.parse(houseUrl));
      if (response.statusCode == 200) {
        var house = json.decode(response.body);
        housesData[houseUrl] = house;
      }
    }

    return housesData.values.toList();
  }
}