import 'package:get_storage/get_storage.dart';



//for favorite storage
class ThemeSelect {

  final getStorage = GetStorage('SelectedTheme');
  final storageKey = 'selected?'; //has to be String


  ///optional for String/int. just need to pass in "return getStorage.read(storageKey)" in the getter function above and then change it's corresponding type
  ///simultaneously, you can change it to any Data Type you want
  bool isSavedFavorite() {
    return true;
  }

  //to let get_storage save whatever you want i.e favourites
  void saveFavorite() {
    getStorage.read(storageKey);
    getStorage.write(storageKey, isSavedFavorite()); //favoriteSelector
  }

}