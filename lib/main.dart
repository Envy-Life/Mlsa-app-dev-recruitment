import 'dart:convert';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:tester/aboutme.dart';

import './widgets/Weather.dart';
import './widgets/WeatherItem.dart';
import './models/WeatherData.dart';
import './models/ForecastData.dart';
import 'home.dart';

void main() => runApp(new myapp1());

class myapp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {'/aboutme': (BuildContext ctx) => Aboutme()},
        home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool isLoading = true;
  WeatherData weatherData = null;
  ForecastData forecastData;
  Location _location = new Location();
  String error;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    loadWeather();
  }

  AnimationController controlleranimation;

  void change_page_to_about_me(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return Aboutme();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        image: Image.asset('assets/aircraft.gif'),
        loaderColor: Colors.black,
        seconds: 5,
        navigateAfterSeconds: weatherData == null
            ? SplashScreen(
                image: Image.asset('assets/aircraft.gif'),
                loaderColor: Colors.black,
                seconds: 4,
              )
            : Scaffold(
                drawer: Drawer(
                  child: ListView(
                    children: [
                      DrawerHeader(
                          child: LottieBuilder.asset(
                        'assets/8720-hi-wink.json',
                        repeat: false,
                      )),
                      ListTile(
                          onTap: null,
                          title: Row(
                            children: [
                              LottieBuilder.asset(
                                'assets/male.json',
                                height: 40,
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                              Text(
                                'About me',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                appBar: AppBar(
                  title: Text(
                    weatherData.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                backgroundColor: Colors.blueGrey,
                body: SmartRefresher(
                  controller: refreshController,
                  header: WaterDropMaterialHeader(),
                  enablePullDown: true,
                  enablePullUp: false,
                  onRefresh: loadWeather,
                  child: Center(
                    child: Home(
                        weatherData: weatherData, forecastData: forecastData),
                  ),
                )));
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
      refreshController.refreshCompleted();
    });

    LocationData location;

    try {
      location = await _location.getLocation();

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    if (location != null) {
      final lat = location.latitude;
      final lon = location.longitude;

      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?APPID=901941541d8f617cc684ac4423d87e00&lat=${lat.toString()}&lon=${lon.toString()}'));
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?APPID=901941541d8f617cc684ac4423d87e00&lat=${lat.toString()}&lon=${lon.toString()}'));

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        return setState(() {
          weatherData =
              new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          forecastData =
              new ForecastData.fromJson(jsonDecode(forecastResponse.body));
          isLoading = false;
          refreshController.refreshCompleted();
        });
      }
    }

    setState(() {
      isLoading = false;
      refreshController.refreshCompleted();
    });
  }
}

/* class Home extends StatefulWidget {
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
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
                    padding:
                        EdgeInsets.fromLTRB(1, 0, 5, 5),
                    height: 185,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (index * 8 <
                              widget.forecastData.list.length) {
                            return WeatherItem(
                                weather: widget.forecastData.list
                                    .elementAt(index * 8));
                          }
                        }),
                  ),
                )
              : Container(),
        ]);
  }
}
 */
