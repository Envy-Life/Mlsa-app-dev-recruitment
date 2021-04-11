import 'package:flutter/material.dart';

import './models/WeatherData.dart';
import './models/ForecastData.dart';
import './widgets/Weather.dart';
import './widgets/WeatherItem.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
    @required this.weatherData,
    @required this.forecastData,
  }) : super(key: key);

  final WeatherData weatherData;
  final ForecastData forecastData;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.weatherData != null
                  ? Weather(weather: widget.weatherData)
                  : Container(),
            ),
          ],
        ),
      ),
      widget.forecastData != null
          ? SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(1, 0, 5, 5),
                height: 185,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (index * 8 < widget.forecastData.list.length) {
                        return WeatherItem(
                          weather:
                              widget.forecastData.list.elementAt(index * 8),
                          index: index,
                          forecastdata: widget.forecastData,
                        );
                      }
                    }),
              ),
            )
          : Container(),
    ]);
  }
}
