import 'package:beemo/common/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  CustomButton({Key? key, required this.text, required this.onPressed}) : super(key: key);
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: GoogleFonts.comfortaa(color: backgroundColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor:  tabColor,
        minimumSize: Size(double.infinity, 50)
      ),
    );
  }
}