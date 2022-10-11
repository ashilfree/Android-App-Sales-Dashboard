import 'package:date_format/date_format.dart';

class ConvertHelper {
  static String convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    return formatDate(todayDate,
        [dd, '/', mm, '/', yyyy]);
  }

  static String convertTimeFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    return formatDate(todayDate,
        [hh, ':', mm]);
  }

  static int toInt(value) {
    double multiplier = .5;
    return (multiplier * value).round();
  }
}