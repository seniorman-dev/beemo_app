import 'dart:io';
import 'dart:typed_data';
import 'package:beemo/common/utils/utils.dart';
import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/custom_button.dart';
import 'package:beemo/features/auth/controllers/auth_controller.dart';
import 'package:beemo/features/auth/repository/firebase_auth.dart';
import 'package:beemo/features/chats/screens/chat_screen.dart';
import 'package:beemo/AuthenticationHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:beemo/common/widgets/loader.dart';






class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  bool isLoading = false;
  AuthenticationHelper service = AuthenticationHelper();
  
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
  
  //works for android and iOS only
  File? image;
  void selectImage() async{
    //image = await pickImageFromGallery();
    setState(() async {
      image = await pickImageFromGallery();
    });
  }

  //works for web only
  /*Uint8List? imagePickerWeb;
  void selectImageForWeb() async{
    //final image = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      //imagePickerWeb = image!;
      imagePickerWeb != null;
    });
  }*/

  void storeUserData() async {
    String name = nameController.text.trim();

    if(name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirestore(name, image);
      //Get.to(() => ChatScreen());
    }
    else {
      Get.snackbar("Don't Skip!", "fill in the required field", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            onPressed: () async{
              await service.signOut();
              //Get.snackbar('Signed Out', "signed out", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);     
            }, 
            icon: Icon(Icons.logout, color: tabColor,)
          )
        ],
      ),
      body: SafeArea(
        child: isLoading 
        ?Loader()
        :SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0), //18
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 40,),
                    Stack(
                      children: [
                        image == null
                        //image == null 
                        ?const CircleAvatar(
                          backgroundImage: AssetImage('asset/images/japhet.png'),
                          radius: 64,
                        )
                        :CircleAvatar(
                          backgroundImage: FileImage(image!),
                          //backgroundImage: FileImage(image!),
                          radius: 64,
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                selectImage();
                              });
                              //selectImage();
                              //selectImageForWeb();
                            }, 
                            icon: Icon(Icons.add_a_photo_rounded, color: tabColor),
                            tooltip: 'select image',
                          ),
                        )
                      ],
                    ),            
                    SizedBox(height: 30,),
                    ///
                    SizedBox(
                      width: size.width * 0.7,
                      //padding: EdgeInsets.all(20),
                      child: TextFormField(
                      //key: formKey,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      autocorrect: true,
                      //inputFormatters: [],
                      enableSuggestions: true,
                      enableInteractiveSelection: true,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(                      
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        //hintText: 'name',
                        //hintStyle: TextStyle(color: Colors.grey),                     
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'name',
                        prefixIcon: Icon(CupertinoIcons.person_circle, color: Colors.grey),
                        //filled: true,
                        //fillColor: Colors.grey,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                      ),
                      /*onFieldSubmitted: (val) {
                        setState(() {
                          val = nameController.text.trim();
                          storeUserData();
                        });
                      },*/
                      /*validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty Field!';
                        }
                        return null;
                      }*/
                      ),
                    ),
                    SizedBox(height: 40,),
                    ///
                    SizedBox(
                      //width: 90,
                      width: size.width * 0.7,
                      child: CustomButton(
                        text: "SAVE", 
                        onPressed: (){ 
                          //nameController.clear();
                          storeUserData();
                        }
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      /*bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: service.firestore.collection('users').doc(service.userID).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            }
            else if(snapshot.hasData) {
              final data = snapshot.data!;
              return Align(
                  alignment: Alignment.center,
                  child: Card(
                    color: tabColor,
                    //shape: Border(
                      //top: BorderSide()
                    //),
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            data['name'],
                            style: GoogleFonts.comfortaa(fontSize: 14, fontWeight: FontWeight.w700, color: textColor)
                          ),
                          Text(
                            data['email'],
                            style: GoogleFonts.comfortaa(fontSize: 14, fontWeight: FontWeight.w700, color: textColor)
                          ),
                          Text(
                            data['uid'],
                            style: GoogleFonts.comfortaa(fontSize: 14, fontWeight: FontWeight.w700, color: textColor)
                          ),
                          Text(
                            data['isOnline'].toString(),
                            style: GoogleFonts.comfortaa(fontSize: 14, fontWeight: FontWeight.w700, color: textColor)
                          ),
                        ],
                      ),
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
      ),*/
    );
  }
}