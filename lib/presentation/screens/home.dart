import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weather_app/presentation/screens/details.dart';

import 'package:weather_app/presentation/theme/app_colors.dart';
import 'package:weather_app/presentation/widgets/additional_weather_info.dart';
import 'package:weather_app/presentation/widgets/profile.dart';
import 'package:weather_app/presentation/widgets/temperature.dart';
import 'package:weather_app/presentation/widgets/weather_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();
  final Constants _constants = Constants();

  // API from weatherapi.com
  static String API_KEY = "7d40ce19638544f2a6e70722241301";

  String location = "London"; // дефолтная локация
  String weatherIcon = "sunny.png";
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = "";

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = "";

// API Call
  String searchWeatherAPI =
      "https://api.weatherapi.com/v1/forecast.json?key=" + API_KEY + "&days=7&q=";


// Функция для получения данных о погоде
  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));
      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? "No data");

      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData["name"]);
        var parsedDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat("MMMMEEEEd").format(parsedDate);
        currentDate = newDate;

        // update Weather
        currentWeatherStatus = currentWeather["condition"]["text"];
        weatherIcon =
            currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
        temperature = currentWeather['temp_c'].toInt();
        windSpeed = currentWeather['wind_kph'].toInt();
        humidity = currentWeather['humidity'].toInt();
        cloud = currentWeather['cloud'].toInt();

        // Forecast data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
      });
    } catch (e) {
      // debugPrint(e);
    }
  }

// Функция для возвращения двух первых слов локации

  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }


  @override
  void initState() {
    super.initState();
    fetchWeatherData(location); // Получаем данные о погоду в определенной локации
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size; // Для получения размера экрана устройства
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        color: _constants.primaryColor.withOpacity(.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: size.height * .7,
              decoration: BoxDecoration(
                gradient: _constants.linearGradientBlue,
                boxShadow: [
                  BoxShadow(
                    color: _constants.primaryColor.withOpacity(.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Меню
                    Image.asset(
                      'assets/images/pngs/menu.png',
                      height: 40,
                      width: 40,
                    ),

                    // Выбранная локация с модальным окном
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/pngs/pin.png',
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ), 

                        // функционал чтобы при нажатии кнопки открывалось модальное окно
                        IconButton(
                          onPressed: () {
                            _cityController.clear();
                            showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                controller: ModalScrollController.of(context),
                                child: Container(
                                  height: size.height * .2,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        child: Divider(
                                          thickness: 3.5,
                                          color: _constants.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                          onChanged: (searchText) {
                                            fetchWeatherData(searchText);
                                          },
                                          controller: _cityController,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: _constants.primaryColor,
                                              ),
                                              suffix: GestureDetector(
                                                onTap: () =>
                                                    _cityController.clear(),
                                                child: Icon(
                                                  Icons.close,
                                                  color:
                                                      _constants.primaryColor,
                                                ),
                                              ),
                                              hintText:
                                                  "Search city e.g London",
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color:
                                                      _constants.primaryColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              ),
                                              ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },

                          // иконка кнопки для выбора страны
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),

                    // Иконка профиля.
                    const Profile(),
                  ],
                ),

                // Иконка самой погоды
              WeatherIcon(weatherIcon: weatherIcon),

              // Показатель температуры
              Temperature(temperature: temperature, constants: _constants),

              // Статус текущей погоды
              Text(
                currentWeatherStatus,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),

              // Текущая дата
              Text(
                currentDate,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),

              // Горизонтальный разделитель
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,),
                child: Divider(
                  color: Colors.white70,
                ),
              ),

              // Больше информации о скорости ветра, влажности и облачности
              AdditionalWeatherInfo(windSpeed: windSpeed, humidity: humidity, cloud: cloud),
              
             
              
              ],
            )
            ),
             Container(
                padding: const EdgeInsets.only(top: 25),
                height: size.height * .20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                        GestureDetector(
                      onTap: () => 
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (_) => DetailPage(
                            dailyForecastWeather: dailyWeatherForecast,
                          ))
                          ),
                      child: Text(
                        'Forecasts',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: _constants.primaryColor
                        ),
                      ),
                    ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    // Информация о погоде на 24 часа в этот день
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        itemCount: hourlyWeatherForecast.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (hourlyWeatherForecast.isNotEmpty && index < hourlyWeatherForecast.length) {
                            
                          String currentTime = DateFormat("HH:mm:ss").format(DateTime.now());
                          String currentHour = currentTime.substring(0,2);

                          String forecastTime = hourlyWeatherForecast[index]["time"].substring(11, 16);
                          String forecastHour = hourlyWeatherForecast[index]["time"].substring(11, 13);

                          String forecastWeatherName = hourlyWeatherForecast[index]["condition"]["text"];
                          String forecastWeatherIcon = forecastWeatherName.replaceAll(" ", "").toLowerCase() + ".png";

                          String forecastTemperature = hourlyWeatherForecast[index]["temp_c"].round().toString();
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            margin: const EdgeInsets.only(right: 20),
                            width: 65,
                            decoration: BoxDecoration(
                              color: currentHour == forecastHour ? Colors.white : _constants.primaryColor, 
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 3,
                                  color: _constants.primaryColor.withOpacity(.2),
                                )
                              ]
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  forecastTime,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: _constants.greyColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  ),
                                  Image.asset(
                                    "assets/images/pngs/" + forecastWeatherIcon,
                                    width: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        forecastTemperature,
                                        style: TextStyle(
                                          color: _constants.greyColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                       Text(
                                        "o",
                                        style: TextStyle(
                                          color: _constants.greyColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          fontFeatures: [
                                            FontFeature.enable('sups')
                                          ]
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                            
                          );
                        }
                        },
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}









