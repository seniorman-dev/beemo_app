import 'package:beemo/calls.dart';
import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/features/auth/controllers/auth_controller.dart';
import 'package:beemo/features/chats/screens/chat_screen.dart';
import 'package:beemo/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:beemo/features/status/screens/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';




class BottomNavBar extends ConsumerStatefulWidget {
  BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar>{
  

  //pages list
  List pages = [
    SelectContactScreen(),
    ChatScreen(),
    Status(),
    Calls(),
  ];

  //current index for bottom navigation bar
  int currentIndex = 0;

  bool selectedIndex = false;

  //'onTap' function for bottom navigation bar
  void onTap(int index) {
    setState(() {
      currentIndex = index;
      //selectedIndex = !selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        //fixedColor: backgroundColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedFontSize: 9, ///
        selectedFontSize: 9,  ///
        elevation: 0,      
        currentIndex: currentIndex,
        selectedItemColor: tabColor ,
        unselectedItemColor: greyColor,
        selectedLabelStyle: GoogleFonts.comfortaa(color: tabColor, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.comfortaa(color: textColor, fontWeight: FontWeight.bold),
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill,),
            label: 'Contacts'
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_fill),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.phone_solid),
            label: 'Calls',
          ),
        ],
      ),
    );
  }
}