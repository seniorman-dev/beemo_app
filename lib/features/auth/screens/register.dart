import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/custom_button.dart';
import 'package:beemo/AuthenticationHelper.dart';
import 'package:beemo/common/widgets/loader.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  AuthenticationHelper service = AuthenticationHelper();
  
  
  // ignore: prefer_typing_uninitialized_variables
  //var temp;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }
  Country? country;
  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
        print('Selected country: ${_country.displayName}');
      },
    );
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
      body: isLoading 
      ? Loader()
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
                  //if(country != null)
                  Text(
                    'Create an account', 
                    style: GoogleFonts.comfortaa(color: textColor, fontSize: 25),
                  ),
                  SizedBox(height: 40,),
                  TextButton(
                    onPressed: pickCountry, 
                    child: Text(
                      "Select your country",
                      style: GoogleFonts.comfortaa(
                        color: tabColor,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ), 
                  SizedBox(height: 20,),   
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
                    //height: 100,
                    width: size.width * 0.7, //0.82,
                    child: Column( //Row
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(country != null)
                        Text('+${country!.phoneCode}', style: GoogleFonts.comfortaa(color: textColor),),
                        SizedBox(width: 5,), //10
                        SizedBox(
                          width: size.width * 0.7, //0.7
                          height: 70,
                          child: TextFormField(
                            //key: formKey,
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
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
                              labelStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                              labelText: 'phone',
                              prefixIcon: Icon(CupertinoIcons.phone, color: Colors.grey),
                              
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
                      ],
                    ),
                  ),
                  SizedBox(height: 20,), 
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
                  //SizedBox(height: size.height * 0.5,),
                  SizedBox(height: 40,),   
                  SizedBox(
                    //width: 90,
                    width: size.width * 0.7,
                    child: CustomButton(
                      text: "REGISTER", 
                      onPressed: () async{
                        if(country != null && formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          service.signUp(email: emailController.text.trim(), phoneNumber: phoneController.text.trim(), password: passwordController.text.trim());
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