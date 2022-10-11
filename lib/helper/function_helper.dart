import 'package:intl/intl.dart';

String currencyFormatMd(String date, {String abv = ''}) {
  final oCcy = NumberFormat("#,##0.00", "en_US");
  return '${oCcy.format(double.parse(date))} $abv';
}

String currencyFormat(String date) {
  final oCcy = NumberFormat("#,##0.00", "en_US");
  return '${oCcy.format(double.parse(date))} DA';
}

String numberFormat(double number) {
  var f = new NumberFormat("###.0#", "en_US");
  return f.format(number);
}
