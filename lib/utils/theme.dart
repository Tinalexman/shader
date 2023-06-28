import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


const Color theme = Color.fromARGB(255, 245, 245, 245);
const Color appYellow = Color.fromARGB(255, 242, 190, 92);
const Color neu = Color.fromARGB(100, 105, 105, 105);
const Color neutral3 = Color.fromARGB(150, 197, 197, 197);
const Color neutral = Color.fromARGB(150, 115, 115, 115);
const Color neutral2 = Color.fromARGB(80, 166, 166, 166);
const Color neutral4 = Color.fromARGB(255, 186, 186, 186);
const Color search = Color.fromARGB(30, 150, 150, 150);
const Color textColor = Color.fromARGB(255, 242, 242, 242);
const Color headerColor = Color.fromARGB(250, 13, 13, 13);
const Color muted = Color.fromARGB(255, 20, 25, 5);
const Color footerColor = Color.fromARGB(255, 37, 38, 37);
const Color mutedWhite = Color.fromARGB(12, 20, 18, 0);
const Color mutedYellow = Color.fromARGB(225, 45, 45, 40);
const Color fadedWhite = Color.fromARGB(100, 255, 255, 255);
const Color containerGreen = Color.fromARGB(255, 108, 216, 106);
const Color percentGreen = Color.fromARGB(220, 60, 150, 60);
const Color percentRed = Color.fromARGB(220, 150, 60, 60);
const Color containerRed = Color.fromARGB(255, 231, 144, 125);
const Color border = Color.fromARGB(150, 218, 218, 218);
const Color linkBlue = Color.fromARGB(255, 25, 18, 210);
const Color headerBlue = Color.fromARGB(255, 35, 1, 243);
const Color selectedWhite = Color.fromARGB(255, 180, 180, 220);
const Color purplePrice = Color.fromARGB(255, 123, 13, 209);
const Color chatBlack = Color.fromARGB(255, 46, 46, 46);
const Color midGrey = Color.fromARGB(255, 128, 128, 128);


const Map<int, Color> _swatchColors = {
  50: Color(0x15313131),
  100: Color(0x30313131),
  200: Color(0x45313131),
  300: Color(0x60313131),
  400: Color(0x75313131),
  500: Color(0x90313131),
  600: Color(0xA5313131),
  700: Color(0xB0313131),
  800: Color(0xCD313131),
  900: Color(0xFF313131)
};

const MaterialColor materialColor = MaterialColor(0xFF313131, _swatchColors);


class KdeTheme
{


  static TextTheme lightTextTheme = TextTheme(
    bodyMedium: TextStyle(
      fontFamily: "Nunito",
      fontSize: 14.sp,
      color: headerColor,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontFamily: "Nunito",
      fontSize: 12.sp,
      color: headerColor,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      fontFamily: "Nunito",
      fontSize: 16.sp,
      color: headerColor,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
        fontFamily: "Nunito",
        fontSize: 28.sp,
        color: headerColor,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
        fontFamily: "Nunito",
        fontSize: 20.sp,
        color: headerColor,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
        fontFamily: "Nunito",
        fontSize: 24.sp,
        color: headerColor,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
        fontFamily: "Nunito",
        fontSize: 12.sp,
        color: headerColor,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontFamily: "Nunito",
      fontSize: 14.sp,
      color: headerColor,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      fontFamily: "Nunito",
      fontSize: 16.sp,
      color: headerColor,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontFamily: "Nunito",
      fontSize: 10.sp,
      color: footerColor,
      fontWeight: FontWeight.w300,
    ),
    labelMedium: TextStyle(
      fontFamily: "Nunito",
      fontSize: 14.sp,
      color: footerColor,
      fontWeight: FontWeight.w300,
    ),
    labelLarge: TextStyle(
      fontFamily: "Nunito",
      fontSize: 16.sp,
      color: footerColor,
      fontWeight: FontWeight.w300,
    )
  );

  static TextTheme darkTextTheme = TextTheme(
      bodyMedium: TextStyle(
        fontFamily: "Nunito",
        fontSize: 14.sp,
        color: theme,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: "Nunito",
        fontSize: 12.sp,
        color: theme,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Nunito",
        fontSize: 16.sp,
        color: theme,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        fontFamily: "Nunito",
        fontSize: 28.sp,
        color: theme,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontFamily: "Nunito",
        fontSize: 20.sp,
        color: theme,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Nunito",
        fontSize: 24.sp,
        color: theme,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontFamily: "Nunito",
        fontSize: 12.sp,
        color: theme,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontFamily: "Nunito",
        fontSize: 14.sp,
        color: theme,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontFamily: "Nunito",
        fontSize: 18.sp,
        color: theme,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontFamily: "Nunito",
        fontSize: 12.sp,
        color: textColor,
        fontWeight: FontWeight.w300,
      ),
      labelMedium: TextStyle(
        fontFamily: "Nunito",
        fontSize: 14.sp,
        color: textColor,
        fontWeight: FontWeight.w300,
      ),
      labelLarge: TextStyle(
        fontFamily: "Nunito",
        fontSize: 16.sp,
        color: textColor,
        fontWeight: FontWeight.w300,
      )
  );

  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    textTheme: lightTextTheme,
    primaryColor: theme,
    primarySwatch: materialColor,
    scaffoldBackgroundColor: theme,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: theme
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: headerColor,
      backgroundColor: theme
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 1.0,
      foregroundColor: theme,
      backgroundColor: appYellow,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: appYellow,
      backgroundColor: theme,
    ),
    snackBarTheme: const SnackBarThemeData(
        backgroundColor: headerColor
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: theme,
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: appYellow,
      labelStyle: lightTextTheme.bodyMedium,
      unselectedLabelStyle: lightTextTheme.labelMedium,
    )

  );

  static ThemeData dark() => ThemeData(
      brightness: Brightness.dark,
      textTheme: darkTextTheme,
      primarySwatch: materialColor,
      appBarTheme: const AppBarTheme(
          foregroundColor: theme,
          backgroundColor: headerColor
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: footerColor
      ),
      primaryColor: headerColor,
      scaffoldBackgroundColor: footerColor,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: theme
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 1.0,
        foregroundColor: theme,
        backgroundColor: appYellow,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: appYellow,
        backgroundColor: headerColor,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: headerColor,
      ),
      tabBarTheme: TabBarTheme(
          indicatorColor: appYellow,
          labelStyle: darkTextTheme.bodyMedium,
        unselectedLabelStyle: darkTextTheme.labelMedium,
      )
  );
}