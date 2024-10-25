import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_medial_app/core/utils/preferences.dart';

class SharedPreferencesHelper with Preferences{

  static late final SharedPreferences instance;

  ///--------- pref initialize
  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();


  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Preferences.USERNAME);
  }

  static Future<void> setUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Preferences.USERNAME, username);
  }

  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Preferences.USERNAME) ?? "";
  }

  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Preferences.USERNAME, userId);
  }


  static Future<void> setIsUserLoggedIn(bool isUserLoggedIn) async {
    instance.setBool(Preferences.IS_USER_LOGGED_IN, isUserLoggedIn);
  }


  static Future<bool> getIsUserLoggedIn() async {
    return instance.getBool(Preferences.IS_USER_LOGGED_IN) ?? false;
  }

  static void clearSharedPreference(){
    instance.clear();
  }

}