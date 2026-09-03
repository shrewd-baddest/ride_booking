import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF080A0F);
  static const surface = Color(0xFF111827);

  static const primaryText = Color(0xFFFFFFFF);
  static const secondaryText = Color(0xFFCCCCCC);
  static const mutedText = Color(0xFF3A4560);

  static const accent = Color(0xFFFACC15);
  static const success = Color(0xFF4ADE80);
  static const danger = Color(0xFFF87171);
}

final TextTheme rideSwiftTextTheme = const TextTheme(
  // Main page heading: RideSwift
  headlineLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    color: AppColors.primaryText,
  ),

  // Main screen titles: "Arriving in 3 min"
  headlineMedium: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryText,
  ),

  // Screen headings: "Your Rides", "Confirm Payment"
  titleLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  ),

  // Driver names, prices and important values
  titleMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  ),

  // Ride type and payment method names
  titleSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  ),

  // Standard readable text
  bodyLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  ),

  // Location inputs, fare rows and descriptions
  bodyMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  ),

  // Driver details, route names and payment details
  bodySmall: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedText,
  ),

  // Main buttons: "Book Economy", "Pay via M-Pesa"
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.background,
  ),

  // Badges and small actions
  labelMedium: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  ),

  // Section headings: "CHOOSE RIDE", "PAYMENT METHOD"
  labelSmall: TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    color: AppColors.mutedText,
  ),
);
