
class ApiEndpoints {
  // Base URL for the API
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/';

  static const String _apiKey = "e20dbf27bf4e97004090e8b3bda3eec3";


  // ------------- Complete URL methods
  static String getWeatherAPIUrl(String city) {
    return '${_baseUrl}weather?q=$city&units=metric&appid=$_apiKey';
  }

  static String getWeatherByCoordinatesAPIUrl(double lat, double lon) {
    return '${_baseUrl}weather?lat=$lat&lon=$lon&units=metric&appid=$_apiKey';
  }

}
