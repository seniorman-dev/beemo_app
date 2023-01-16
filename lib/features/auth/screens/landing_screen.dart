import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/custom_button.dart';
import 'package:beemo/features/auth/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';




class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //SizedBox(height: 10,),
                SizedBox(height: 400, width: 400,),
                //Image.asset('asset/images/japhet.png', height: 400, width: 400,),  //height: 400, width: 400,
                //SizedBox(height: size.height / 9,),
                SizedBox(height: 30,),
                Text(
                  'Welcome to B e e m o',
                  style: GoogleFonts.comfortaa(fontSize: 30, fontWeight: FontWeight.w600, color: textColor),
                  textAlign: TextAlign.center,
                ),
                //SizedBox(height: size.height / 9,),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service',
                    textAlign: TextAlign.center,
                    style:  GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w600, color: greyColor),
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: size.width * 0.75,
                  child: CustomButton(
                    text: "AGREE AND CONTINUE", 
                    onPressed: () => Get.to(() => Login())  //Get.to(() => LoginScreen())
                  )
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        )
      ),
    );
  }
}