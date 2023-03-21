import 'package:intl/intl.dart';

String NextPremiumDate(String datetime) {
  DateTime nextdate = DateTime.parse(datetime);
  while (nextdate.isBefore(DateTime.now())) {
    if (((nextdate.year % 4 == 0) &&
        ((nextdate.year % 400 == 0) || (nextdate.year % 100 != 0)))) {
      nextdate = DateTime.parse(nextdate.toString()).add(Duration(days: 366));
      print('next date is');
      print(nextdate);
    } else {
      nextdate = DateTime.parse(nextdate.toString()).add(Duration(days: 365));
      print('next date is');
      print(nextdate);
    }
  }
  if (((nextdate.year % 4 == 0) &&
          ((nextdate.year % 400 == 0) || (nextdate.year % 100 != 0))) &&
      ((nextdate.month == 2 && nextdate.day > 28) || nextdate.month > 2)) {
    nextdate = DateTime.parse(nextdate.toString()).add(Duration(days: 1));
  }
  return DateFormat('yyyy-MM-dd').format(DateTime.parse(nextdate.toString()));
}
