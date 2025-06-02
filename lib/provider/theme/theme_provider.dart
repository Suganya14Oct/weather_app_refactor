
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_provider_refactor/constants/constants.dart';
import 'package:open_weather_provider_refactor/provider/weather/weather_provider.dart';


part 'theme_state.dart';


class ThemeProvider {

  final WeatherProvider wp;
  ThemeProvider({required this.wp});


  ThemeState get state{
    if (wp.state.weather.temp > kWarmOrNot) {
      return ThemeState();
    } else {
      return ThemeState(appTheme: AppTheme.dark);
    }
  }
}