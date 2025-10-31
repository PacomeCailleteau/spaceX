import 'package:intl/intl.dart';

class DateFormatter {
  static String formatLaunchDate(DateTime date) {
    final format = DateFormat.yMMMMEEEEd('en_US').add_Hm();
    return format.format(date);
  }
}
