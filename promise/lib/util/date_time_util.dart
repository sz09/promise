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
  
  String dayShortMonthYear() {
    return DateFormat.yMMMd(localeName).format(this);
  }
  
  String dayMonthYearHourMinute() {
    return '${DateFormat.yMMMMd(localeName).format(this)}, ${DateFormat.Hm(localeName).format(this)}';
  }

  String asString({required bool isDateOnly, bool shortMonth = false}) {
    return isDateOnly ? (shortMonth ? dayShortMonthYear() : dayMonthYear()): toString();
  }

  String yearMonthDay(){
    return DateFormat('yyyy-MM-dd').format(this);
  }

  DateTime endOfDay(){
    final duration = Duration(hours: 24 - hour, minutes: 60 - minute, seconds: 60 - second, microseconds: -microsecond, milliseconds: -millisecond);
    return add(duration);
  }
  
  DateTime startOfDay(){
    final duration = Duration(hours: -hour, minutes: -minute, seconds: -second, microseconds: -microsecond, milliseconds: -millisecond);
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



  DateTime? minWhereNotNull(DateTime? d1, DateTime? d2) {
   if(d1 == null || d2 == null){
    return d1 ?? d2;
   }

   return d1.compareTo(d2) > 0 ? d2 : d1;
  }