import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../models/WeatherData.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(weather.main,
            style: new TextStyle(color: Colors.white, fontSize: 32.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/temperature-weather.json',
              repeat: false,
              height: 40,
            ),
            Text('${(weather.temp - 273.15).toStringAsFixed(0)}°C',
                style: new TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(
          child: LottieBuilder.asset('assets/${weather.icon}.json'),
          height: 200,
        ),
        Text(new DateFormat.yMMMd().format(weather.date),
            style: new TextStyle(color: Colors.white)),
      ],
    );
  }
}
