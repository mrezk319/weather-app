import 'package:weather/weather/repos/weather_repo.dart';

import '../../utils/dio_services.dart';
import '../../utils/errors.dart';
import '../models/model.dart';

class MockWeatherRepository implements WeatherRepository {
  final DioClient dioClient;

  MockWeatherRepository({required this.dioClient});

  @override
  Future<WeatherModel> getWeather(String city) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay

    if (city.toLowerCase() != 'cairo') {
      throw WeatherFailure(message: 'City not found', code: 404);
    }
    final mockData = {
      "location": {
        "name": "Cairo",
        "region": "Al Qahirah",
        "country": "Egypt",
        "lat": 30.05,
        "lon": 31.25,
        "tz_id": "Africa/Cairo",
        "localtime_epoch": 1742035587,
        "localtime": "2025-03-15 12:46"
      },
      "current": {
        "last_updated_epoch": 1742035500,
        "last_updated": "2025-03-15 12:45",
        "temp_c": 28.3,
        "temp_f": 82.9,
        "is_day": 1,
        "condition": {
          "text": "Sunny",
          "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
          "code": 1000
        },
        "wind_kph": 21.6,
        "wind_degree": 30,
        "wind_dir": "NNE",
        "pressure_mb": 1018,
        "precip_mm": 0,
        "humidity": 25,
        "cloud": 0,
        "feelslike_c": 26.3,
        "uv": 7.8,
        "gust_kph": 24.8
      },
      "forecast": {
        "forecastday": [
          {
            "date": "2025-03-15",
            "day": {
              "maxtemp_c": 32.4,
              "mintemp_c": 17.5,
              "avgtemp_c": 23.9,
              "maxwind_kph": 29.9,
              "totalprecip_mm": 0,
              "condition": {
                "text": "Sunny",
                "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
                "code": 1000
              }
            },
            "hour": [
              {
                "time": "2025-03-15 00:00",
                "temp_c": 20.3,
                "condition": {
                  "text": "Clear",
                  "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                  "code": 1000
                },
                "wind_kph": 17.3,
                "humidity": 45,
              },
              // Add other hours following same pattern
            ]
          }
        ]
      }
    };

    return WeatherModel.fromJson(mockData);
  }
}
