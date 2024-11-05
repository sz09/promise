import 'package:intl/intl.dart';
import 'package:promise/resources/localization/app_localization.dart';

extension DateFormatter on DateTime {
  static String? _locale = null;
  String get localeName {
    return _locale ??= LocalizationService.locale.toString();
  }
  String hourMinAndSeconds() {
    return DateFormat.Hms(localeName).format(this);
  }

  String hourAndMin() {
    return DateFormat.Hm(localeName).format(this);
  }

  String dayMonthYear() {
    return DateFormat.yMMMMd(localeName).format(this);
  }

  String dayMonthYearHourMinute() {
    return '${DateFormat.yMMMMd(localeName).format(this)}, ${DateFormat.Hm(localeName).format(this)}';
  }

  String asString(bool isDateOnly) {
    return isDateOnly ? dayMonthYear() : toString();
  }

  DateTime endOfDay(){
    final duration = Duration(hours: 24 - hour, minutes: 60 - minute, seconds: 60 - second, microseconds: -microsecond, milliseconds: -millisecond);
    return add(duration);
  }
}

extension DateOnlyCompare on DateTime {
  ///Compares only year, month and day components
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension DateUtils on DateTime {
  static int get timestamp => DateTime.now().millisecondsSinceEpoch;

  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}
const _epochTicks = 621355968000000000;
extension TicksOnDateTime on DateTime {
  int get ticksSinceEpoch => microsecondsSinceEpoch * 10 + _epochTicks;
}

class DateTimeConst {
  static const _numDays = 100000000;
  
  static DateTime get min => DateTime.fromMicrosecondsSinceEpoch(0).subtract(const Duration(days: _numDays));
  static DateTime get max => DateTime.fromMicrosecondsSinceEpoch(0).add(const Duration(days: _numDays));
}