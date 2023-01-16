import 'dart:io';
import 'dart:typed_data';
import 'package:beemo/models/user_model.dart';
import 'package:beemo/features/auth/repository/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';





final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

///to keep track of auth state changes
final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();

});




class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.ref, required this.authRepository});
  


  ///to keep track of auth state changes 
  Future<UserModel?> getUserData() async{
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  ////////////////////////////////for mobile
  void signInWithPhoneForDevice(String phoneNumber,){
    authRepository.sendOTPForDevice(phoneNumber,);
  }
  
  void authenticateForDevice(String verificationId, String OTP,) {
    authRepository.authenticateForDevice(verificationId, OTP);
  }

  Stream<UserModel> userDataByID(String userID) {
    return authRepository.userData(userID);
  }

  //with regards to widgets binding observer
  void setUserStateOnline(bool isOnline) async{
    authRepository.setUserStateOnline(isOnline);
  }



  ////////////////////////////////for web
  void signInWithPhone(String? countryCode, String phoneNumber){
    authRepository.sendOTP(countryCode, phoneNumber);
  }
  void authenticateMe(String phoneNumber, String OTP) {
    authRepository.authenticateMe(phoneNumber, OTP);
  }
  void saveUserDataToFirestore(String name, File? profilePic,) {
    authRepository.saveUserDataToFirestore(name, profilePic, ref);
  }
}