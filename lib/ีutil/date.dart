import 'package:intl/intl.dart';

class DateTimeUtil {
  // Get current date and time
  static DateTime getCurrentDateTime() {
    return DateTime.now();
  }

  // Format DateTime to string
  static String formatDateTimeYMD(DateTime dateTime) {
    print(dateTime);
    String format = "yyyy-MM-dd";
    return DateFormat(format).format(dateTime);
  }

  static String formatDateTimeHMS(DateTime dateTime) {
    String format = 'HH:mm:ss';
    print(dateTime);
    return DateFormat(format).format(dateTime);
  }

  static String formatDate(DateTime? dateTime) {
    return DateFormat('วันที่ dd-MM-yyyy').format(dateTime!.toLocal());
  }

  static String formatTime(DateTime? dateTime) {
    return DateFormat('เวลา HH:mm').format(dateTime!.toLocal());
  }
}
