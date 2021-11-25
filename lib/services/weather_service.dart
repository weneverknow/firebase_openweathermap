import 'package:firebase_app/constants/constant.dart';
import 'package:firebase_app/models/weather.dart';
import 'package:firebase_app/services/my_location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  static Future<Weather?> getCurrentWeather() async {
    try {
      final position = await MyLocation.getCurrentLocation();
      print("lat ${position.latitude}");
      final url = apiUrl +
          '?lat=${position.latitude}&lon=${position.longitude}&appid=$api&units=metric';
      print(url);
      final response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("responseBody ${response.body}");
        final data = jsonDecode((response.body));
        print(data['weather'][0]['icon']);
        //print("jsonBody: " + (data['coord']));
        return Weather.fromMap(data);
      }
    } catch (e) {
      throw 'Error $e';
    }
  }
}
