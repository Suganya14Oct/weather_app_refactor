


import 'package:open_weather_provider_refactor/exceptions/weather_exception.dart';
import 'package:open_weather_provider_refactor/models/custom_error.dart';
import 'package:open_weather_provider_refactor/models/direct_geocoding.dart';
import 'package:open_weather_provider_refactor/models/weather.dart';
import 'package:open_weather_provider_refactor/services/weather_api_services.dart';

class WeatherRepository {

  final WeatherApiServices weatherApiServices;

  WeatherRepository({required this.weatherApiServices});

  Future<Weather> fetchWeather(String city) async {

    try {

      final DirectGeocoding directGeocoding = await weatherApiServices.getDirectGeocoding(city);

      print("directGeocoding: $directGeocoding");

      final Weather tempWeather = await weatherApiServices.getWeather(directGeocoding);
      final Weather weather = tempWeather.copyWith(name: directGeocoding.name, country: directGeocoding.country);

      print("weather: $weather");

      return weather;

    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }

}