import 'package:beemo/AuthenticationHelper.dart';
import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/loader.dart';
import 'package:beemo/features/auth/screens/user_information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class UserDetails extends StatefulWidget {
  UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  AuthenticationHelper service = AuthenticationHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        //title: Text(''),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor,),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const UserInfoScreen());
            }, 
            icon: Icon(CupertinoIcons.info_circle, color: tabColor,)
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: StreamBuilder<DocumentSnapshot>(
            stream: service.firestore.collection('users').doc(service.userID).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              else if(snapshot.hasData) {
                final data = snapshot.data!;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50,),
                        Text(
                          "username: ${data['name']}",
                          style: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w700, color: textColor)
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "user-email: ${data['email']}",
                          style: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w700, color: textColor)
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "user-id: ${data['uid']}",
                          style: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w700, color: textColor)
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "isOnline: ${data['isOnline']}".toString(),
                          style: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w700, color: textColor)
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                );
              }
              else if(snapshot.hasError) {
                print('${snapshot.error}');
                return Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red,),);
              }
              else {
                return Text('something went wrong...', style: GoogleFonts.comfortaa(color: textColor),); //Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red,),);
              }
            }
          )
        ),
      ),
    );
  }
}