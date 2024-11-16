class ScheduleOption {
    final String  text;
    final ScheduleType value;
    ScheduleOption({required this.text, required this.value});
}

enum ScheduleType {
  WeekDays,
  WorkingDays
}