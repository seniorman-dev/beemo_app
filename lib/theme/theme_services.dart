import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



//for theme mode
class ThemeService {

  final getStorage = GetStorage('ThemeBox');
  final storageKey = "isDarkMode"; //has to be String

  //for getting the ThemeMode
  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  //// optional for String/int. just need to pass in "return getStorage.read(storageKey)" in the getter function above and then change it's corresponding type
  ///simultaneously, you can change it to any Data Type you want
  bool isSavedDarkMode() {
    return getStorage.read(storageKey) ?? false;
  }

  //to let get_storage save whatever you want
  void saveThemeMode(bool isDarkMode) {
    getStorage.write(storageKey, isDarkMode);
  }

  // for setting the ThemeMode in the widget (e.g Text Widget)
  void setThemeMode() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeMode(!isSavedDarkMode());
  }
}




