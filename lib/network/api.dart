import 'package:flutter/material.dart';
import 'package:weather_app/model/cast.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

const String api_key = "6c8b0c359af00d4e3653da9b71939452";
const String base_url = "https://api.openweathermap.org/data/2.5/weather?";
const String logo_url = "http://openweathermap.org/img/wn/";

class API {
  Future<WeatherResponse?> getOverAll(String city) async {
    var url = base_url + 'q=' + city + '&appid=' + api_key + '&units=metric';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var finalResponse = WeatherResponse.fromRawJson(response.body);
      return finalResponse;
    } else {
      throw Exception('Error');
    }
  }

  getIcon(icon) {
    var iconUrl = logo_url + icon;
    return iconUrl;
  }

  Future<WeatherResponse> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    var latitude;
    var longitude;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    var currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = currentPosition.latitude.toString();
    longitude = currentPosition.longitude.toString();

    var definitePositionUrl = base_url +
        'lat=' +
        latitude +
        '&lon=' +
        longitude +
        '&exclude=current' +
        '&appid=' +
        api_key +
        '&units=metric';
    var definiteResponse = await http.get(Uri.parse(definitePositionUrl));
    if (definiteResponse.statusCode == 200) {
      var finalDefResponse = WeatherResponse.fromRawJson(definiteResponse.body);
      return finalDefResponse;
    } else {
      throw Exception('Error');
    }
  }
}
