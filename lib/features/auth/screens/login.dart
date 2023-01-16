import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/custom_button.dart';
import 'package:beemo/common/widgets/loader.dart';
import 'package:beemo/features/auth/screens/register.dart';
import 'package:beemo/features/auth/screens/reset_password.dart';
import 'package:beemo/AuthenticationHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  AuthenticationHelper service = AuthenticationHelper();
  
  
  // ignore: prefer_typing_uninitialized_variables
  //var temp;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      body: isLoading 
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 90,),
                  Text(
                    'Login in to continue', 
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
                  SizedBox(height: 20),
                  SizedBox(
                    //height: 50,
                    width: size.width * 0.7,
                    child: TextFormField(
                      //key: formKey,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
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
                        labelText: 'password',
                        prefixIcon: Icon(CupertinoIcons.padlock, color: Colors.grey),
                        //filled: true,
                        //fillColor: Colors.grey,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty Field!';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.to(() => ResetPassword());
                        }, 
                        child: Text(
                          "Forgot password?", 
                          textAlign: TextAlign.center,
                          style: GoogleFonts.comfortaa(color: tabColor, decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                
                  //SizedBox(height: size.height * 0.5,),
                  SizedBox(height: 20,),   
                  SizedBox(
                    //width: 90,
                    width: size.width * 0.7,
                    child: CustomButton(
                      text: "LOGIN", 
                      onPressed: () async{
                        if(formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          service.signIn(email: emailController.text.trim(), password: passwordController.text.trim());
                        }
                      }
                    )
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Get.to(() => Register()),                   
                        child: Text(
                          "Don't have an account?", 
                          style: GoogleFonts.comfortaa(
                            color: tabColor,
                            decoration: TextDecoration.underline
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                ]
              ),
            )
          ),
        ),
      )
    );
  }
}