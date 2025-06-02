import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_weather_provider_refactor/pages/home_page.dart';
import 'package:open_weather_provider_refactor/provider/temp_settings/temp_settings_provider.dart';
import 'package:open_weather_provider_refactor/provider/theme/theme_provider.dart';
import 'package:open_weather_provider_refactor/provider/weather/weather_provider.dart';
import 'package:open_weather_provider_refactor/repositories/weather_repository.dart';
import 'package:open_weather_provider_refactor/services/weather_api_services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          Provider<WeatherRepository>(create: (context) =>
              WeatherRepository(weatherApiServices: WeatherApiServices(httpClient: http.Client()))),
          ChangeNotifierProvider<WeatherProvider>(create: (context) => WeatherProvider(
            weatherRepository: context.read<WeatherRepository>(),
          )),
          ChangeNotifierProvider<TempSettingProvider>(create: (context) => TempSettingProvider()),
          ProxyProvider<WeatherProvider, ThemeProvider>(
              update: (
                  BuildContext context,
                  WeatherProvider weatherProvider,
                  _
                  ) =>
             ThemeProvider(wp: weatherProvider))
        ],
        builder: (context, _) =>  MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: context.watch<ThemeProvider>().state.appTheme == AppTheme.light ? ThemeData.light() : ThemeData.dark(),
          home: HomePage(),
        )
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final apiKey = dotenv.env['API_KEY'];
  final baseUrl = dotenv.env['BASE_URL'];
  // print('ApiKey: $apiKey');
  // print('BaseUrl: $baseUrl');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        children: [
          Text('ApiKey: $baseUrl'),
          Text('ApiKey: $apiKey'),
        ],
      )),
    );
  }
}

