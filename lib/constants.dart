import 'package:flutter/material.dart';

const Color kSecondaryColor = Color(0xFFFF6C29);
// const Color kPrimaryColor = Color(0xFF66DE93);
const Color kPrimaryColor = Color(0xff18978f);
// const Color kPrimaryColor = Color(0xFF3D8361);
const double kDefaultPadding = 20.0;

const ksmallHeading = TextStyle(
    color: kSecondaryColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: "Merriweather");

InputDecoration kTextField = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 2,
        )),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: kPrimaryColor,
          width: 2,
        )));

const kdefaultNumberStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontFamily: "Montserrat",
  color: Colors.black,
);
