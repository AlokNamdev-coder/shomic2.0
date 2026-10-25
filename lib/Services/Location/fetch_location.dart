import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Map<String,String>>getLocation()async{
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    throw Exception("Location services are disabled.");
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw Exception("Location permission denied.");
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception("Location permission permanently denied.");
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  List<Placemark> placeMarks =
  await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  Placemark place = placeMarks.first;

  return {
    "country": place.country ?? "",
    "state": place.administrativeArea ?? "",
    "city": place.locality ?? "",
    "pincode": place.postalCode ?? "",
  };

}