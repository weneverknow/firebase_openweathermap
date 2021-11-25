import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MyLocation {
  //final Geolocator geolocator = Geolocator();
  static Future<Position> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  static Future<String?> getCity() async {
    try {
      final position = await getCurrentLocation();
      List<Placemark> places =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = places[0];
      print("subLocality ${place.subLocality}");
      return place.subLocality;
    } catch (e) {
      print(e);
    }
  }
}
