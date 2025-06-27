import 'package:timeago/timeago.dart' as timeago;

class DateUtilsHelper {
  static String getTimeAgo(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return timeago.format(dateTime, locale: 'en');
  }
}
