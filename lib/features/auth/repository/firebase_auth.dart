
import 'dart:io';
import 'package:beemo/bottom_nav_bar.dart';
import 'package:beemo/common/repository/common_firebase_storage_repository.dart';
import 'package:beemo/features/auth/screens/user_information.dart';
import 'package:beemo/features/auth/screens/landing_screen.dart';
import 'package:beemo/features/chats/screens/chat_screen.dart';
import 'package:beemo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




final authRepositoryProvider = Provider((ref) => AuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));


class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  //function to get current user and keep them logged in(but i prefer the traditional firebase stream method);
  Future<UserModel?> getCurrentUserData() async{
    var userData = await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;

    if(userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  //for sending OTP
  Future sendOTP(String? countryCode, String phoneNumber) async{
    try {
      ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(
        "+$countryCode $phoneNumber"
      );
      print("OTP Sent to $countryCode $phoneNumber");
      return confirmationResult;
    }
    on FirebaseAuthException catch (e) {
      Get.snackbar('Error!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

  
  //for authenticating user
  Future authenticateMe(String phoneNumber, String OTP,) async{
    try {
       ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(phoneNumber).whenComplete(() => Get.to(() => UserInfoScreen()));
      UserCredential userCredential = await confirmationResult.confirm(OTP);
      userCredential.additionalUserInfo!.isNewUser
      ? Get.snackbar('Verified!', "Verification successful", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down)
      : Get.snackbar('Ooops!', "This user already exists, but ride on!", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
    on FirebaseAuthException catch (e) {
      Get.snackbar('Error!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    try {
      await auth.signOut().whenComplete(() => Get.to(() => LandingScreen()));
    }
    on FirebaseAuthException catch (e) {
    Get.snackbar('Error!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

  //saves user information(photo, name and other details) to firebase firestore
  void saveUserDataToFirestore(String name,File? profilePic, ProviderRef ref) async{
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = "asset/images/japhet.png"; //search the web and find a blank photo picture later
      if(profilePic != null) {
        photoUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase("profilePic/$uid", profilePic);
      }      
      var user = UserModel(name: name, uid: uid, profilePic: photoUrl, isOnline: true, email: auth.currentUser!.email!, groupId: []);  //change phone number to email
      await firestore.collection('users').doc(uid).set(user.toMap()).whenComplete(() => Get.to(() => BottomNavBar())); //ChatScreen()
    }
    catch (e) {
      Get.snackbar('Oooops!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }




  ///for Android Devices or iOS Devices   
  ////////////////////////////////////////////////////////////
  Future sendOTPForDevice(String phoneNumber,) async{
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async{
          Get.snackbar('Verified!', "we are now a team", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
          //await auth.signInWithCredential(credential).whenComplete(() => Get.snackbar('Sign In Successful!', "you're now a part of us", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down));
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
        },
        codeSent: (String verificationId, int? resendToken,) async{
          verificationId = verificationId;
          print('OTP SENT!');
          //Get.to(() => OTPScreen(phoneNumber: phoneNumber, verificationId: verificationId,));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          Get.snackbar('Session Time Out!', "please input your phone number again", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
        },
      );
    }
    on FirebaseAuthException catch (e) {
      Get.snackbar('Error!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }
  

  Future authenticateForDevice(String OTP, String verificationId) async{
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: OTP);    
      //await auth.signInWithCredential(credential).whenComplete(() => Get.to(() => UserInfoScreen()));
      final authCredential = await auth.signInWithCredential(credential).whenComplete(() => print('YAyyyyyyy success'));
      if(authCredential.user != null) {
        Get.to(() => UserInfoScreen());
      }
      else {
        Get.snackbar('Oooops!', "something went wrong", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
      }
    }
    on FirebaseAuthException catch (e) {
      Get.snackbar('Error!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }
  
  //logged in user data
  Stream<UserModel>userData(String userID) {
    return firestore.collection('users').doc(userID).snapshots().map((event) => UserModel.fromMap(event.data()!));
  }
  
  //with regards to widgets binding observer
  void setUserStateOnline(bool isOnline) async{
    await firestore.collection('users').doc(auth.currentUser!.uid).update({'isOnline': isOnline});
  }

  

}
