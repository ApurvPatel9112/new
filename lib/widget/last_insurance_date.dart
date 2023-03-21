import 'package:intl/intl.dart';

String LastInsuranceDate(String datetime, int term) {
  DateTime lastdate = DateTime.parse(datetime);
  int counter = term;
  while (counter > 0) {
    if (((lastdate.year % 4 == 0) &&
        ((lastdate.year % 400 == 0) || (lastdate.year % 100 != 0)))) {
      lastdate = DateTime.parse(lastdate.toString()).add(Duration(days: 366));
      print('lastdate is');
      print(lastdate);
    } else {
      lastdate = DateTime.parse(lastdate.toString()).add(Duration(days: 365));
      print('lastdate is');
      print(lastdate);
    }
    counter--;
  }
  if (((lastdate.year % 4 == 0) &&
          ((lastdate.year % 400 == 0) || (lastdate.year % 100 != 0))) &&
      lastdate.month > 2) {
    lastdate = DateTime.parse(lastdate.toString()).add(Duration(days: 1));
  }
  return DateFormat('yyyy-MM-dd').format(DateTime.parse(lastdate.toString()));
}
