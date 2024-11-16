// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressionAdapter extends TypeAdapter<Work> {
  @override
  final int typeId = 7;

  @override
  Work read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Work(
      content: fields[5] as String,
      from: fields[6] as DateTime?,
      to: fields[7] as DateTime?,
      reminder: fields[8] as Reminder,
      scheduleType: fields[9] as ScheduleType,
    )
      ..isDeleted = fields[2] as bool
      ..createdAt = fields[3] as DateTime
      ..updatedAt = fields[4] as DateTime?
      ..id = fields[0] as String
      ..userId = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, Work obj) {
    writer
      ..writeByte(7)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.reminder)
      ..writeByte(2)
      ..write(obj.isDeleted)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
