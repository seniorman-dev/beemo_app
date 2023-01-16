import 'dart:typed_data';

//import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';





 Future<File?> pickImageFromGallery() async{
  File? image;
  //String imagePath = "";
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null) {
      //imagePath = pickedImage.path;
      //print(imagePath);
      image = File(pickedImage.path);
      //Uint8List imagebytes = await image.readAsBytes();
    }
    else {
      Get.snackbar('Uh oh!', "no image was selected", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }
  catch (e) {
    Get.snackbar('Error!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
  }
  return image;
}



Future<File?> pickImageFromCamera() async{
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if(pickedImage != null) {
      image = File(pickedImage.path);
    }
    else {
      Get.snackbar('Uh oh!', "no image was selected", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }
  catch (e) {
    Get.snackbar('Error!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
  }
  return image;
}

Future<File?> pickVideoFromGallery() async{
  File? video;
  try {
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if(pickedVideo != null) {
      video = File(pickedVideo.path);
    }
    else {
      Get.snackbar('Uh oh!', "no video was selected", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }
  catch (e) {
    Get.snackbar('Error!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
  }
  return video;
}

//for GIF's or Stickers
/*Future<GiphyGif?> pickGIF(BuildContext context) async{
  // KYvd8fNIbXANhytLm0WMZn1NIIwSIUvD ===>> my Giphy API Key
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(context: context, apiKey: 'KYvd8fNIbXANhytLm0WMZn1NIIwSIUvD');
  }
  catch(e) {
    Get.snackbar('Error!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
  }
  return gif;
}*/
