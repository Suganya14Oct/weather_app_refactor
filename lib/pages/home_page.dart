
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_provider_refactor/constants/constants.dart';
import 'package:open_weather_provider_refactor/pages/search_page.dart';
import 'package:open_weather_provider_refactor/pages/settings_page.dart';
import 'package:open_weather_provider_refactor/provider/temp_settings/temp_settings_provider.dart';
import 'package:open_weather_provider_refactor/provider/weather/weather_provider.dart';
import 'package:open_weather_provider_refactor/widgets/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? _city;
  late final WeatherProvider _weatherProv;

  @override
  void initState() {
    super.initState();
    _weatherProv = context.read<WeatherProvider>();
    _weatherProv.addListener(_registerListener);
  }

  @override
  void dispose() {
    _weatherProv.removeListener(_registerListener);
    super.dispose();
  }


  void _registerListener (){
    final WeatherState ws = context.read<WeatherProvider>().state;

    if (ws.status == WeatherStatus.error) {
      errorDialog(context, ws.error.errMsg);
    }
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingProvider>().state.tempUnit;

    if (tempUnit == TempUnit.fahrenheit){
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }

    return temperature.toStringAsFixed(2) + '°C';
  }

  Widget _showWeather() {

    final state = context.watch<WeatherProvider>().state;

    if (state.status == WeatherStatus.initial){
      return Center(
        child: Text('Select a city', style: const TextStyle(fontSize: 20.0)),
      );
    }

    if (state.status == WeatherStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == WeatherStatus.error && state.weather.name == '') {
      return Center(
        child: const Text('Select a city', style: TextStyle(fontSize: 20.0)),
      );
    }

    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        Text(
          state.weather.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context),
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(width: 10.0),
            Text('(${state.weather.country})', style: const TextStyle(fontSize: 18.0))
          ],
        ),
        const SizedBox(height: 60.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(showTemperature(state.weather.temp), style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
            const SizedBox(width: 20.0),
            Column(
              children: [
                Text(showTemperature(state.weather.tempMax), style: TextStyle(fontSize: 16.0)),
                const SizedBox(height: 10.0),
                Text(showTemperature(state.weather.tempMin), style: TextStyle(fontSize: 16.0)),
              ],
            )
          ],
        ),
        const SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Spacer(),
            state.weather.icon.isNotEmpty ? showIcon(state.weather.icon) : Center(child: CircularProgressIndicator()),
            Expanded(flex: 3, child: formatText(state.weather.description)),
            const Spacer()
          ],
        )
      ],
    );
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
        placeholder: 'assets/images/loading.gif',
        image: 'http://$kIconHost/img/wn/$icon@4x.png',
      placeholderErrorBuilder: (_, __, ___) => CircularProgressIndicator(),
      width: 96.0, height: 96.0,
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(formattedString, style:  const TextStyle(fontSize: 24.0), textAlign: TextAlign.center,);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
            _city = await Navigator.push(context, MaterialPageRoute(builder: (context){
              return SearchPage();
            }));
            print("city: $_city");
            if (_city != null){
              context.read<WeatherProvider>().fetchWeather(_city!);
            }
          },
          ),
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SettingsPage();
                }));
              },
              icon: const Icon(Icons.settings)
          )
        ],
      ),
      body: _showWeather(),
    );
  }
}
