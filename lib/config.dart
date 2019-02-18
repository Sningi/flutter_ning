import 'package:flutter/material.dart';

class Config {
  static Color topBkg=Color(0xFFF2F2F2);
  static Color light=Color(0xFFD6D5B7);
  static bool dark = false;
  static ThemeData themeData = new ThemeData(primarySwatch:Colors.blue);
  static String font="方正楷体";
  static List<Color> itemColors=[Color(0xFF99CCFF),Color(0xFFD6D5B7),Color(0xFF00E9A4),
                                  Color(0xFFFF99CC),Color(0xFFB19072)];
  static Color containBkg=Colors.white;
  static Color lineColors=Color(0xFFD3D6D8);
  static Color appBackground=Color(0xFFF5F5F5);
  static List<String> fontNames=["方正楷体","安卓系统"];
  static List<String> barCate = ['花名冊','課堂', '成績單', '便箋'];
  static List<String> weekDays=['星期日','星期一','星期二','星期三','星期四','星期五','星期六'];
  static List<String> weekDaysTwo=['周日','周一','周二','周三','周四','周五','周六'];
  static List<String> courseTime=['一\n8:10～9:00','二\n9:10～10:00','三\n10:10～11:00',
                                  '四\n11:10～12:00','五\n13:10～14:00','六\n14:10～15:00',
                                  '七\n15:10～16:00','八\n16:10～17:00'];
}