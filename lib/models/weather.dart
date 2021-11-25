import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String main;
  final String description;
  final String icon;
  final double temp;

  const Weather(
      {required this.main,
      required this.description,
      required this.icon,
      required this.temp});

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
        main: map['weather'][0]['main'],
        description: map['weather'][0]['description'],
        icon: map['weather'][0]['icon'],
        temp: map['main']['temp']);
  }

  @override
  List<Object?> get props => [main, description, icon, temp];
}
