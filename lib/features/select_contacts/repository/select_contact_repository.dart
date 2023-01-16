import 'package:beemo/features/chats/screens/chat_screen.dart';
import 'package:beemo/features/chats/screens/direct_message.dart';
import 'package:beemo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';


final SelectContactsRepositoryProvider = Provider((ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));



class SelectContactRepository {

  final FirebaseFirestore firestore;
  SelectContactRepository({required this.firestore});
  
  //to get all available contacts from user's device and display them
  Future<List<Contact>> getContacts() async{
    List<Contact> contacts = [];
    try {
      if(await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true,);
        //return contacts;
      }
    }
    catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
    return contacts;
  }


  //to check if selected contact is available in firebase firestore
  void selectContact(Contact selectedContact, int index) async{
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for(var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String contactName = selectedContact.displayName; //.replaceAll(' ',  '');
        print(contactName);
        if(contactName.toLowerCase() == userData.name.toLowerCase()) {
          isFound = true;
          Get.to(() => DirectMessageScreen(name: userData.name, uid: userData.uid));
        }
      }
      //after the for loop
      if(!isFound) {
        Get.snackbar('Ooops!', "This contact is not on beemo", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
      } 
    }
    catch(e) {
      Get.snackbar('Error!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

}