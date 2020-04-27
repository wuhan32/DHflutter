import 'package:intl/intl.dart';

class DateTimeUtil{

  //时间日期格式化
  static DateFormat dateTimeFormat= DateFormat("yyyy-MM-dd HH:mm:ss");
  //日期格式化
  static DateFormat dateFormat= DateFormat("yyyy-MM-dd");
  //时间格式化
  static DateFormat timeFormat= DateFormat("HH:mm:ss");


  //毫秒时间戳格式化成日期时间字符串 yyyy-MM-dd HH:ss:mm
  static String formatDateTimeString(int dateTime){
    return dateTimeFormat.format( DateTime.fromMillisecondsSinceEpoch(dateTime));
  }

  //毫秒时间戳格式化成日期字符串  yyyy-MM-dd
  static String formatDateString(int dateTime){
    return dateFormat.format( DateTime.fromMillisecondsSinceEpoch(dateTime));
  }

  //即时消息时间格式化
  static String formatMessageDateTimeString(int dateTime){
    DateTime formatTime=DateTime.fromMillisecondsSinceEpoch(dateTime);
    //当天时间
    if(formatTime.day==DateTime.now().day){
      if(formatTime.hour>=0&&formatTime.hour<4){
        return "凌晨 ${timeFormat.format(formatTime)}";
      }else if(formatTime.hour>=4&&formatTime.hour<12){
        return "上午 ${timeFormat.format(formatTime)}";
      }else if(formatTime.hour>=12&&formatTime.hour<18){
        return "下午 ${timeFormat.format(formatTime)}";
      }else{
        return "晚上 ${timeFormat.format(formatTime)}";
      }
    }else{
      //非当天时间
      return dateTimeFormat.format(formatTime);
    }
  }


}