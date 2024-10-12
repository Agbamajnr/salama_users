import 'package:flutter/material.dart';
import 'package:salama_users/constants/colors.dart';

final textInputDecoration = InputDecoration(
  // fillColor: AppColors.inputFieldColor,
  filled: false,
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: AppColors.primaryGrey, width: 1)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: const BorderSide(
        width: 1,
        // color: AppColors.background
      )),
  disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: AppColors.primaryGrey, width: 1)),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        width: 2,
        color: Colors.red,
      )),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        width: 2,
        color: Colors.red,
      )),
  errorStyle: const TextStyle(
    // height: ,
    color: Colors.redAccent,
  ),
  labelStyle: const TextStyle(
    color: AppColors.labelTextColor,
  ),
  hintStyle: TextStyle(
    color: const Color(0xff000000).withOpacity(0.4),
    //TODO: add font family
    // fontFamily: AppFonts.manRope,
    fontSize: 14.0,
  ),
);
