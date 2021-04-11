import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tester/models/ForecastData.dart';

import '../models/WeatherData.dart';

class WeatherItem extends StatefulWidget {
  final WeatherData weather;
  final int index;
  final forecastdata;

  WeatherItem({Key key, @required this.weather, this.index, this.forecastdata})
      : super(key: key);

  @override
  _WeatherItemState createState() =>
      _WeatherItemState(index: index, forecastdata: forecastdata);
}

class _WeatherItemState extends State<WeatherItem> {
  int itemisconcentrated = null;
  int index;
  var forecastdata;

  _WeatherItemState({this.index, this.forecastdata});

  void open_list_for_the_day(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            padding: EdgeInsets.all(8.0),
            height: 300,
            child: ListView.builder(
              itemCount: 9,
              itemBuilder: (context, index2) {
                return Container(
                    height: 80,
                    child: Card(
                        elevation: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                padding: EdgeInsets.all(8),
                                child: LottieBuilder.asset(
                                  'assets/${forecastdata.list.elementAt(index * 8 + index2).icon}.json',
                                  height: 70,
                                )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    DateFormat.MMMMd().format(forecastdata.list
                                        .elementAt(index * 8 + index2)
                                        .date),
                                  ),
                                ),
                                Container(
                                    child: Text(
                                  DateFormat.Hm().format(forecastdata.list
                                      .elementAt(index * 8 + index2)
                                      .date),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ))
                              ],
                            ),
                          ],
                        )));
              },
              shrinkWrap: true,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: () {
            setState(() {
              open_list_for_the_day(context);
            });
          },
          splashColor: Colors.blue,
          child: AnimatedContainer(
            color: itemisconcentrated != null ? Colors.blue[900] : Colors.white,
            duration: Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.weather.main,
                      style: itemisconcentrated != null
                          ? TextStyle(color: Colors.white, fontSize: 24.0)
                          : TextStyle(color: Colors.black, fontSize: 24.0)),
                  Row(
                    children: [
                      LottieBuilder.asset(
                        'assets/temperature-weather.json',
                        repeat: false,
                        height: 15,
                      ),
                      Text(
                          '${(widget.weather.temp - 273.15).toStringAsFixed(0)}°C',
                          style: itemisconcentrated != null
                              ? TextStyle(color: Colors.white, fontSize: 16.0)
                              : TextStyle(color: Colors.black, fontSize: 16.0)),
                    ],
                  ),
                  SizedBox(
                    child: LottieBuilder.asset(
                        'assets/${widget.weather.icon}.json'),
                    height: 30,
                  ),
                  Text(new DateFormat.yMMMd().format(widget.weather.date),
                      style: itemisconcentrated != null
                          ? TextStyle(color: Colors.white, fontSize: 16.0)
                          : TextStyle(color: Colors.black, fontSize: 16.0))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
