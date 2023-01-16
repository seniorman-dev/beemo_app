import 'package:beemo/bottom_nav_bar.dart';
import 'package:beemo/features/auth/screens/landing_screen.dart';
import 'package:beemo/features/auth/screens/login.dart';
import 'package:beemo/features/auth/screens/user_information.dart';
import 'package:beemo/features/chats/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class AuthenticationHelper {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  String get userID => _auth.currentUser!.uid;
  String? get userDisplayName => _auth.currentUser!.displayName;
  String? get userEmail => _auth.currentUser!.email;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore get firestore => _firestore;

  //SIGN UP / REGISTER METHOD
  Future signUp({required String email, required String phoneNumber, required String password}) async {
    try {
      User appUser = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user!;
      if(appUser != null) {
        //call firestore to add the new user
        //await DatabaseService(uid: appUser.uid).addingUserData(fullName, email, password, userName);
        Get.to(() => UserInfoScreen());
        return true;
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oooops!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }
  
  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      User appUser = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user!;
      if(appUser != null) {
        Get.to(() => BottomNavBar());  //BottomBar()
        //just return true
        return true;
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oooops!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }


  //SIGN OUT METHOD
  Future<void> signOut() async {
    try {
      await _auth.signOut()
      .whenComplete(() => Get.to(() => Login()));
    }
    on FirebaseAuthException catch (e) {
    Get.snackbar('Oooops!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

  //ResetPassword Method
  Future resetPassword ({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email)
      .whenComplete(() =>Get.snackbar('Request Successful!', "a link has been sent to your email to reset your password", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down));
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oooops!', "${e.message}", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }
}