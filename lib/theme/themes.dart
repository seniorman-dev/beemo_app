import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';



class Themes {
  //light theme
  final lightTheme = ThemeData.light().copyWith(
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    tabBarTheme: TabBarTheme(
      //indicator: BoxDecoration(color:Colors.indigo.shade900),
      labelColor: Colors.black,
      labelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600, fontSize: 10,),
      unselectedLabelColor: Colors.grey.withOpacity(0.7),
      unselectedLabelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600, fontSize: 10,),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedLabelStyle: GoogleFonts.nunitoSans(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.nunitoSans(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
      unselectedItemColor: Colors.grey.withOpacity(0.7),
      unselectedIconTheme: IconThemeData(
        color: Colors.grey.withOpacity(0.7),
        //shadows: [BoxShadow(color: Colors.white)]
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      selectedIconTheme: IconThemeData(
        color: Colors.black,
        //shadows: [BoxShadow(color: Colors.white)]
      )
    ),
    cardTheme: CardTheme(
      shadowColor: Colors.white,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)  
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      //backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.comfortaa(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 22,),
      iconTheme: IconThemeData(
        color: Colors.black, //white
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.amber
      ),
      centerTitle: true,
      titleSpacing: 4,
    ),
    iconTheme: IconThemeData(
      color: Colors.black, //indigo.shade900,
    ),
    //buttonTheme: ,
    //buttonColor: Colors.black, //black,
    primaryTextTheme: TextTheme(
      bodyText1: GoogleFonts.comfortaa(color: Colors.black)
    ),
    //textTheme: TextTheme(bodyText1: GoogleFonts.nunitoSans(color: Colors.black)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.amber
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.white,
      textColor: Colors.black,
      iconColor: Colors.amber,
      horizontalTitleGap: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.black, //grey.shade400,
          style: BorderStyle.solid,
          width: 2
        ),
      ),
      //style: ListTileStyle.
    ),
  );
  
  //dark theme
  final darkTheme = ThemeData.dark().copyWith(
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.black,
    tabBarTheme: TabBarTheme(
      //indicator: BoxDecoration(color:Colors.white),
      labelColor: Colors.white,
      labelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600, fontSize: 10,),
      unselectedLabelColor: Colors.grey.withOpacity(0.7),
      unselectedLabelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600, fontSize: 10,),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedLabelStyle: GoogleFonts.nunitoSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.nunitoSans(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
      unselectedItemColor: Colors.grey.withOpacity(0.7),
      unselectedIconTheme: IconThemeData(
        color: Colors.grey.withOpacity(0.7),
        //shadows: [BoxShadow(color: Colors.white)]
      ),
      elevation: 0,
      selectedItemColor: Colors.white,
      selectedIconTheme: IconThemeData(
        color: Colors.white,
        //shadows: [BoxShadow(color: Colors.white)]
      )
    ),
    cardTheme: CardTheme(
      shadowColor: Colors.black,
      color: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)  
      ),
    ),

    appBarTheme: AppBarTheme(
      color: Colors.black, //white12
      elevation: 0,
      //backgroundColor: Colors.white30,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: GoogleFonts.comfortaa(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22,),
      iconTheme: IconThemeData(
        color: Colors.white, //white
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.amber
      ),
      centerTitle: true,
      titleSpacing: 4,
    ),
    iconTheme: IconThemeData(
      color: Colors.white, //white
    ),
    //buttonTheme: ,
    //buttonColor: Colors.white, //black,
    primaryTextTheme: TextTheme(
      bodyText1: GoogleFonts.comfortaa(color: Colors.white)
    ),
    //textTheme: TextTheme(bodyText1: GoogleFonts.nunitoSans(color: Colors.indigo)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.amber
    ),
    listTileTheme: ListTileThemeData(
      //style: ListStyle(),
      tileColor: Colors.black,
      textColor: Colors.white,
      iconColor: Colors.amber,
      horizontalTitleGap: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.amber, //.grey.shade400,
          style: BorderStyle.solid,
          width: 2
        ),
      ),
      //style: ListTileStyle.
    ),
  );
}