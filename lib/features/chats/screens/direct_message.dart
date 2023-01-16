import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/loader.dart';
import 'package:beemo/features/auth/controllers/auth_controller.dart';
import 'package:beemo/features/chats/widgets/bottom_chat_field.dart';
import 'package:beemo/features/chats/widgets/chat_list.dart';
import 'package:beemo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';



class DirectMessageScreen extends ConsumerWidget {
  const DirectMessageScreen({Key? key, required this.name, required this.uid}) : super(key: key);
  final String name;
  final String uid;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataByID(uid),
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Loader();
              }
              else if (snapshot.hasData) {
                return Row(
                  children: [
                    SizedBox(width: 5,),
                    //back button could be here
                    IconButton(
                      onPressed: () {
                        Get.back();
                      }, 
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor,)
                    ),
                    SizedBox(width: 5,),
                    CircleAvatar(
                      backgroundColor: Colors.pink.shade400.withOpacity(0.5),
                      radius: 22,
                      child: Text(
                        name.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.comfortaa(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)
                      )
                    ),
                    SizedBox(width: 10,),
                    //wrap with expanded
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name, 
                          style: GoogleFonts.comfortaa(color: textColor, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          snapshot.data!.isOnline 
                          ? 'online'
                          : 'offline', 
                          style: GoogleFonts.comfortaa(color: textColor, fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    //SizedBox(width: 5,),
                  ],
                );
              }
              else {
                return Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red,),);
              }
            }
          ),
        ),
        /*leading: IconButton(
          onPressed: () {
            Get.back();
          }, 
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor,)
        ),*/
        actions: [
          IconButton(
            onPressed: () { }, 
            icon: Icon(Icons.video_call_rounded, color: tabColor,)
          ),
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.call_rounded, color: tabColor,)
          )
        ],
      ),
      body: SafeArea(
        child: Column(  //Stack
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: ChatList(receiverUserId: uid, name: name)), //expanded
            BottomChatField(receiverUserId: uid,)  //removed align
          ],
        ),
      ),
      //bottomNavigationBar: BottomChatField(receiverUserId: uid,),
    );
  }
}

