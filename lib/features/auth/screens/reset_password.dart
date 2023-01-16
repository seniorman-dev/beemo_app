import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/custom_button.dart';
import 'package:beemo/features/auth/screens/register.dart';
import 'package:beemo/AuthenticationHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  AuthenticationHelper service = AuthenticationHelper();
  
  
  // ignore: prefer_typing_uninitialized_variables
  //var temp;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0), //18
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  Text(
                    "Let's get you back on track", 
                    style: GoogleFonts.comfortaa(color: textColor, fontSize: 25),
                  ),
                  SizedBox(height: 40,),   
                  SizedBox(
                    //height: 50,
                    width: size.width * 0.7,
                    child: TextFormField(
                      //key: formKey,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: true,
                      inputFormatters: [],
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        //hintText: 'phone number',
                        //hintStyle: TextStyle(color: Colors.grey),                     
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'email',
                        prefixIcon: Icon(CupertinoIcons.mail, color: Colors.grey),
                        //filled: true,
                        //fillColor: Colors.grey,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        /*onSaved: (val) {
                          password = val;
                        },*/
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty Field!';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 40,), 
                  SizedBox(
                    //width: 90,
                    width: size.width * 0.7,
                    child: CustomButton(
                      text: "RESET", 
                      onPressed: () async{
                        if(formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          service.resetPassword(email: emailController.text.trim());
                        }
                      }
                    )
                  ),
                  SizedBox(height: 10,),
                ]
              ),
            )
          ),
        ),
      )
    );
  }
}