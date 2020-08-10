import 'package:intl/intl.dart';

class TimeUtils {
  static String getSecondString(String time) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  /// 入参：{2020-06-12 14:13:31}
  static String getFromHourToSecondString(String time) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = inputFormat.parse(time);
    DateFormat outputFormat = DateFormat("HH:mm:ss");
    return outputFormat.format(dateTime);
  }

  static String getFromYearToDayString(int timeString) {
    var now = new DateTime.fromMillisecondsSinceEpoch(timeString);
//    var format = new DateFormat('yyyy-MM-dd');
//    var date = new DateTime.fromMillisecondsSinceEpoch(timeString);
//    var diff = now.difference(date);
//    var time = '';
//
//    if (diff.inSeconds <= 0 ||
//        diff.inSeconds > 0 && diff.inMinutes == 0 ||
//        diff.inMinutes > 0 && diff.inHours == 0 ||
//        diff.inHours > 0 && diff.inDays == 0) {
//      time = format.format(date);
//    }
    return now.toString();
  }
}
